//
//  EditCustomerSheet.swift
//  ProjectIMT
//
//  Created by Maël Trouillet on 20/01/2022.
//

import SwiftUI

struct EditCustomerSheet: View {
    
    @Binding var showEditCustomerSheet: Bool
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [])
    private var customers2: FetchedResults<Customer2>
    
    @State var first_name: String = ""
    @State var last_name: String = ""
    @State var birthday_date = Date()
    
    @State var showAlert = false
    //@EnvironmentObject var customersListManager : CustomersListManager
    
    var customer : Customer2
    
    var body: some View {
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
                Button("Modifier patient") {
                    self.editPatient()
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
    
    func editPatient(){
        if (self.first_name != "") {
            customer.last_name = last_name
            customer.first_name = first_name
            customer.birthday_date = birthday_date
            saveContext()
            self.showEditCustomerSheet = false
        } else {
            self.showAlert = true
        }
    }
}
