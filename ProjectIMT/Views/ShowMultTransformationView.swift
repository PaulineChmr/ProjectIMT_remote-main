//
//  ShowMultTransformationView.swift
//  ProjectIMT
//
//  Created by facetoface on 26/01/2023.
//

import SwiftUI

struct ShowMultTransformationView: View {
    var customer2: Customer2
    var transformation2: Transformation2
    var additionalPhoto2: AdditionalPhoto2
    
    @State var SliderValue: Double = 0
    @State var isShowingPopover: Bool = false
    
    var body: some View {
               
        VStack{
            
            let manager = MultLocalFileManager(customer2: customer2, transformation2: transformation2, additionalPhoto2: additionalPhoto2)
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
