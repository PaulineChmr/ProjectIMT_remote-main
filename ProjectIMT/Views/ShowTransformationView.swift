//
//  ShowTransformation.swift
//  ProjectIMT
//
//  Created by facetoface on 18/01/2022.
//
// This view shows the cursor to see the differences between the before and the after pictures.

import SwiftUI

struct ShowTransformationView: View {
    var customer2: Customer2
    var transformation2: Transformation2
    
    @State var SliderValue: Double = 0
    @State var isShowingPopover: Bool = false
    
    var body: some View {
               
        VStack{
            
            if transformation2.name != nil {
                Text(transformation2.name!)
            }
            
            let manager = LocalFileManager(customer2: customer2, transformation2: transformation2)
            ZStack {
                Image(uiImage: manager.getImage(name: "before")!)
                    .resizable()
                    .scaledToFit()
                    .opacity(1 - SliderValue)
                
                Image(uiImage: manager.getImage(name: "after")!)
                    .resizable()
                    .scaledToFit()
                    .opacity(SliderValue)
            }
            
                
            Slider(value: $SliderValue, in: 0...1, step: 0.01)
                .accentColor(.red)
                .padding()
            
        }
    }
}

/*
struct ShowTransformationView_Previews: PreviewProvider {
    static var previews: some View {
        ShowTransformationView(transformation: .getPreviewTransfo())
        
    }
}
*/
