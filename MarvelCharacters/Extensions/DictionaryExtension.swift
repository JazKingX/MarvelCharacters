//
//  DictionaryExtension.swift
//  MarvelRefactor
//
//  Created by Jaz King on 01/02/2019.
//

import Foundation

extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
