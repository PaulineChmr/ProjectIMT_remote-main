//
//  ShowTransformation.swift
//  ProjectIMT
//
//  Created by Sacha sicoli on 18/01/2022.
//

import SwiftUI

struct ShowTransformationView: View {
    var transformation2: Transformation2
    
    @State var SliderValue: Double = 0
    @State var isShowingPopover: Bool = false
    
    var body: some View {
               
        VStack{
            
            if transformation2.name != nil {
                Text(transformation2.name!)
            }
            
            let before_pic = transformation2.before_picture!.toImage()
            let after_pic = transformation2.after_picture!.toImage()
            ZStack {
                Image(uiImage: before_pic!)
                    .resizable()
                    .scaledToFit()
                    .opacity(SliderValue)
                
                Image(uiImage: after_pic!)
                    .resizable()
                    .scaledToFit()
                    .opacity(1 - SliderValue)
            }
            
                
            Slider(value: $SliderValue, in: 0...1, step: 0.01)
                .accentColor(.red)
                .padding()
            
        }
    }
}
/*
extension Transformation2 {
    static func getPreviewTransfo() -> Transformation2 {
        let transformation = Transformation2(name: "preview transfo",
                                            before_picture: UIImage(contentsOfFile: "selfie1"),
                                            after_picture: UIImage(contentsOfFile: "selfie2"),
                                            before_date: Date(),
                                            after_date: Date() )
        return transformation
    }
}

struct ShowTransformationView_Previews: PreviewProvider {
    static var previews: some View {
        ShowTransformationView(transformation: .getPreviewTransfo())
        
    }
}
*/
