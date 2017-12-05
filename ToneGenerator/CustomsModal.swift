//
//  CustomsModal.swift
//  Quantum Frequency
//
//  Created by Карина on 19.07.16.
//  Copyright © 2016 Карина. All rights reserved.
//

import Foundation
import UIKit

class CustomsModal {
    
    fileprivate(set) internal var minutes : Int
    fileprivate(set) internal var seconds : Int
    
    init  (minutes: Int, seconds: Int) {
        precondition((minutes > 0) && (seconds > 0))
        
        self.minutes = minutes
        self.seconds = seconds
    }
}
