//
//  AddCustomerSheet.swift
//  ProjectIMT
//
//  Created by facetoface on 10/01/2023.
//

import SwiftUI

struct AddCustomerSheet: View {
    
    @Binding var showAddCustomerSheet: Bool
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [])
    private var customers2: FetchedResults<Customer2>

    @State var first_name: String = ""
    @State var last_name: String = ""
    
    @State var showAlert = false
    
    var body: some View{
        Form{
            Section(header: Text("Prénom")){
                TextField("", text: $first_name) .padding()
            }
            Section(header: Text("Nom")){
                TextField("", text: $last_name) .padding()
            }
            Section{
                Button(action: addPatient) {
                    Text("Ajouter patient")
                } .alert("Veuillez saisir le prénom du patient...", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                }
            }
        }
    }
    
    func saveContext(){
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
    
    func addPatient(){
        if (self.first_name != "") {
            let newCust = Customer2(context: viewContext)
            newCust.last_name = last_name
            newCust.id = UUID()
            newCust.first_name = first_name
            self.showAddCustomerSheet = false
        } else {
            self.showAlert = true
        }
        saveContext()
    }
}
