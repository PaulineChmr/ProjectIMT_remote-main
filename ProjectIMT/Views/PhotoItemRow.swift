//
//  PhotoItemRow.swift
//  ProjectIMT
//
//  Created by facetoface on 26/01/2023.
//

import SwiftUI

struct PhotoItemRow: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var additionalPhoto2: AdditionalPhoto2
    @State var transformationSheetIsPresented: Bool = false
    @State var cantOpenTransformationAlertIsPresented: Bool = false
    var customer2 : Customer2
    var transformation2: Transformation2
    
    //used in the View to display different situations
    var bothImagesTaken : Bool {
        if (additionalPhoto2.before_picture != "" && additionalPhoto2.after_picture != "") {
            return true
        }
        return false
        
    }
    
    //MARK: VIEW
    var body: some View {
        
        HStack {

            MultiImagePicker(additionalPhoto2: $additionalPhoto2, transformation2: transformation2, customer2: customer2, cote: "left")
            .padding(.horizontal)
            
            VStack(spacing: 4) {
                
                //show transformation button
                Button(action: openTransformation ) { label:  do {
                    HStack {
                        
                        DateIfPicturePresent(path: additionalPhoto2.before_picture, date: additionalPhoto2.before_date)
                        
                        Image(systemName: "arrowshape.turn.up.right.fill")
                            .foregroundColor(Color.white)
                            .font(.system(size: 15.0))
                        
                        DateIfPicturePresent(path: additionalPhoto2.after_picture, date: additionalPhoto2.after_date)
                    }
                }}
                .frame(maxWidth: .infinity)
                .padding()
                .background(bothImagesTaken ? Color.red : Color.gray)
                .foregroundColor(Color.white)
                .cornerRadius(20)
                .alert("Veuillez selectionner des photos avant de voir la transformation", isPresented: $cantOpenTransformationAlertIsPresented) {
                    Button("OK", role: .cancel) { }
                }
                .sheet(isPresented: $transformationSheetIsPresented) {
                    ShowMultTransformationView(customer2: customer2, transformation2: transformation2, additionalPhoto2: additionalPhoto2)
                }
            }
            
            MultiImagePicker(additionalPhoto2: $additionalPhoto2, transformation2: transformation2, customer2: customer2, cote: "right")
            .padding(.horizontal)
            .disabled(additionalPhoto2.before_picture == "")
            
        }
    }
    
    //MARK: VIEW FUNCTIONS
    func DateIfPicturePresent(path: String?, date: Date?) -> some View {
        Group {
            if (path != "" && date != nil) {
                Text(date!.jourEtMois)
                    .foregroundColor(Color.white)
                    .font(.system(size: 15.0))
            } else {
                Image(systemName: "photo.fill")
                    .font(.system(size: 20.0))
            }
        }
    }
    
    //MARK: VIEWMODEL FUNCTIONS
    func openTransformation() {
        if bothImagesTaken {
            self.transformationSheetIsPresented = true
        } else {
            self.cantOpenTransformationAlertIsPresented = true
        }
        
    }
}
