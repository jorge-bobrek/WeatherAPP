//
//  DependencyContainerKey.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

import SwiftUI

struct DependencyContainerKey: EnvironmentKey {
    static let defaultValue: DependencyContainer = DependencyContainer()
}

extension EnvironmentValues {
    var dependencyContainer: DependencyContainer {
        get { self[DependencyContainerKey.self] }
        set { self[DependencyContainerKey.self] = newValue }
    }
}
