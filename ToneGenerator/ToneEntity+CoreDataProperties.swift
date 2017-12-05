//
//  ToneEntity+CoreDataProperties.swift
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

extension ToneEntity {

    @NSManaged var toneColor: String?
    @NSManaged var toneFrequecy: NSNumber?
    @NSManaged var toneLength: NSNumber?
    @NSManaged var sequenceEntity: SequenceEntity?

}
