//
//  FileDirectoryHelper.swift
//  MarvelRefactor
//
//  Created by Jaz King on 06/02/2019.
//

import Foundation
import RealmSwift

extension DatabaseManager {
    // Image Methods
    // Write image to directory
    func writeImageToPath(_ path: String, extention: String, image: UIImage) {
        print("Write image to directory")
    
        let uploadURL = URL.createFolder(folderName: "upload")!.appendingPathComponent(path)

        if !FileManager.default.fileExists(atPath: uploadURL.path) {
            print("File does NOT exist -- \(uploadURL) -- is available for use")

            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let imageName = "\(path).png"
            let imageUrl = documentDirectory.appendingPathComponent("upload/\(imageName)")

            if let data = image.jpegData(compressionQuality:0.9) {
                do {
                    print("Write image")
                    try data.write(to: imageUrl)
                }
                catch {
                    print("Error Writing Image: \(error)")
                }
            } else {
                print("Image is nil")
            }
        } else {
            print("This file exists -- something is already placed at this location")
        }
    }
    
    // load image from directory
    func loadImageFromPath(_ path: String) -> UIImage? {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let folderURL = documentsURL.appendingPathComponent("upload")
        
        let fileURL = folderURL.appendingPathComponent(path)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            //Get Image And upload in server
            print("fileURL.path \(fileURL.path)")
            
            do{
                let data = try Data.init(contentsOf: fileURL)
                let image = UIImage(data: data)
                return image
            }catch{
                print("error getting image")
            }
        } else {
            print("No image in directory")
        }
        
        return nil
    }
    
    // Remove image from directory
    func removeImageFromPath(_ path: String) {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let fileURL = documentsURL.appendingPathComponent("upload/\(path)")
        
        if FileManager.default.fileExists(atPath: fileURL.absoluteString){
            do{
                try FileManager.default.removeItem(at: fileURL)
            }catch{
                print("delete file delete error")
            }
            
        }
    }
}

extension URL {
    static func createFolder(folderName: String) -> URL? {
        let fileManager = FileManager.default
        // Get document directory for device, this should succeed
        if let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first {
            // Construct a URL with desired folder name
            let folderURL = documentDirectory.appendingPathComponent(folderName)
            // If folder URL does not exist, create it
            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    // Attempt to create folder
                    try fileManager.createDirectory(atPath: folderURL.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
                } catch {
                    // Creation failed. Print error & return nil
                    print(error.localizedDescription)
                    return nil
                }
            }
            // Folder either exists, or was created. Return URL
            return folderURL
        }
        // Will only be called if document directory not found
        return nil
    }
}
