//
//  MainView.swift
//  ProjectIMT
//
//  Created by Maël Trouillet on 05/01/2022.
//

import SwiftUI
import CoreData

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
        
    @FetchRequest(sortDescriptors: [])
    private var customers2: FetchedResults<Customer2>
    
    var body: some View{
        CustomersListView()
    }
}
