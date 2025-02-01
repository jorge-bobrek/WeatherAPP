//
//  PersistenceError.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 1/02/25.
//


enum PersistenceError: Error, Equatable {
    case fetchFailed(description: String)
    case saveFailed(description: String)
    case deleteFailed(description: String)
    case itemNotFound

    var localizedDescription: String {
        switch self {
        case .fetchFailed(let description):
            return "Failed to fetch data: \(description)"
        case .saveFailed(let description):
            return "Failed to save data: \(description)"
        case .deleteFailed(let description):
            return "Failed to delete data: \(description)"
        case .itemNotFound:
            return "Item not found in the database."
        }
    }

    static func == (lhs: PersistenceError, rhs: PersistenceError) -> Bool {
        switch (lhs, rhs) {
        case (.fetchFailed(let lhsError), .fetchFailed(let rhsError)):
            return lhsError == rhsError
        case (.saveFailed(let lhsError), .saveFailed(let rhsError)):
            return lhsError == rhsError
        case (.deleteFailed(let lhsError), .deleteFailed(let rhsError)):
            return lhsError == rhsError
        case (.itemNotFound, .itemNotFound):
            return true
        default:
            return false
        }
    }
}
