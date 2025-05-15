//
//  ImageManager.swift
//  WardrobeApp1
//
//  Created by Mac on 15/05/25.
//

import Foundation
import UIKit

class ImageManager {
    static let shared = ImageManager()
    
    private init() {}
    
    func saveImage(_ image: UIImage) -> String? {
        let fileName = UUID().uuidString + ".jpg"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            do {
                try imageData.write(to: fileURL)
                return fileURL.path
            } catch {
                print("Error saving image: \(error)")
                return nil
            }
        }
        return nil
    }
    
    func loadImage(from path: String) -> UIImage? {
        return UIImage(contentsOfFile: path)
    }
    
    func deleteImage(at path: String) {
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch {
            print("Error deleting image: \(error)")
        }
    }
}
