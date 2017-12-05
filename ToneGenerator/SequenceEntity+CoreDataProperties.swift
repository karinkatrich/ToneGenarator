//
//  SequenceEntity+CoreDataProperties.swift
//  Quantum Frequency
//
//  Created by Karina on 15.08.16.
//  Copyright © 2016 Karina. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SequenceEntity {

    @NSManaged var name: String?
    @NSManaged var tones: NSSet?

}
