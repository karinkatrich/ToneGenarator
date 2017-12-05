//
//  Select.swift
//  Quantum Frequency
//
//  Created by Karina on 26.07.16.
//  Copyright © 2016 Karina. All rights reserved.
//

import UIKit

class Select: UITableViewCell {

    @IBOutlet weak var minSelect: UILabel!
    @IBOutlet weak var secSelect: UILabel!
    @IBOutlet weak var hzSelect: UILabel!
    
    var tone:Tone?
    
    func configure(_ tone:Tone) {
        self.tone = tone
    }
}
