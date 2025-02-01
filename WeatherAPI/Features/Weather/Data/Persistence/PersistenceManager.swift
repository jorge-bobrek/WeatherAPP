//
//  PersistenceManager.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

import CoreData

protocol AnyPersistenceManager {
    func fetchFavorites() async throws -> [LocationModel]
    func addFavorite(_ location: LocationModel) async throws
    func removeFavorite(_ location: LocationModel) async throws
}

struct PersistenceManager: AnyPersistenceManager {
    static let shared = PersistenceManager()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Favorites")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func fetchFavorites() async throws -> [LocationModel] {
        return try await performBackgroundTask { context in
            let request: NSFetchRequest<FavoriteLocation> = FavoriteLocation.fetchRequest()
            let items = try context.fetch(request)
            return items.map { item in
                LocationModel(id: Int(item.id), name: item.name ?? "Unknown", country: item.country ?? "Unknown")
            }
        }
    }

    func addFavorite(_ location: LocationModel) async throws {
        try await performBackgroundTask { context in
            if try fetchFavorite(by: location.id, in: context) == nil {
                let newItem = FavoriteLocation(context: context)
                newItem.id = Int64(location.id)
                newItem.name = location.name
                newItem.country = location.country
                try context.save()
            } else {
                throw PersistenceError.saveFailed(description: "Favorite already exists")
            }
        }
    }

    func removeFavorite(_ location: LocationModel) async throws {
        try await performBackgroundTask { context in
            if let favorite = try fetchFavorite(by: location.id, in: context) {
                context.delete(favorite)
                try context.save()
            } else {
                throw PersistenceError.itemNotFound
            }
        }
    }
}

extension PersistenceManager {
    private func fetchFavorite(by id: Int, in context: NSManagedObjectContext) throws -> FavoriteLocation? {
        let request: NSFetchRequest<FavoriteLocation> = FavoriteLocation.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", Int64(id))
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    private func performBackgroundTask<T>(_ task: @escaping (NSManagedObjectContext) throws -> T) async throws -> T {
        let context = container.newBackgroundContext()
        return try await withCheckedThrowingContinuation { continuation in
            context.perform {
                do {
                    let result = try task(context)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
