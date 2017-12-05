//
//  ToneCell.swift
//  Quantum Frequency
//
//  Created by Карина on 20.07.16.
//  Copyright © 2016 Карина. All rights reserved.
//

import UIKit


class ToneCell: UITableViewCell {

    @IBOutlet weak var minCount : UILabel!
    @IBOutlet weak var secCount : UILabel!
    @IBOutlet weak var hzCount : UILabel!
    @IBOutlet weak var simpleProgress: UIProgressView!
    
    var timer: Timer!
    var allLength : Int!
    var currentLength: Int = 0
   
    func didStartPlayTone(_ length: Int) {
        
        simpleProgress.isHidden = false
        allLength = length
        
        didUpdateProgressView(currentLength)
    }
    
    func didUpdateProgressView(_ length: Int) {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(didRecieveTimerEvent), userInfo: nil, repeats: false)
    }
    
    @objc func didRecieveTimerEvent() {
        
        if currentLength != allLength {
            currentLength += 1
            //let value:Float = 100/Float(currentLength)
            let value:Float =  Float(allLength)/Float(currentLength)
            simpleProgress.setProgress(value, animated:true)
            didUpdateProgressView(currentLength)
        }
        else
        {
            simpleProgress.isHidden = true
        }
    
    }

}
