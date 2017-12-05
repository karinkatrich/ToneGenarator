//
//  ToneEntity.swift
//  
//
//  Created by Karina on 08.08.16.
//
//

import UIKit
import CoreData

@objc(ToneEntity)
class ToneEntity: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    func updateToneLenght(_ intLenght: Int) {
        toneLength = NSNumber.init(value: intLenght as Int)
    }
    
    func updateToneFrequency(_ intFrequency: Int) {
        toneFrequecy = NSNumber.init(value: intFrequency as Int)
    }
    
    func updateToneColor(_ color: UIColor) {
        toneColor = color.toHexString()
    }
    
    
    

}
