//
//  Tone.swift
//  Quantum Frequency
//
//  Created by Карина on 19.07.16.
//  Copyright © 2016 Карина. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/// A Tone object represents a single audio tone.
class Tone {
    
    /// The length of the tone in seconds. It can't be zero.
    fileprivate(set) internal var length: Int
    
    /// The frequency in Hz. It can't be zero.
    fileprivate(set) internal var frequency: Int
    
    /// The color of the bar to be shown on the screen.
    fileprivate(set) internal var color: UIColor
    
    init () {
        self.length = 0
        self.frequency = 0
        self.color = UIColor.white
    }
    
    init (length: Int) {
        self.length = length
        self.frequency = 0
        self.color = UIColor.white
    }
    
    init (frequency: Int) {
        self.length = 0
        self.frequency = frequency
        self.color = UIColor.white
    }
    
    init (length: Int, frequency: Int, color: UIColor!) {
        precondition((length > 0) && (frequency > 0))
        let num: NSNumber = NSNumber(value: 123 as Int)
        _ = num.int32Value
        self.length = length
        self.frequency = frequency
        self.color = color
    }
    
    init (componentsArray: NSArray) {
        let frequence = componentsArray[0]
        let minutes = componentsArray[2]
        let seconds = componentsArray[4]
        let color = componentsArray[7]
        
        self.frequency = (frequence as AnyObject).intValue
        self.length = (seconds as AnyObject).intValue
        self.length = self.length + ((minutes as AnyObject).intValue*60)
        
        self.color = UIColor(hexString: color as! String)
    }
    
    
    init (tone: ToneEntity) {
        self.length = (tone.toneLength?.intValue)!
        self.frequency = (tone.toneFrequecy?.intValue)!
        self.color = UIColor(hexString: tone.toneColor!)
    }
    
    /// Creates a ToneEntity instance for the current Tone instance and saves it to CoreData.
    ///
    /// - returns: A new ToneEntity instance.
    func toneEntity() -> ToneEntity {
        let toneEntity: ToneEntity = Service.shared.newToneEntity()
        toneEntity.updateToneLenght(self.length)
        toneEntity.updateToneFrequency(self.frequency)
        toneEntity.updateToneColor(self.color)
        Service.shared.saveContext()
        return toneEntity
    }
}
