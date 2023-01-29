//
//  PhotoSelector.swift
//  ProjectIMT
//
//  Created by facetoface on 06/01/2022.
//
// This view shows the picture on the transformation lines and allows to take after and before picture.

import SwiftUI
import UIKit



struct ImagePicker: View {
    @Environment(\.managedObjectContext) private var viewContext
        
    @Binding var transformation2: Transformation2
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    var customer2 : Customer2
    var cote: String
    
    var body: some View {
        
        let imageaafficher = find(cote: cote)
        imageaafficher
               
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .overlay(Circle().stroke(self.cote == "left" && self.transformation2.before_picture != "" || self.cote == "right" && self.transformation2.after_picture != "" ? Color.orange : Color.gray, lineWidth: 2))
                .shadow(radius: 10)
                .onTapGesture { self.shouldPresentImagePicker = true }
                .sheet(isPresented: $shouldPresentImagePicker) {
                    CameraView(transformation2: $transformation2, customer2: customer2)
            }.actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
                ActionSheet(title: Text("Selection Image"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                    self.shouldPresentImagePicker = true
                }), ActionSheet.Button.cancel()])
        }
    }
    

    func find(cote: String) -> Image {
        let manager = LocalFileManager(customer2: customer2, transformation2: transformation2)
        var name : String
        if (cote == "right") {
            name = "after"
        }
        else {
            name = "before"
        }
            
        guard let path = manager.getPathForImage(name: name),
              FileManager.default.fileExists(atPath: path.path)
        else{
            return Image(systemName: "photo.fill")
        }
        return Image(uiImage: manager.getImage(name: name)!)
    }
}





struct SUImagePickerView: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var image: UIImage?
    @Binding var date: Date?
    @Binding var isPresented: Bool
    var customer2: Customer2
    var transformation2: Transformation2
    
    func makeCoordinator() -> ImagePickerViewCoordinator {
        return ImagePickerViewCoordinator(image: $image, date: $date, isPresented: $isPresented, customer2: customer2, transformation2: transformation2)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = sourceType
        pickerController.delegate = context.coordinator
        return pickerController
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Nothing to update here
    }

}

class ImagePickerViewCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var image: UIImage?
    @Binding var date: Date?
    @Binding var isPresented: Bool
    var customer2: Customer2
    var transformation2: Transformation2
    
    init(image: Binding<UIImage?>, date: Binding<Date?>, isPresented: Binding<Bool>, customer2: Customer2, transformation2: Transformation2) {
        self._image = image
        self._date = date
        self._isPresented = isPresented
        self.customer2 = customer2
        self.transformation2 = transformation2
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.image = image
            self.date = Date()
        }
        self.isPresented = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.isPresented = false
    }
}



extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)?.rotate(radians: .pi/2)
        }
        return nil
    }
}

extension UIImage {
    func toPngString() -> String? {
        let data = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
  
    func toJpegString(compressionQuality cq: CGFloat) -> String? {
        let data = self.jpegData(compressionQuality: cq)
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
    
    func rotate(radians: CGFloat) -> UIImage {
            let rotatedSize = CGRect(origin: .zero, size: size)
                .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
                .integral.size
            UIGraphicsBeginImageContext(rotatedSize)
            if let context = UIGraphicsGetCurrentContext() {
                let origin = CGPoint(x: rotatedSize.width / 2.0,
                                     y: rotatedSize.height / 2.0)
                context.translateBy(x: origin.x, y: origin.y)
                context.rotate(by: radians)
                draw(in: CGRect(x: -origin.y, y: -origin.x,
                                width: size.width, height: size.height))
                let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                return rotatedImage ?? self
            }

            return self
        }
}
/*
#if DEBUG
struct ImagePickerPreview_Container: View {
    @State var image: UIImage? = nil
    @State var date: Date? = Date()
    var body: some View {
        ImagePicker(image: $image, date: $date)
    }
}

struct ImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerPreview_Container()
    }
}
#endif
*/
