//
//  FavoritesRepository.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 29/01/25.
//

import CoreData

class FavoritesRepository: AnyFavoritesRepository {
    private let persistence: PersistenceManager

    init(persistence: PersistenceManager = PersistenceManager.shared) {
        self.persistence = persistence
    }
    
    func fetchFavorites() throws -> [LocationModel] {
        let request: NSFetchRequest<FavoriteLocation> = FavoriteLocation.fetchRequest()
        let items = try persistence.container.viewContext.fetch(request)
        return items.map({ item in
            LocationModel(id: Int(item.id), name: item.name ?? "Unknown", country: item.country ?? "Unknown")
        })
    }
    
    func addFavorite(_ location: LocationModel) throws {
        let newItem = FavoriteLocation(context: persistence.container.viewContext)
        newItem.id = Int64(location.id)
        newItem.name = location.name
        newItem.country = location.country
        try persistence.container.viewContext.save()
    }
    
    func removeFavorite(_ location: LocationModel) throws {
        let request: NSFetchRequest<FavoriteLocation> = FavoriteLocation.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", Int64(location.id))
        if let favorite = try persistence.container.viewContext.fetch(request).first {
            persistence.container.viewContext.delete(favorite)
            try persistence.container.viewContext.save()
        }
    }
}
