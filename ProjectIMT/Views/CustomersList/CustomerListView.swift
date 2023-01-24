//
//  HomeView.swift
//  ProjectIMT
//
//  Created by Maël Trouillet on 05/01/2022.
//

import SwiftUI
import CoreData


struct CustomersListView: View {
    //@EnvironmentObject var customerData: CustomersListManager
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Customer2.entity(), sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)])
    var customers2: FetchedResults<Customer2>
        
    //@State private var selection: Set<UUID> = [] //used to expand/collapse the customer sections
    @State var customerSelected: Int = 0 //stores the clicked customer for action buttons
    
    //delete transformation alert
    @State private var showDeleteConfirmationAlert: Bool = false
    
    //add transformation alert
    @State private var transformationNameToAdd: String? = ""
    @State private var showAddTransformationSheet: Bool = false
    
    //add and edit customer sheets
    @State private var showAddCustomerSheet: Bool = false
    @State private var showEditCustomerSheet: Bool = false
    
    //MARK: VIEW' ''

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    List{
                        ForEach(customers2, id: \.self) { customer2 in
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
                            //.swipeActions(edge: .trailing){
                            //delete Customer button + confirmation alert
                            DeleteCustomerAction(customer_2: customer2)
                            //edit Customer button + sheet
                            //EditCustomerAction(customer_2: customer2)
                            Section(content: {
                                ForEach(customer2.transformationArray, id: \.self) {transformation2 in
                                    TransformationItemRow(transformation2: .constant(transformation2), customer2: customer2)
                                    //AddTransformationButton(customer2: customer2)
                                    DeleteTransformationAction(customer2: customer2, transformation2: transformation2)
                                .frame(height: geometry.size.height/11, alignment: .center)}
                            })
                        }
                    }
                    .listStyle(SidebarListStyle())
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack() {
                                Text("Patients").font(.headline)
                                Button(action: {showAddCustomerSheet = true}) {
                                    Image(systemName: "plus.circle").foregroundColor(Color.green)
                                } .sheet(isPresented: $showAddCustomerSheet) {
                                    AddCustomerSheet(showAddCustomerSheet: $showAddCustomerSheet)
                                }
                                //Generate csv file
                                GenerateCSV()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func EditCustomerAction(customer2: Customer2) -> some View{
        return Button(action: {showEditCustomerSheet = true} ) {
            Image(systemName: "pencil").foregroundColor(Color.blue)
        }
        .sheet(isPresented: $showEditCustomerSheet) {
            EditCustomerSheet(showEditCustomerSheet: $showEditCustomerSheet, customer: customer2)
        }
    }
    
    func DeleteTransformation(indexSet: IndexSet, customer2: Customer2){
        let indice = indexSet.first!
        let transformation = customer2.transformationArray[indice]
        customer2.removeFromTransformation_list(transformation)
        saveContext()
        
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
        }
        //faire une boucle pour supprimer les transformations ici
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
    
    func addCustomer(){
        let newCustomer = Customer2(context: viewContext)
        newCustomer.birthday_date = Date()
        newCustomer.first_name = "Philibert"
        newCustomer.id = UUID()
        newCustomer.last_name = "Franck"
        newCustomer.number_of_transformations = 1
    }
    
    func saveContext(){
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
    
     #if DEBUG
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            CustomersListView()
        }
    }
     #endif
}
