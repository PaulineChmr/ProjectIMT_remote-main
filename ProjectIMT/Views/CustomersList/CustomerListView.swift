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
    
    //add photo in transformation row
    @State private var addPhoto: Bool = false
    
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
                                DeleteCustomerAction(customer2: customer2)

                                //Show transformations for each Customer
                                Section(content: {
                                    ForEach(customer2.transformationArray, id: \.self) {transformation2 in
                                        TransformationItemRow(transformation2: .constant(transformation2), customer2: customer2)
                                            .frame(height: geometry.size.height/13, alignment: .center)
                                        Button(action: {addPhoto(customer2: customer2, transformation2: transformation2)})
                                         {
                                             Image(systemName: "plus.circle").foregroundColor(Color.pink)
                                         }
                                        
                                        //Delete Transformation button + action
                                        DeleteTransformationAction(customer2: customer2, transformation2: transformation2)
                                        
                                        //Show additional Photos
                                        Section(header: Text("More pictures").font(.subheadline), content: {
                                            ForEach(transformation2.photoArray, id: \.self) {additionalPhoto2 in
                                                PhotoItemRow(additionalPhoto2: .constant(additionalPhoto2), customer2: customer2, transformation2: transformation2)
                                                DeletePhotoAction(customer2: customer2, transformation2: transformation2, additionalPhoto2: additionalPhoto2)
                                            }
                                        })
                                        .accentColor(.orange)
                                        .frame(height: geometry.size.height/20, alignment: .center)}
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
    
    func DeleteCustomerAction(customer2: Customer2) -> some View {
        return Button(role: .destructive, action: {
             showDeleteConfirmationAlert = true})
         {
             Image(systemName: "trash")
         }
         .alert(isPresented: $showDeleteConfirmationAlert) {
             Alert(title: Text("Delete " + (customer2.fullName() ?? "Untitled") + " ?"),
                  primaryButton: .default(Text("Cancel")),
                  secondaryButton: .destructive(Text("Delete"), action: {deleteCustomer(customer2: customer2)} )
            )
         }
     }

    func deleteCustomer(customer2: Customer2){
        for transformation2 in customer2.transformationArray{
            customer2.removeFromTransformation_list(transformation2)
            deleteTransformation(customer2: customer2, transformation2: transformation2)
        }
        viewContext.delete(customer2)
        saveContext()
    }
    
    /*func AddPhotoAction(customer2: Customer2, transformation2: Transformation2) -> some View{
        return Button(action: {addPhoto(transformation2: transformation2)})
         {
             Image(systemName: "plus.circle").foregroundColor(Color.pink)
         }
    }*/
    
    func addPhoto(customer2: Customer2, transformation2: Transformation2){
        let newPhoto = AdditionalPhoto2(context: viewContext)
        newPhoto.after_date = Date()
        newPhoto.after_picture = ""
        newPhoto.before_date = Date()
        newPhoto.before_picture = ""
        newPhoto.transformation_id = transformation2.id
        newPhoto.number = Int32((transformation2.photo_list ?? []).count + 1)
        transformation2.addToPhoto_list(newPhoto)
        customer2.addToTransformation_list(transformation2)
        saveContext()
    }
    
    func DeletePhotoAction(customer2: Customer2, transformation2: Transformation2, additionalPhoto2: AdditionalPhoto2) -> some View{
        return Button(role: .destructive, action: {
             showDeleteConfirmationAlert = true})
         {
             Image(systemName: "trash")
         }
         .alert(isPresented: $showDeleteConfirmationAlert) {
             Alert(title: Text("Delete pictures ?"),
                  primaryButton: .default(Text("Cancel")),
                   secondaryButton: .destructive(Text("Delete"), action: {deletePhoto(customer2: customer2, transformation2: transformation2, additionalPhoto2: additionalPhoto2)} )
            )
         }
    }
    
    func deletePhoto(customer2: Customer2, transformation2: Transformation2, additionalPhoto2: AdditionalPhoto2){
        let manager = MultLocalFileManager(customer2: customer2, transformation2: transformation2, additionalPhoto2: additionalPhoto2)
        manager.deleteImage(name: "before")
        manager.deleteImage(name: "after")
        transformation2.removeFromPhoto_list(additionalPhoto2)
        viewContext.delete(additionalPhoto2)
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
        for photo in transformation2.photoArray{
            transformation2.removeFromPhoto_list(photo)
            deletePhoto(customer2: customer2, transformation2: transformation2, additionalPhoto2: photo)
        }
        
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
