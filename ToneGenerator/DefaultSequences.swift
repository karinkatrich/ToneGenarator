//
//  DefaultSequences.swift
//  Quantum Frequency
//
//  Created by Карина on 19.07.16.
//  Copyright © 2016 Карина. All rights reserved.
//

import Foundation
import UIKit

/// A DefaultSequences object represents a list of existing tone.

class DefaultSequences {
    class func sequences() -> [QFSequence] {
        
        let t28 = Tone(length: 300, frequency: 396, color: UIColor(red:0.56, green:0.00, blue:0.00, alpha:1.0))
        let t29 = Tone(length: 300, frequency: 417, color: UIColor(red:1.00, green:0.71, blue:0.44, alpha:1.0))
        let t30 = Tone(length: 300, frequency: 528, color: UIColor(red:0.98, green:0.78, blue:0.01, alpha:1.0))
        let t31 = Tone(length: 300, frequency: 639, color: UIColor(red:0.19, green:0.68, blue:0.14, alpha:1.0))
        let t32 = Tone(length: 300, frequency: 741, color: UIColor(red:0.02, green:0.42, blue:0.99, alpha:1.0))
        let t33 = Tone(length: 300, frequency: 852, color: UIColor(red:0.47, green:0.36, blue:0.71, alpha:1.0))
        let t34 = Tone(length: 300, frequency: 963, color: UIColor(red:0.51, green:0.29, blue:0.49, alpha:1.0))
        
        
        let t35 = Tone(length: 300, frequency: 174, color: UIColor(red:0.36, green:0.35, blue:0.35, alpha:1.0))
        let t36 = Tone(length: 300, frequency: 285, color: UIColor(red:0.95, green:0.04, blue:0.59, alpha:1.0))
        let t37 = Tone(length: 300, frequency: 396, color: UIColor(red:0.56, green:0.00, blue:0.00, alpha:1.0))
        let t38 = Tone(length: 300, frequency: 417, color: UIColor(red:1.00, green:0.71, blue:0.44, alpha:1.0))
        let t39 = Tone(length: 300, frequency: 528, color: UIColor(red:0.98, green:0.78, blue:0.01, alpha:1.0))
        let t40 = Tone(length: 300, frequency: 639, color: UIColor(red:0.19, green:0.68, blue:0.14, alpha:1.0))
        let t41 = Tone(length: 300, frequency: 741, color: UIColor(red:0.02, green:0.42, blue:0.99, alpha:1.0))
        let t42 = Tone(length: 300, frequency: 852, color: UIColor(red:0.47, green:0.36, blue:0.71, alpha:1.0))
        let t43 = Tone(length: 300, frequency: 963, color: UIColor(red:0.51, green:0.29, blue:0.49, alpha:1.0))
        
        
        let t44 = Tone(length: 1800, frequency: 726, color: UIColor(red:0.18, green:0.53, blue:0.85, alpha:1.0))
        
        let t45 = Tone(length: 1800, frequency: 528, color: UIColor(red:0.98, green:0.78, blue:0.01, alpha:1.0))
        
        
        let s1 = QFSequence(name: "Solfeggio 7")
        s1.appendTone(t28)
        s1.appendTone(t29)
        s1.appendTone(t30)
        s1.appendTone(t31)
        s1.appendTone(t32)
        s1.appendTone(t33)
        s1.appendTone(t34)
        
        let s2 = QFSequence(name: "Solfeggio 9")
        s2.appendTone(t35)
        s2.appendTone(t36)
        s2.appendTone(t37)
        s2.appendTone(t38)
        s2.appendTone(t39)
        s2.appendTone(t40)
        s2.appendTone(t41)
        s2.appendTone(t42)
        s2.appendTone(t43)
        
        let s3 = QFSequence(name: "Connection")
        s3.appendTone(t44)
        
        let s4 = QFSequence(name: "DNA Repair")
        s4.appendTone(t45)
        
        
        return [s1, s2, s3, s4]
    }
}
