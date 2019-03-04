//
//  SavedViewController.swift
//  MarvelCharacters
//
//  Created by Jaz King on 02/03/2019.
//  Copyright © 2019 Jaz King. All rights reserved.
//

import UIKit
import RealmSwift

class SavedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let dataManagaer = DatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData(notification:)), name: .reloadProjects, object: nil)
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let characters = dataManagaer.fetchCharacters()
        
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as! SavedCharacterCell
        
        let characters = dataManagaer.fetchCharacters()
        let character = characters[indexPath.item]
        
        cell.nameLabel.text = character.name
        cell.descriptionLabel.text = character.information
        
        /*
         if let i = dataManagaer.loadImageFromPath(character.imagePath) {
         cell.characterImageView.image = i
         }
         */
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath)
        
        // Remove from database ?
        
    }
    
}

extension SavedViewController {
    
    @objc func refreshData(notification: NSNotification) {
        self.tableView.reloadData()
    }
    
}
