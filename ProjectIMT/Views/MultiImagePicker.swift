//
//  MultiImagePicker.swift
//  ProjectIMT
//
//  Created by facetoface on 26/01/2023.
//

import SwiftUI
import UIKit

/*
 We use :
    - UIImagePickerView() to select photos from the galery, because it is convenient and pre-build
    - we could have used UIImagePickerView() to take photos with the camera too, but since we need more customization, we will use AVFoundation instead.
 
Both these solutions are UIKit View, hence the use of a ControllerRepresentable and a ViewCoordinator to implement them inside a SwiftUI view.
*/

struct MultiImagePicker: View {
    @Environment(\.managedObjectContext) private var viewContext
        
    @Binding var additionalPhoto2: AdditionalPhoto2
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    var transformation2: Transformation2
    var customer2 : Customer2
    var cote: String
    
    var body: some View {
        
        let imageaafficher = find(cote: cote)
        imageaafficher
               
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .overlay(Circle().stroke(self.cote == "left" && self.additionalPhoto2.before_picture != "" || self.cote == "right" && self.additionalPhoto2.after_picture != "" ? Color.orange : Color.gray, lineWidth: 2))
                .shadow(radius: 10)
                .onTapGesture { self.shouldPresentImagePicker = true }
                .sheet(isPresented: $shouldPresentImagePicker) {
                    MultCameraView(additionalPhoto2: $additionalPhoto2, transformation2: transformation2, customer2: customer2)
            }.actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
                ActionSheet(title: Text("Selection Image"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                    self.shouldPresentImagePicker = true
                }), ActionSheet.Button.cancel()])
        }
    }
    

    func find(cote: String) -> Image {
        let manager = MultLocalFileManager(customer2: customer2, transformation2: transformation2, additionalPhoto2: additionalPhoto2)
        
        if(cote == "right") {
            guard let path_after = manager.getPathForImage(name: "after"),
                  FileManager.default.fileExists(atPath: path_after.path)
            else{
                return Image(systemName: "photo.fill")
            }
            return Image(uiImage: manager.getImage(name: "after")!)
        }
        
        else{
            guard let path_before = manager.getPathForImage(name: "before"),
                  FileManager.default.fileExists(atPath: path_before.path)
            else{
                return Image(systemName: "photo.fill")
            }
            return Image(uiImage: manager.getImage(name: "before")!)
        }
    }
}





struct MultSUImagePickerView: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var image: UIImage?
    @Binding var date: Date?
    @Binding var isPresented: Bool
    var customer2: Customer2
    var additionalPhoto2: AdditionalPhoto2
    var transformation2: Transformation2
    
    func makeCoordinator() -> MultImagePickerViewCoordinator {
        return MultImagePickerViewCoordinator(image: $image, date: $date, isPresented: $isPresented, customer2: customer2, additionalPhoto2: additionalPhoto2, transformation2: transformation2)
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

class MultImagePickerViewCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var image: UIImage?
    @Binding var date: Date?
    @Binding var isPresented: Bool
    var customer2: Customer2
    var additionalPhoto2: AdditionalPhoto2
    var transformation2: Transformation2
    
    init(image: Binding<UIImage?>, date: Binding<Date?>, isPresented: Binding<Bool>, customer2: Customer2, additionalPhoto2: AdditionalPhoto2, transformation2: Transformation2) {
        self._image = image
        self._date = date
        self._isPresented = isPresented
        self.customer2 = customer2
        self.additionalPhoto2 = additionalPhoto2
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
