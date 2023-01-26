//
//  HomeView.swift
//  ProjectIMT
//
//  Created by facetoface on 05/01/2022.
//
// Principal view of the app, shows the customers and their transformations.

import SwiftUI
import CoreData


struct CustomersListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Customer2.entity(), sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)])
    var customers2: FetchedResults<Customer2>
    
    //delete transformation alert
    @State private var showDeleteConfirmationAlert: Bool = false
    
    //add transformation alert
    @State private var showAddTransformationSheet: Bool = false
    
    //add and edit customer sheets
    @State private var showAddCustomerSheet: Bool = false
    @State private var showEditCustomerSheet: Bool = false
    
    //search customer
    @State private var searchText = ""
    
    //MARK: VIEW' ''

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    List{
                        ForEach(customers2, id: \.self) { customer2 in
                            if((customer2.fullName() ?? "").contains(searchText) || searchText == "") {
                                Text(customer2.fullName() ?? "Untitled")
                                
                                //EditCustomer
                                Button(action: {showEditCustomerSheet = true} ) {
                                    Image(systemName: "pencil").foregroundColor(Color.blue)
                                } .sheet(isPresented: $showEditCustomerSheet) {
                                    EditCustomerSheet(showEditCustomerSheet: $showEditCustomerSheet, customer: customer2)
                                }
                                
                                //AddTransformation
                                Button(action: {showAddTransformationSheet = true}){
                                    Image(systemName: "plus.circle").foregroundColor(Color.purple)
                                } .sheet(isPresented: $showAddTransformationSheet){
                                    AddTransformationSheet(showAddTransformationSheet: $showAddTransformationSheet, customer: customer2)
                                }
                                
                                //Delete Customer button + action
                                DeleteCustomerAction(customer_2: customer2)

                                //Show transformations for each Customer
                                Section(content: {
                                    ForEach(customer2.transformationArray, id: \.self) {transformation2 in
                                        TransformationItemRow(transformation2: .constant(transformation2), customer2: customer2)
                                        
                                        //Delete Transformation button + action
                                        DeleteTransformationAction(customer2: customer2, transformation2: transformation2)
                                        .frame(height: geometry.size.height/11, alignment: .center)}
                                })
                            }
                        }
                    }.searchable(text: $searchText, prompt: "Chercher un patient")
                    .listStyle(SidebarListStyle())
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack() {
                                Text("Patients").font(.headline)
                                
                                //AddCustomer
                                Button(action: {showAddCustomerSheet = true}) {
                                    Image(systemName: "plus.circle").foregroundColor(Color.green)
                                } .sheet(isPresented: $showAddCustomerSheet) {
                                    AddCustomerSheet(showAddCustomerSheet: $showAddCustomerSheet)
                                }
                                
                                //Generate CSV files
                                GenerateCSV()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func DeleteCustomerAction(customer_2: Customer2) -> some View {
        return Button(role: .destructive, action: {
             showDeleteConfirmationAlert = true})
         {
             Image(systemName: "trash")
         }
         .alert(isPresented: $showDeleteConfirmationAlert) {
             Alert(title: Text("Delete " + (customer_2.fullName() ?? "Untitled") + " ?"),
                  primaryButton: .default(Text("Cancel")),
                  secondaryButton: .destructive(Text("Delete"), action: {deleteCustomer(customer_2: customer_2)} )
            )
         }
     }

    func deleteCustomer(customer_2: Customer2){
        for transformation2 in customer_2.transformationArray{
            customer_2.removeFromTransformation_list(transformation2)
            deleteTransformation(customer2: customer_2, transformation2: transformation2)
        }
        viewContext.delete(customer_2)
        saveContext()
    }
    
    func DeleteTransformationAction(customer2: Customer2, transformation2: Transformation2) -> some View {
        return Button(role: .destructive, action: {
             showDeleteConfirmationAlert = true})
         {
             Image(systemName: "trash")
         }
         .alert(isPresented: $showDeleteConfirmationAlert) {
             Alert(title: Text("Delete " + (transformation2.name ?? "Untitled") + " ?"),
                  primaryButton: .default(Text("Cancel")),
                   secondaryButton: .destructive(Text("Delete"), action: {deleteTransformation(customer2: customer2, transformation2: transformation2)} )
            )
         }
     }
    
    func deleteTransformation(customer2: Customer2, transformation2: Transformation2){
        let manager = LocalFileManager(customer2: customer2, transformation2: transformation2)
        manager.deleteImage(name: "before")
        manager.deleteImage(name: "after")
        customer2.removeFromTransformation_list(transformation2)
        viewContext.delete(transformation2)
        saveContext()
    }
    
    func saveContext(){
        //save modifications in CoreData
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
}

/*#if DEBUG
struct HomeView_Previews: PreviewProvider {
   static var previews: some View {
       CustomersListView()
   }
}
#endif*/
