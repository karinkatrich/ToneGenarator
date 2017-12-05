//
//  SelectSequence.swift
//  Quantum Frequency
//
//  Created by Karina on 27.07.16.
//  Copyright © 2016 Karina. All rights reserved.
//

import Foundation

class SelectSequence {
    
    /// Name of the sequence.
    fileprivate(set) internal var name: String
    fileprivate(set) internal var selectTones: [Tone]
    
    init (name: String!) {
        self.name = name
        selectTones = []
    }
    
    func length() -> Int {
        return selectTones.reduce(0) { $0 + $1.length }
    }
    
    func appendTone(_ tone: Tone!) -> Void {
        selectTones.append(tone)
    }
    
}
