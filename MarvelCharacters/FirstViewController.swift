//
//  FirstViewController.swift
//  MarvelCharacters
//
//  Created by Jaz King on 02/03/2019.
//  Copyright © 2019 Jaz King. All rights reserved.
//

import UIKit
import Kingfisher

class MarvelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var characters: [[String: Any]] = []
    
    var fetchingMore = false
    private var offset = 0
    
    //Cache images for faster loading
    let imageCache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as! CharacterCell
        
        let character = characters[indexPath.item]
        
        cell.nameLabel.text = character["name"] as? String
        cell.descriptionLabel.text = character["description"] as? String
        
        // Load Image
        let databaseManager = DatabaseManager()
        if let thumbnail = character["thumbnail"] as? [String: Any],
            let path = thumbnail["path"] as? String,
            let fileExtension = thumbnail["extension"] as? String {
            
            if let url = databaseManager.getImageURL(path, file: fileExtension) {
                //Use chached image
                if let imageFromCache = imageCache.object(forKey: url.absoluteString as NSString) {
                    cell.characterImageView.image = imageFromCache
                } else {
                    cell.characterImageView.kf.setImage(with: url)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let character = characters[indexPath.item]
        
        // Alert to save
        // Save Character to RealmDB
        // Present Alert to remove/recover page
        let alertController = UIAlertController(title: "Save Character", message: "Do you want to save this character offline?", preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        let save = UIAlertAction(title: "Save", style: .default) { (action) in
            
            //Save character offline
            let databaseManager = DatabaseManager()
            databaseManager.addCharacter(character)
            
            // Update Second View
            NotificationCenter.default.post(name: .reloadProjects, object: nil)
        }
        
        alertController.addAction(cancel)
        alertController.addAction(save)
        self.present(alertController, animated: true) { }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height * 4 {
            if !fetchingMore {
                offset += 100
                beginBatchFetch()
            }
            
        }
    }
    
    func beginBatchFetch() {
        fetchingMore = true
        print("beginBatchFetch!")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            //let newItems = (self.items.count...self.items.count + 12).map { index in index }
            //self.items.append(contentsOf: newItems)
            self.fetchData()
            self.fetchingMore = false
            //self.tableView.reloadData()
        })
    }
    
    func fetchData() {
        //Fetch data
        //Offset is the start + 100
        
        URLSession.shared.dataTask(with: MarvelRequestBuilder.defaultBuilder.charactersRequest(offset: offset)) { (data, response, error) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                guard
                    let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []),
                    let jsonDictionary = json as? [String: Any],
                    let dataDictionary = jsonDictionary["data"] as? [String: Any],
                    let characters = dataDictionary["results"] as? [[String: Any]]
                    else {
                        let genericMessage = "Something went wrong... did you set your API keys?"
                        let errorMessage = error?.localizedDescription ?? genericMessage
                        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                        self.present(alert, animated: true)
                        return
                }
                
                if characters.isEmpty != true {
                    self.characters.append(contentsOf: characters)
                }
                
                self.tableView.reloadData()
                
            }
            }.resume()
    }
}
