//
//  Sequence.swift
//  Quantum Frequency
//
//  Created by Карина on 19.07.16.
//  Copyright © 2016 Карина. All rights reserved.
//

import UIKit
import CoreData

/// A Sequence object represents a list of tones with name.
class QFSequence {
    
    /// Name of the sequence.
    fileprivate(set) internal var name: String
    var tones: [Tone]
    
    //private(set) internal var frequency: Int
    
    init (name: String!) {
        self.name = name
        tones = []
    }
    
    init (sequence: SequenceEntity) {
        self.name = sequence.name!
        var tones: [Tone] = []
        for toneEntity: ToneEntity in sequence.tones!.allObjects as! [ToneEntity] {
            tones.append(Tone(tone: toneEntity))
        }
        self.tones = tones
    }
    
    init (name: String, tonesArray: [Tone]){
        self.name = name
        tones = tonesArray
    }
    
    // Initialize sequence from file.
    init (filePath: URL) {
        self.name = ""
        tones = []
        
        //reading
        do {
            let sequenceText = try NSString(contentsOf: filePath, encoding: String.Encoding.utf8.rawValue) as String!
            
            var sequenceLines:[String] = []
            
            sequenceLines = (sequenceText?.components(separatedBy: NSCharacterSet.newlines))!
            
            self.name = sequenceLines[0]

            for i in 1 ..< sequenceLines.count {

                let toneString = sequenceLines[i].trimmingCharacters(in: CharacterSet.whitespaces)
                
                let toneItems:[String] = toneString.components(separatedBy: CharacterSet.whitespaces)
                print(toneItems)
                
                /// We expect 8 items: 333 Hz 2 m 3 s color #FC1919"
                /// Tone, "Hz", minutes number, "m", seconds number, "s", "color", color hex code.
                if (toneItems.count == 8) {
                    self.appendTone(Tone.init(componentsArray: toneItems as NSArray))
                }
            }
        }
        catch {
            let alertController: UIAlertController = UIAlertController(title: "Info", message: "Wrong format", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: nil)
            
            alertController.addAction(okAction)
        }
        
    }

    
    //===========================================================================================
    
    
    func length() -> Int {
        return tones.reduce(0) { $0 + $1.length }
    }
    
    func updateName(_ newName: String) {
        name = newName
    }
    
    func updateTones(_ newTones: [Tone]) {
        tones = newTones
    }
    
    func appendTone(_ tone: Tone!) -> Void {
        tones.append(tone)
    }
        
    
    //===========================================================================================
    
    
    func text() -> String {
        
        var text = ""
        let name: String = self.name
        text = text + String(format: "\(name)\n")
        
        for t: Tone in self.tones {
            let freq: Int = t.frequency
            let min: Int = t.length / 60
            let sec: Int = t.length % 60
            let color: String = t.color.toHexString().uppercased()
            let result = String(format: "  \(freq) Hz \(min) m \(sec) s color \(color)\n")
            
            text = text + result
        }
        
        return text
    }
    
    
    //===========================================================================================
        

    func data() -> Data {
        let textStr :NSString = self.text() as NSString
        
        return textStr.data(using: String.Encoding.utf8.rawValue)!
    }
    
    
    //===========================================================================================
    

    func saveSequence() {
        let sequenceEntity: SequenceEntity = Service.shared.newSequenceEntity()
        sequenceEntity.name = self.name
        
        
        for toneEntity in sequenceEntity.tones! {
            Service.shared.delete([toneEntity as! NSManagedObject])
        }
        
        for tone in self.tones {
            sequenceEntity.addObject(tone.toneEntity(), forKey: "tones")
        }
        
        Service.shared.saveContext()
    }
    
    
    //===========================================================================================
    
    
    fileprivate func toneEntities() -> Set<ToneEntity> {
        let entities: NSMutableSet = NSMutableSet()
        for tone: Tone in self.tones {
            entities.add(tone.toneEntity())
        }
        return entities.copy() as! Set<ToneEntity>
    }
}
