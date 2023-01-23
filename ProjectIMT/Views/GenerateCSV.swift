//
//  GenerateCSV.swift
//  ProjectIMT
//
//  Created by Maël Trouillet on 05/01/2022.
//

import SwiftUI

struct GenerateCSV: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Customer2.entity(), sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)])
    var customers2: FetchedResults<Customer2>
    @State private var showGenerateCSVAlert: Bool = false
    
    //MARK: VIEW
    var body: some View {
        HStack {
            //createcsv button + action
            CreateCSV()
        }
    }
    
    func CreateCSV() -> some View{
        return Button(role: .destructive, action: {
             showGenerateCSVAlert = true})
         {
             Image(systemName: "arrow.down.doc")
         }
         .alert(isPresented: $showGenerateCSVAlert) {
             Alert(title: Text("Generate CSV file ?"),
                  primaryButton: .destructive(Text("Cancel")),
                  secondaryButton: .default(Text("Generate CSV"), action: {generateCSV()})
            )
         }
    }
    
    func generateCSV(){
        let fileName = "test.csv"
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let documentURL = URL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(fileName)
        let output = OutputStream.toMemory()
        let csvWriter = CHCSVWriter(outputStream: output, encoding: String.Encoding.utf8.rawValue, delimiter: ",".utf16.first!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        //Header for the csv file
        csvWriter?.writeField("PRENOM")
        csvWriter?.writeField("NOM")
        csvWriter?.writeField("DATE DE NAISSANCE")
        csvWriter?.writeField("NOM DE LA TRANSFORMATION")
        csvWriter?.writeField("DATE AVANT")
        csvWriter?.writeField("DATE APRES")
        csvWriter?.writeField("FRONTALIS CÔTÉ SAIN")
        csvWriter?.writeField("FRONTALIS CÔTÉ PARALYSÉ")
        csvWriter?.writeField("ORBICULARIS OCULI CÔTÉ SAIN")
        csvWriter?.writeField("ORBICULARIS OCULI CÔTÉ PARALYSÉ")
        csvWriter?.writeField("CORRUGATOR CÔTÉ SAIN")
        csvWriter?.writeField("CORRUGATOR CÔTÉ PARALYSÉ")
        csvWriter?.writeField("ELEVATOR LÈVRE SUPÉRIEURE CÔTÉ SAIN")
        csvWriter?.writeField("ELEVATOR LÈVRE SUPÉRIEURE CÔTÉ PARALYSÉ")
        csvWriter?.writeField("RLSAN CÔTÉ SAIN")
        csvWriter?.writeField("RLSAN CÔTÉ PARALYSÉ")
        csvWriter?.writeField("PETIT ZYGOMATIQUE CÔTÉ SAIN")
        csvWriter?.writeField("PETIT ZYGOMATIQUE CÔTÉ PRALYSÉ")
        csvWriter?.writeField("GRAND ZYGOMATIQUE CÔTÉ SAIN")
        csvWriter?.writeField("GRAND ZYGOMATIQUE CÔTÉ PARALYSÉ")
        csvWriter?.writeField("DAO CÔTÉ SAIN")
        csvWriter?.writeField("DAO CÔTÉ PARALYSÉ")
        csvWriter?.writeField("DLI CÔTÉ SAIN")
        csvWriter?.writeField("DLI CÔTÉ PARALYSÉ")
        csvWriter?.writeField("MENTALIS CÔTÉ SAIN")
        csvWriter?.writeField("MENTALIS CÔTÉ PARALYSÉ")
        csvWriter?.writeField("PLASTYMA CÔTÉ SAIN")
        csvWriter?.writeField("PLASTYMA CÔTÉ PARALYSÉ")
        csvWriter?.writeField("BUCCINATEUR CÔTÉ SAIN")
        csvWriter?.writeField("BUCCINATEUR CÔTÉ PARALYSÉ")
        csvWriter?.finishLine()
    
        //Array to add data for the customer
        
        var arrOfCustomerData = [[String]]()
        
        for customer2 in customers2 {
            for transformation2 in customer2.transformationArray{
                arrOfCustomerData.append([customer2.first_name ?? "", customer2.last_name ?? "", dateFormatter.string(from: customer2.birthday_date ?? Date()), transformation2.name ?? "", dateFormatter.string(from: transformation2.before_date ?? Date()), dateFormatter.string(from: transformation2.after_date ?? Date()), String(transformation2.frontalis_sain), String(transformation2.frontalis_paralyse), String(transformation2.orbicularis_sain), String(transformation2.orbicularis_paralyse), String(transformation2.corrugator_sain), String(transformation2.corrugator_paralyse), String(transformation2.elevator_sain), String(transformation2.elevator_paralyse), String(transformation2.rlsan_sain), String(transformation2.rlsan_paralyse), String(transformation2.petitzygo_sain), String(transformation2.petitzygo_paralyse), String(transformation2.grandzygo_sain), String(transformation2.grandzygo_paralyse), String(transformation2.dao_sain), String(transformation2.dao_paralyse), String(transformation2.dli_sain), String(transformation2.dli_paralyse), String(transformation2.mentalis_sain), String(transformation2.mentalis_paralyse), String(transformation2.platysma_sain), String(transformation2.platysma_paralyse), String(transformation2.buccinateur_sain), String(transformation2.buccinateur_paralyse)])
            }
        }
        
        for elements in arrOfCustomerData.enumerated(){
            csvWriter?.writeField(elements.element[0])
            csvWriter?.writeField(elements.element[1])
            csvWriter?.writeField(elements.element[2])
            csvWriter?.writeField(elements.element[3])
            csvWriter?.writeField(elements.element[4])
            csvWriter?.writeField(elements.element[5])
            csvWriter?.writeField(elements.element[6])
            csvWriter?.writeField(elements.element[7])
            csvWriter?.writeField(elements.element[8])
            csvWriter?.writeField(elements.element[9])
            csvWriter?.writeField(elements.element[10])
            csvWriter?.writeField(elements.element[11])
            csvWriter?.writeField(elements.element[12])
            csvWriter?.writeField(elements.element[13])
            csvWriter?.writeField(elements.element[14])
            csvWriter?.writeField(elements.element[15])
            csvWriter?.writeField(elements.element[16])
            csvWriter?.writeField(elements.element[17])
            csvWriter?.writeField(elements.element[18])
            csvWriter?.writeField(elements.element[19])
            csvWriter?.writeField(elements.element[20])
            csvWriter?.writeField(elements.element[21])
            csvWriter?.writeField(elements.element[22])
            csvWriter?.writeField(elements.element[23])
            csvWriter?.writeField(elements.element[24])
            csvWriter?.writeField(elements.element[25])
            csvWriter?.writeField(elements.element[26])
            csvWriter?.writeField(elements.element[27])
            csvWriter?.writeField(elements.element[28])
            csvWriter?.writeField(elements.element[29])
            
            
            csvWriter?.finishLine()
        }
        csvWriter?.closeStream()
        let buffer = (output.property(forKey: .dataWrittenToMemoryStreamKey) as? Data)!
        do{
            try buffer.write(to: documentURL)
        }
        catch{
            
        }
    }
}
