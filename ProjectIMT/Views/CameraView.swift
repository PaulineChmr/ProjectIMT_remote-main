//
//  CameraView.swift
//  ProjectIMT
//
//  Created by facetoface on 18/01/2022.
//
// This view allows to take before and after pictures.

import SwiftUI
import AVFoundation
import CoreData
import UIKit
import Foundation

struct CameraView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var captured_image: UIImage?
    //@Binding var date: Date?
    @Binding var transformation2: Transformation2
    var customer2 : Customer2
    

    var body: some View {
        CameraViewWithModel(captured_image: $captured_image, camera: CameraModel(captured_image: $captured_image, transformation2: transformation2), transformation2: transformation2, customer2: customer2)
    }
}

struct CameraViewWithModel: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var captured_image: UIImage?
    
    //@Binding var before_picture: UIImage?
    
    @StateObject var camera : CameraModel
    var transformation2 : Transformation2
    var customer2 : Customer2

    @Environment(\.presentationMode) private var presentationMode //deprecated, we could use isPresented or dissmiss instead...
    
    var body: some View {
        
        
        ZStack {
            
            // Camera preview
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            
            
            // Face positionment layer
            // Améliorer la condition du 1er if pour inclure le cas où le fichier jpeg aurait été supprimé manuellement
            let manager = LocalFileManager(customer2: customer2, transformation2: transformation2)
            if transformation2.before_picture != "" {
                if !camera.isTaken {
                    Image(uiImage: manager.getImage(name: "before")!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea(.all, edges: .all)
                        .opacity(0.5)
                }
            }
            
            else {
                Image("ProportionFaceTemplate")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 400, height: 300, alignment: .center)
                    .opacity(0.8)
            }
            
            
            VStack {
                
                if camera.isTaken {
                    
                    HStack {
                        
                        Spacer()
                        
                        Button(action: {camera.reTake()}, label: {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        })
                            .padding(.trailing, 10)
                    }
                }
                
                Spacer()
                
                HStack {
                    
                    // if taken showing save and again take button ...
                    
                    if camera.isTaken {
                        
                        Button(action: {
                            self.savePic()
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("save")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.white)
                                .clipShape(Capsule())
                        })
                            .padding(.leading)
                        
                        Spacer()
                        
                    } else {
                        
                        Button(action: camera.takePic, label: {
                            
                            ZStack {
                                
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                                
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 75, height: 75)
                            }
                        })
                    }
                }.frame(height: 75)
            }
        }
        .onAppear {
            camera.check()
        }
        
    }
    

    func savePic() {
        let manager = LocalFileManager(customer2: customer2, transformation2: transformation2)
        
        if transformation2.before_picture != "" {
            transformation2.after_date = Date()
            manager.saveimage(image: captured_image!, name: "after")
            //manager.saveimage_gallery(image: captured_image!, name: "after")
            transformation2.after_picture = manager.getPathForImage(name: "after")!.path
        }
        else {
            transformation2.before_date = Date()
            manager.saveimage(image: captured_image!, name: "before")
            //manager.saveimage_gallery(image: captured_image!, name: "before")
            transformation2.before_picture = manager.getPathForImage(name: "before")!.path
        }
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
}



// Camera Model ...

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Transformation2.entity(), sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)])
    var transformations2: FetchedResults<Transformation2>
    @Published var isTaken = false
    
    @Published var session = AVCaptureSession()
    
    @Published var alert = false
    
    @Published var output = AVCapturePhotoOutput()
    
    //preview
    @Published var preview: AVCaptureVideoPreviewLayer!
    
    //Pic data
    @Binding var captured_image: UIImage?
    var transformation2 : Transformation2
    
    
    
    init(captured_image: Binding<UIImage?>, transformation2: Transformation2) {
        self._captured_image = captured_image
        self.transformation2 = transformation2
    }
    
    func check() {
        
        // first checking camera got permission ...
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
            // Setting Up Session
        case .notDetermined:
            //retesting for permission ...
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                
                if status {
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
        default:
            return
        }
    }
    
    func setUp() {
        
        // setting up camera ...
        
        do {
            
            // setting config ...
            self.session.beginConfiguration()
            
            // change for your own
            //let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
            if let device = AVCaptureDevice.default(for: .video) {
                let input = try AVCaptureDeviceInput(device: device)
                
                //checking and adding to session ...
                if self.session.canAddInput(input) {
                    self.session.addInput(input)
                }
                
                // same for output ...
                if self.session.canAddOutput(self.output) {
                    self.session.addOutput(self.output)
                }
                
                self.session.commitConfiguration()
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //take and retake functions...
    func takePic() {
        DispatchQueue.global(qos: .background).async {
            
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            
            /*
             moved inside photoOutput to prevent a bug where the session is closed before the picture could be taken...
             */
            //self.session.stopRunning()
            
            
            DispatchQueue.main.async {
                withAnimation { self.isTaken.toggle() }
            }
        }
    }
    
    private func cropToPreviewLayer(originalImage: UIImage) -> UIImage? {
        guard let cgImage = originalImage.cgImage else { return nil }

        let outputRect = preview.metadataOutputRectConverted(fromLayerRect: preview.bounds)

        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        let cropRect = CGRect(x: outputRect.origin.x * width, y: outputRect.origin.y * height, width: outputRect.size.width * width, height: outputRect.size.height * height)

        if let croppedCGImage = cgImage.cropping(to: cropRect) {
            return UIImage(cgImage: croppedCGImage, scale: 1.0, orientation: originalImage.imageOrientation)
        }

        return nil
    }
    
    
    func reTake() {
        
        DispatchQueue.global(qos: .background).async {
            
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation { self.isTaken.toggle() }
                
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if error != nil {
            return
        }
        print("pic taken...")
        
        if let data = photo.fileDataRepresentation() {
            let uncroppedImage = UIImage(data: data)
            self.captured_image = cropToPreviewLayer(originalImage: uncroppedImage!)
        } else {
            print("Error: no image data found")
        }
        
        self.session.stopRunning()
    }
    
    
    func saveContext(){
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
}


// setting view preview ...
struct CameraPreview: UIViewRepresentable {

    @ObservedObject var camera: CameraModel

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)

        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)

        // starting session
        camera.session.startRunning()

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {

    }

}

