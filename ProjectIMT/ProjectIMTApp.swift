//
//  ProjectIMTApp.swift
//  ProjectIMT
//
//  Created by facetoface on 05/01/2022.
//

import SwiftUI

@main
struct ProjectIMTApp: App {
    let persistenceContainer = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            MainView().environment(\.managedObjectContext,persistenceContainer.container.viewContext)
        }
    }
    
}
