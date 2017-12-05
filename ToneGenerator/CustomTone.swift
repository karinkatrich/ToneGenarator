//
//  CustomTone.swift
//  Quantum Frequency
//
//  Created by Карина on 21.07.16.
//  Copyright © 2016 Карина. All rights reserved.
//

import UIKit

class CustomTone: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var minCountCust: UILabel!
    @IBOutlet weak var secCountCust: UILabel!
    @IBOutlet weak var hzCountCust: UILabel!
    
    var tone:Tone?

    func configure(_ tone:Tone) {
        self.tone = tone
       
    }
}

