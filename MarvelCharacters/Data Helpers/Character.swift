//
//  Character.swift
//  MarvelRefactor
//
//  Created by Jaz King on 03/02/2019.
//

import RealmSwift

class Character: Object {
    @objc dynamic var name = ""
    @objc dynamic var information = ""
    @objc dynamic var imagePath = ""
    @objc dynamic var imageExtension = ""

}
