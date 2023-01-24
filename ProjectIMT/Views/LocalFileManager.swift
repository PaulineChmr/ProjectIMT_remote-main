//
//  LocalFileManager.swift
//  ProjectIMT
//
//  Created by facetoface on 22/01/2023.
//
//  Ce fichier définit les classes permettant d'enregistrer les photos dans les documents


import SwiftUI
import AVFoundation
import CoreData
import UIKit
import Foundation

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
        guard let cust_id = self.customer2.id,
              let transfo_id = self.transformation2.id,
            let path = FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("\(cust_id.uuidString)\(transfo_id.uuidString)\(name).jpg")
        else{
            print("Error getting path")
            return nil
        }
        return path
    }
}
