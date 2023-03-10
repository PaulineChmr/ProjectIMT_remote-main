//
//  AddTransformationSheet.swift
//  ProjectIMT
//
//  Created by facetoface on 10/01/2023.
//
// Create and save a new transformation for a customer in CoreData.

import SwiftUI

struct AddTransformationSheet: View {
    
    @Binding var showAddTransformationSheet: Bool
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [])
    private var customers2: FetchedResults<Customer2>

    @State var after_date = Date()
    @State var after_picture: String = ""
    @State var before_date = Date()
    @State var before_picture: String = ""
    @State var id: UUID = UUID()
    @State var name: String = ""
    
    @State var showAlert = false
    
    var customer : Customer2
    
    var body: some View{
        Form{
            Section(header: Text("Nom de l'opération")){
                TextField("", text: $name) .padding()
            }
            Section{
                Button(action: addTransformation) {
                    Text("Ajouter opération")
                } .alert("Veuillez saisir le nom de l'opération...", isPresented: $showAlert) {
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
    
    func addTransformation(){
        //save the new transformation in CoreData
        if (self.name != "") {
            let newTransformation = Transformation2(context: viewContext)
            newTransformation.after_date = after_date
            newTransformation.after_picture = after_picture
            newTransformation.before_date = before_date
            newTransformation.before_picture = before_picture
            newTransformation.id = id
            newTransformation.name = name
            self.showAddTransformationSheet = false
            customer.addToTransformation_list(newTransformation)
        } else {
            self.showAlert = true
        }
        saveContext()
    }
}
