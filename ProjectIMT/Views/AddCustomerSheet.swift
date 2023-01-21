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
    @State var birthday_date = Date()
    
    @State var showAlert = false
    
    var body: some View{
        Form{
            Section{
                TextField("Prénom", text: $first_name) .padding()
                TextField("Nom", text: $last_name) .padding()
            }
            Section {
                DatePicker(
                    "Date de naissance",
                    selection: $birthday_date,
                    displayedComponents: [.date]
                )
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
            newCust.birthday_date = birthday_date
            self.showAddCustomerSheet = false
        } else {
            self.showAlert = true
        }
        saveContext()
    }
}
