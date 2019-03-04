//
//  DatabaseManager.swift
//  MarvelRefactor
//
//  Created by Jaz King on 05/02/2019.
//

import RealmSwift

// A helper class for managing objects

class DatabaseManager {
    
    let realm = try! Realm()

    // Add character to DB
    func addCharacter(_ character: [String:Any]) {
        
        // Check if character is already saved
        var characterExists = false
        
        // Fetch characters
        let characters = fetchCharacters()
        
        for c in characters {
            if c.name == character["name"] as! String {
                characterExists = true
            }
        }
        
        // If it is not saved create new character
        if characterExists != true {
            let newCharacter = Character()
            newCharacter.name = character["name"] as! String
            newCharacter.information = character["description"] as! String
            
            if let thumbnail = character["thumbnail"] as? [String: Any],
                let path = thumbnail["path"] as? String,
                let fileExtension = thumbnail["extension"] as? String {
                
                newCharacter.imagePath = path
                newCharacter.imageExtension = fileExtension
                
                //Save image to directory

                
            }
            
            // Persist character data
            try! realm.write {
                realm.add(newCharacter)
            }
        }
    }
    
    //Remove Character
    func removeCharacter(_ character: Character)  {
        
        // Remove image from directory
        removeImageFromPath(character.imagePath)
        
        //Remove character from DB
        try! realm.write {
            realm.delete(character)
        }
        
    }
    
    // Get image URL
    func getImageURL(_ path: String, file: String) -> URL? {
        
        let baseURL = URL(string: path)
        
        let url = baseURL?
            .appendingPathComponent("standard_medium")
            .appendingPathExtension(file)
        
        return url
    }
    
    // Fetch characters from DB
    func fetchCharacters() -> Results<Character> {
        let characters = realm.objects(Character.self)
        return characters
    }

}
