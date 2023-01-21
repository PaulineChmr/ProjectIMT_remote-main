//
//  TransformationItem.swift
//  ProjectIMT
//
//  Created by Maël Trouillet on 05/01/2022.
//

import SwiftUI

struct TransformationItemRow: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var transformation2: Transformation2
    @State var transformationSheetIsPresented: Bool = false
    @State var cantOpenTransformationAlertIsPresented: Bool = false
    var customer2 : Customer2
    
    //Rajouté jeudi, faudra ptet l'enlever
    @State var image: UIImage?
    @State var image2: UIImage?
    
    //used in the View to display different situations
    var bothImagesTaken : Bool {
        if (transformation2.before_picture != "" && transformation2.after_picture != "") {
            return true
        }
        return false
        
    }
    
    //MARK: VIEW
    var body: some View {
        
        HStack {
            //ImagePicker before
            let before_pic = transformation2.before_picture
            let image = before_pic!.toImage()
            ImagePicker(image: $image,
                        date: $transformation2.before_date, transformation2: $transformation2, customer2: customer2,cote: "left")
                            .padding(.horizontal)
            VStack(spacing: 4) {
                //transformation name
                if let name = transformation2.name {
                    Text(name)
                        .font(.subheadline)
                        .lineLimit(1)
                }
                
                //show transformation button
                Button(action: openTransformation ) { label:  do {
                    HStack {
                        
                        DateIfPicturePresent(picture: transformation2.before_picture?.toImage(),
                                             date: transformation2.before_date)

                        Image(systemName: "arrowshape.turn.up.right.fill")
                            .foregroundColor(Color.white)
                            .font(.system(size: 15.0))
                        
                        DateIfPicturePresent(picture: transformation2.after_picture?.toImage(),
                                             date: transformation2.after_date)
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
                    ShowTransformationView(transformation2: transformation2)
                }
                
            }
            
            //ImagePicker after
            
            let after_pic = transformation2.after_picture
            let image2 = after_pic!.toImage()
            ImagePicker(image: $image2,
                                date: $transformation2.after_date,
                        before_picture: transformation2.before_picture?.toImage(), transformation2: $transformation2, customer2: customer2, cote: "right")
                        .padding(.horizontal)
                        .disabled(transformation2.before_picture == "")
            /*let after_pic = transformation2.after_picture!.toImage()
                        ImagePicker(image: .constant(after_pic),
                                date: $transformation2.after_date,
                                    before_picture: transformation2.before_picture?.toImage(), transformation2: $transformation2)
                        .padding(.horizontal)
                        .disabled(transformation2.before_picture == "")*/

        }
    }
    
    //MARK: VIEW FUNCTIONS
    func DateIfPicturePresent(picture: UIImage?, date: Date?) -> some View {
        Group {
            if (picture != nil && date != nil) {
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

//MARK: UTILITARIES
extension Formatter {
    static let jourEtMois: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MM/dd")
        return dateFormatter
    }()
}

extension Date {
    var jourEtMois: String { Formatter.jourEtMois.string(from: self) }
}

//not working
/*
#if DEBUG
struct TransformationItemRow_Previews: PreviewProvider {
  static var previews: some View {
    PreviewWrapper()
  }

  struct PreviewWrapper: View {
      @State var transformation = Transformation(name: "lifting")

    var body: some View {
      TransformationItemRow(transformation: $transformation)
    }
  }
}
#endif
 */