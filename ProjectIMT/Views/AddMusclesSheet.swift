//
//  AddMusclesSheet.swift
//  ProjectIMT
//
//  Created by facetoface on 10/01/2023.
//

import SwiftUI

struct AddMusclesSheet: View {
    
    @Binding var showMusclesSheet: Bool
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [])
    private var customers2: FetchedResults<Customer2>

    @State var buccinateur_sain: String = ""
    @State var buccinateur_paralyse: String = ""
    @State var corrugator_sain: String = ""
    @State var corrugator_paralyse: String = ""
    @State var dao_sain: String = ""
    @State var dao_paralyse: String = ""
    @State var dli_sain: String = ""
    @State var dli_paralyse: String = ""
    @State var elevator_sain: String = ""
    @State var elevator_paralyse: String = ""
    @State var frontalis_sain: String = ""
    @State var frontalis_paralyse: String = ""
    @State var grandzygo_sain: String = ""
    @State var grandzygo_paralyse: String = ""
    @State var mentalis_sain: String = ""
    @State var mentalis_paralyse: String = ""
    @State var orbicularis_sain: String = ""
    @State var orbicularis_paralyse: String = ""
    @State var petitzygo_sain: String = ""
    @State var petitzygo_paralyse: String = ""
    @State var platysma_sain: String = ""
    @State var platysma_paralyse: String = ""
    @State var rlsan_sain: String = ""
    @State var rlsan_paralyse: String = ""
    
    @State var showAlert = false
    var transformation2: Transformation2
    var body: some View{
        Form{
            Section{
                Text("Frontalis côté sain")
                TextField(String(transformation2.frontalis_sain), text: $frontalis_sain) .padding()
                Text("Frontalis côté paralysé")
                TextField(String(transformation2.frontalis_paralyse), text: $frontalis_paralyse) .padding()
                Text("Orbicularis Oculi côté sain")
                TextField(String(transformation2.orbicularis_sain), text: $orbicularis_sain) .padding()
                Text("Orbicularis Oculi côté paralysé")
                TextField(String(transformation2.orbicularis_paralyse), text: $orbicularis_paralyse) .padding()
            }
            Section{
                    Text("Corrugator côté sain")
                    TextField(String(transformation2.corrugator_sain), text: $corrugator_sain) .padding()
                    Text("Corrugator côté paralysé")
                    TextField(String(transformation2.corrugator_paralyse), text: $corrugator_paralyse) .padding()
                    Text("Elevator Lèvre Supérieure côté sain")
                    TextField(String(transformation2.elevator_sain), text: $elevator_sain) .padding()
                    Text("Elevator Lèvre Supérieure côté paralysé")
                    TextField(String(transformation2.elevator_paralyse), text: $elevator_paralyse) .padding()
            }
            Section{
                Text("RLSAN côté sain")
                TextField(String(transformation2.rlsan_sain), text: $rlsan_sain) .padding()
                Text("RLSAN côté paralysé")
                TextField(String(transformation2.rlsan_paralyse), text: $rlsan_paralyse) .padding()
                Text("Petit Zygomatique côté sain")
                TextField(String(transformation2.petitzygo_sain), text: $petitzygo_sain) .padding()
                Text("Petit Zygomatique côté paralysé")
                TextField(String(transformation2.petitzygo_paralyse), text: $petitzygo_paralyse) .padding()
            }
            Section{
                Text("Grand Zygomatique côté sain")
                TextField(String(transformation2.grandzygo_sain), text: $grandzygo_sain) .padding()
                Text("Grand Zygomatique côté paralysé")
                TextField(String(transformation2.grandzygo_paralyse), text: $grandzygo_paralyse) .padding()
                Text("DAO côté sain")
                TextField(String(transformation2.dao_sain), text: $dao_sain) .padding()
                Text("DAO côté paralysé")
                TextField(String(transformation2.dao_paralyse), text: $dao_paralyse) .padding()
            }
            Section{
                Text("DLI côté sain")
                TextField(String(transformation2.dli_sain), text: $dli_sain) .padding()
                Text("DLI côté paralysé")
                TextField(String(transformation2.dli_paralyse), text: $dli_paralyse) .padding()
                Text("Mentalis côté sain")
                TextField(String(transformation2.mentalis_sain), text: $mentalis_sain) .padding()
                Text("Mentalis côté paralysé")
                TextField(String(transformation2.mentalis_paralyse), text: $mentalis_paralyse) .padding()
            }
            Section{
                Text("Platysma côté sain")
                TextField(String(transformation2.platysma_sain), text: $platysma_sain) .padding()
                Text("Platysma côté paralysé")
                TextField(String(transformation2.platysma_paralyse), text: $platysma_paralyse) .padding()
                Text("Buccinateur côté sain")
                TextField(String(transformation2.buccinateur_sain), text: $buccinateur_sain) .padding()
                Text("Buccinateur côté paralysé")
                TextField(String(transformation2.buccinateur_paralyse), text: $buccinateur_paralyse) .padding()
            }
            Section{
                Button("Ajouter injections") {
                    self.editMuscles()
                } .alert("Veuillez saisir les quantités...", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                }
            }
        }.navigationTitle(Text("Quantités injectées"))
    }
    
    func saveContext(){
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
    
    func editMuscles(){
            transformation2.frontalis_sain = Double(frontalis_sain) ?? 0
            transformation2.frontalis_paralyse = Double(frontalis_paralyse) ?? 0
            transformation2.orbicularis_sain = Double(orbicularis_sain) ?? 0
            transformation2.orbicularis_paralyse = Double(orbicularis_paralyse) ?? 0
            transformation2.corrugator_sain = Double(corrugator_sain) ?? 0
            transformation2.corrugator_paralyse = Double(corrugator_paralyse) ?? 0
            transformation2.elevator_sain = Double(elevator_sain) ?? 0
            transformation2.elevator_paralyse = Double(elevator_paralyse) ?? 0
            transformation2.rlsan_sain = Double(rlsan_sain) ?? 0
            transformation2.rlsan_paralyse = Double(rlsan_paralyse) ?? 0
            transformation2.petitzygo_sain = Double(petitzygo_sain) ?? 0
            transformation2.petitzygo_paralyse = Double(petitzygo_paralyse) ?? 0
            transformation2.grandzygo_sain = Double(grandzygo_sain) ?? 0
            transformation2.grandzygo_paralyse = Double(grandzygo_paralyse) ?? 0
            transformation2.dao_sain = Double(dao_sain) ?? 0
            transformation2.dao_paralyse = Double(dao_paralyse) ?? 0
            transformation2.dli_sain = Double(dli_sain) ?? 0
            transformation2.dli_paralyse = Double(dli_paralyse) ?? 0
            transformation2.mentalis_sain = Double(mentalis_sain) ?? 0
            transformation2.mentalis_paralyse = Double(mentalis_paralyse) ?? 0
            transformation2.platysma_sain = Double(platysma_sain) ?? 0
            transformation2.platysma_paralyse = Double(platysma_paralyse) ?? 0
            transformation2.buccinateur_sain = Double(buccinateur_sain) ?? 0
            transformation2.buccinateur_paralyse = Double(buccinateur_paralyse) ?? 0
            saveContext()
            self.showMusclesSheet = false
    }

}
