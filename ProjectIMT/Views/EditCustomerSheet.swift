//
//  EditCustomerSheet.swift
//  ProjectIMT
//
//  Created by facetoface on 20/01/2022.
//
// Edit and save the modification of a customer in CoreData.

import SwiftUI

struct EditCustomerSheet: View {
    
    @Binding var showEditCustomerSheet: Bool
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [])
    private var customers2: FetchedResults<Customer2>
    
    @State var first_name: String = ""
    @State var last_name: String = ""
    
    @State var showAlert = false
    var customer : Customer2
    
    var body: some View {
        Form{
            Section(header: Text("Prénom")){
                TextField(customer.first_name ?? "", text: $first_name) .padding()
            }
            Section(header: Text("Nom")){
                TextField(customer.last_name ?? "", text: $last_name) .padding()
            }
            Section{
                Button("Modifier patient") {
                    self.editPatient()
                }.padding()
                .alert("Veuillez saisir le prénom du patient...", isPresented: $showAlert) {
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
    
    func editPatient(){
        //save the modification in CoreData
        if (self.first_name != "") {
            customer.last_name = last_name
            customer.first_name = first_name
            saveContext()
            self.showEditCustomerSheet = false
        } else {
            self.showAlert = true
        }
    }
}
