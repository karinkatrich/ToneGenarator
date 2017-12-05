//
//  SequenceEntity.swift
//  
//
//  Created by Karina on 09.08.16.
//
//

import Foundation
import CoreData


class SequenceEntity: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    func addObject(_ value: NSManagedObject, forKey key: String) {
        let items = self.mutableOrderedSetValue(forKey: key)
        items.add(value)
    }
    
    func removeObject(_ value: NSManagedObject, forKey key: String) {
        let items = self.mutableOrderedSetValue(forKey: key)
        items.remove(value)
    }
    
}
