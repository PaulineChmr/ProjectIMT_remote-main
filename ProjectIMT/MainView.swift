//
//  MainView.swift
//  ProjectIMT
//
//  Created by Maël Trouillet on 05/01/2022.
//

import SwiftUI
import CoreData
/*
struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Customer2.entity(), sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]) var
        customers2: FetchedResults<Customer2>
    var body: some View{
        NavigationView{
            VStack{
                List{
                    ForEach(customers2, id: \.self){ customer2 in
                        Text(customer2.last_name ?? "Untitled")
                    }
                    .onDelete(perform: deleteCustomer)
                }
                Button(action: addCustomer){
                    Text("Ajouter un patient")
                }
            }
            .navigationBarItems(trailing: EditButton())
        }
    }
    func deleteCustomer(indexSet: IndexSet){
        let indice = indexSet.first!
        let customer2 = customers2[indice]
        viewContext.delete(customer2)
        saveContext()
    }
    func addCustomer(){
        let newCustomer = Customer2(context: viewContext)
        newCustomer.birthday_date = Date()
        newCustomer.first_name = "Philibert"
        newCustomer.id = UUID()
        newCustomer.last_name = "Franck"
        newCustomer.number_of_transformations = 1
        saveContext()
    }
    
    func saveContext(){
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
}*/
struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
        
    @FetchRequest(sortDescriptors: [])
    private var customers2: FetchedResults<Customer2>
        
    var body: some View{
        CustomersListView()
    }
}
        /*NavigationView{
            List{
                ForEach(customers2) { customer2 in
                    Text(customer2.last_name ?? "Untitled")
                }
                /*ForEach(customers2){
                 customer2 in customer2.last_name
                 }*/
                .navigationTitle("Liste des patients")
                .navigationBarItems(trailing: Button("Ajouter"){addCustomer2()})
            }
        }
    }
     
     private func saveContext(){
     do {
     try viewContext.save()
     } catch {
     let error = error as NSError
     fatalError("Unresolved Error: \(error)")
     }
     }
     
     private func addCustomer2(){
     let newCust = Customer2(context: viewContext)
     newCust.last_name = "Oui"
     newCust.id = UUID()
     newCust.first_name = "O"
     newCust.birthday_date = Date()

     saveContext()
     
     }
     
     
     struct MainView_Previews: PreviewProvider {
     static var previews: some View {
     MainView().environmentObject(CustomersListManager())
     }
     
     }

}
*/
