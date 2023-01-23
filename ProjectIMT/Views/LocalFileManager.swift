//
//  LocalFileManager.swift
//  ProjectIMT
//
//  Created by facetoface on 22/01/2023.
//
//  Ce fichier définit les classes permettant d'enregistrer les photos dans les documents/la gallerie


import SwiftUI
import AVFoundation
import CoreData
import UIKit
import Foundation

// Sauvegarde dans les documents
class LocalFileManager {
    var customer2: Customer2
    var transformation2: Transformation2
    
    init(customer2: Customer2, transformation2: Transformation2) {
        self.customer2 = customer2
        self.transformation2 = transformation2
    }
    
    func saveimage(image: UIImage, name: String) {
        guard let data = image.jpegData(compressionQuality: 1.0),
              let path = getPathForImage(name: name) else{
            print("Error getting data.")
            return
        }
        
        do {
            try data.write(to: path)
            print("Save succeeded")
        } catch let error {
            print("Error saving. \(error)")
        }
        print(path)
    }
    
    func getImage(name: String) -> UIImage? {
        guard let path = getPathForImage(name: name)?.path,
              FileManager.default.fileExists(atPath: path) else{
            print("Error getting path")
            return nil
        }
        return UIImage(contentsOfFile: path)
    }
    
    func deleteImage(name: String) {
        guard let path = getPathForImage(name: name),
              FileManager.default.fileExists(atPath: path.path) else{
            print("Error getting path")
            return
        }
        do {
            try FileManager.default.removeItem(at: path)
        } catch let error {
            print("Error deleting image. \(error)")
        }
    }
    
    func getPathForImage(name: String) -> URL? {
        guard let path = FileManager
            .default
            // Modifier la valeur du for pour choisir où enregistrer la photo
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("\(self.customer2.id!.uuidString)_\(self.transformation2.id!.uuidString)_\(name).jpg")
        else{
            print("Error getting path")
            return nil
        }
        return path
    }
}



// Sauvegarde dans la galerie
class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save Finished!")
    }
}
