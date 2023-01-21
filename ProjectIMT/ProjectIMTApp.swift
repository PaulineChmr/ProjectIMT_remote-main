//
//  ProjectIMTApp.swift
//  ProjectIMT
//
//  Created by Maël Trouillet on 05/01/2022.
//

import SwiftUI

@main
struct ProjectIMTApp: App {
    let persistenceContainer = PersistenceController.shared
    
    //@StateObject var customersListManager = CustomersListManager()
    
    var body: some Scene {
        WindowGroup {
            MainView().environment(\.managedObjectContext,persistenceContainer.container.viewContext)
        }
    /*
    @StateObject var customersListManager = CustomersListManager()
        
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(customersListManager)
        }*/
    }
    
}
