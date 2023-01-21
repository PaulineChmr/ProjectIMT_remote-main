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
    
    //MARK: VIEW

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    List{
                        ForEach(customers2, id: \.self) { customer2 in
                            //Text(customer2.first_name ?? "Untitled")
                            //Text(customer2.last_name ?? "Untitled")
                            
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
                                    .frame(height: geometry.size.height/11, alignment: .center)}
                                .onDelete{ indexSet in
                                    DeleteTransformation(indexSet: indexSet, customer2: customer2)
                                }
                            })
                          /*      //Enlever le ) avant
                                //Pb : toutes les modifications apportées sur un des clients sont uniquement appliquées sur le premier client de la liste (le moins récent) => travailler sur les indices des clients ?
                                , header: {
                                HStack {
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
                                }
                            })  */
                        }
                    }
                    /*.toolbar{
                     EditButton()
                     }*/
                    .listStyle(SidebarListStyle())
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
                                Text("Patients").font(.headline)
                                Button(action: {showAddCustomerSheet = true} ) {
                                    Image(systemName: "plus.circle").foregroundColor(Color.green)
                                } .sheet(isPresented: $showAddCustomerSheet) {
                                    AddCustomerSheet(showAddCustomerSheet: $showAddCustomerSheet)
                                }
                            }
                        }
                    }
                }//.textFieldAlert(isPresented: $showAddTransformationAlert) { () -> TextFieldAlert in
                   // TextFieldAlert(title: "Ajouter une transformation", message: "", text: $transformationNameToAdd, doneAction: addTransformation)
                //}
            }
        }
    }
    func DeleteTransformation(indexSet: IndexSet, customer2: Customer2){
        let indice = indexSet.first!
        let transformation = customer2.transformationArray[indice]
        customer2.removeFromTransformation_list(transformation)
        saveContext()
        
    }
    
    /*func addTransformation(customer2: Customer2) {
        customer2.addToTransformation_list()
    }
    */
    //MARK: VIEW FUNCTIONS
    /*func EditCustomerAction(customer_2: Customer2?) -> some View {
        var customer_index = customers2.startIndex
        for indice in customers2.indices{
            if(customers2[indice] == customer_2){
                customer_index = indice
            }
        }
        return Button(action: {customerSelected = customer_index; showEditCustomerSheet = true }) {
             Image(systemName: "pencil")
                 .foregroundColor(Color.blue)
         } .sheet(isPresented: $showEditCustomerSheet) {
             EditCustomerSheet(showEditCustomerSheet: $showEditCustomerSheet,
                               customerSelected: customerSelected)
         }
     }*/
    
    func DeleteCustomerAction(customer_2: Customer2) -> some View {
        /*var customer_index = customers2.endIndex
        for indice in customers2.indices{
            if(customers2[indice] == customer_2){
                customer_index = indice
            }
        }*/
        return Button(role: .destructive, action: {
             showDeleteConfirmationAlert = true})
         {
             Image(systemName: "trash")
         }
         .alert(isPresented: $showDeleteConfirmationAlert) {
            //Alert(title: Text("Delete " + (customer_2.first_name ?? "Untitled") + " ?"),
             Alert(title: Text("Delete " + (customer_2.fullName() ?? "Untitled") + " ?"),
                  primaryButton: .default(Text("Cancel")),
                  secondaryButton: .destructive(Text("Delete"), action: {deleteCustomer(customer_2: customer_2)} )
            )
         }
     }
    
    func deleteCustomer(customer_2: Customer2){
        viewContext.delete(customer_2)
        saveContext()
    }
/*
    func AddTransformationButton(customer2: Customer2) -> some View {
        var customer_index = customers2.endIndex
        for indice in customers2.indices{
            if(customers2[indice] == customer2){
                customer_index = indice
            }
        }
     return Button(action: {
     customerSelected = customer_index
     showAddTransformationAlert = true}) {
     Image(systemName: "plus.circle").foregroundColor(Color.green)
     }
     //we can not add the .TextFieldAlert() here because as we did it, it is not appliable on a Button()
     }
    
    */
/*
     func NumberOfTransformation(customer_index: Int) -> some View {
     Text(String(customers2[customer_index].number_of_transformations))
     .foregroundColor(.blue)
     .font(.system(size: 15.0))
     .fontWeight(.light)
     }
*/
     //MARK: VIEWMODEL FUNCTIONS
    /*
    func deleteRow(customer_2: Customer2, indexes: IndexSet?) {
    //as we do not use the multi-delete property of the list, we just want one index
    let transformation_index = indexes!.first!
    customer_2.removeFromTransformation_list(transf)
    customers2.deleteTransformation(customer_id: customer_id, transformation_id: transformation_id)
    }
    
    func deleteTransformation(transfoArray : Array<Transformation2>, indexSet: IndexSet){
        let source = indexSet.first!
        let listItem = transfoArray[source]
        viewContext.delete(listItem)
        saveContext()
    }
*/
    /*
    func deleteCustomer(chosenCustomer2: Customer2) {
        for(index, customer) in customers2.enumerated(){
            if (customer == chosenCustomer2){
                viewContext.delete(customers2[index])
            }
        }
        saveContext()
    }*/
    
    //MARK: Customer2 FUNCTIONS
    
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
    /*
    func deleteCustomer(indexSet: IndexSet){
        let source = indexSet.first!
        let listItem = customers2[source]
        viewContext.delete(listItem)
        saveContext()
    }
    */

    
     #if DEBUG
     struct HomeView_Previews: PreviewProvider {
     static var previews: some View {
     CustomersListView()
     }
     }
     #endif
}
