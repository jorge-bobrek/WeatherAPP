//
//  PersistenceManager.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

import CoreData

struct PersistenceManager {
    static let shared = PersistenceManager()

    @MainActor
    static let preview: PersistenceManager = {
        let result = PersistenceManager(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<10 {
            let newItem = FavoriteLocation(context: viewContext)
            newItem.id = Int64(i)
            newItem.name = "Name \(i)"
            newItem.country = "Country \(i)"
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

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
}
