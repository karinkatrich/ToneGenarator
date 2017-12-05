//
//  ImportManager.swift
//  Quantum Frequency
//
//  Created by Karina on 08.09.16.
//  Copyright © 2016 Karina. All rights reserved.
//

import Foundation

class ImportManager {
    
    static let shared = ImportManager()
    
    let kSequence:String = "sqnc"
    let kCollectionSequences:String = "sqs"
    
    
    let kDidAddSequences = "AddedSequencesNotify"
    
    func importSequences(_ url:URL)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController?.dismiss(animated: true, completion: nil)
        
        if (url.pathExtension == kSequence) {
            self.saveSequenceFile(url)
        }
        if (url.pathExtension == kCollectionSequences) {
            self.saveCollection(url)
        }
    }
    
    
    fileprivate func saveCollection(_ fromPath: URL) {
        var currentSequenceName: String = ""
        var currentTones: [Tone] = []
        let sequences: NSMutableArray = NSMutableArray()
        do {
            let collectionText = try NSString(contentsOf: fromPath, encoding: String.Encoding.utf8.rawValue) as String
            
            var collectionLines:[String] = []
            
            collectionLines = (collectionText.components (separatedBy: NSCharacterSet.newlines))
            
            currentSequenceName = collectionLines[1]
            for i in 2 ..< collectionLines.count {
                
                let line = collectionLines[i]
                
                if (!line.hasPrefix("  ")) {
                    if (currentSequenceName != "") {
//                        self.importSequence(currentSequenceName, tones: currentTones)
                        sequences.add(QFSequence(name: currentSequenceName, tonesArray: currentTones))
                    }
                    
                    currentSequenceName = line.trimmingCharacters(in: CharacterSet.whitespaces)
                    currentTones = []
                }
                if (line.hasPrefix("  ")) {
                    let toneString = line.trimmingCharacters(in: CharacterSet.whitespaces)
                    let toneItems:[String] = toneString.components(separatedBy: CharacterSet.whitespaces)
                    currentTones.append(Tone.init(componentsArray: toneItems as NSArray))
                }
                
                if i == collectionLines.count-1 {
                    sequences.add(QFSequence(name: currentSequenceName, tonesArray: currentTones))
                }
            }
            
//            self.importSequence(currentSequenceName, tones: currentTones)
            
            self.importCollectSequences(sequences)
        }
            
        catch  {
            let alertController: UIAlertController = UIAlertController(title: "Info", message: "Wrong format", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: nil)
            
            alertController.addAction(okAction)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            
            return
        }
    }
    
    
    fileprivate func importCollectSequences(_ sequences: NSMutableArray)
    {
        if sequences.count > 0 {
            let sequence:QFSequence = sequences[0] as! QFSequence
            
            let strLength = sequence.name.trimmingCharacters(in: CharacterSet.whitespaces).characters.count
        
        if sequence.name == "" || Service.shared.sequencesWithName(sequence.name).count != 0 || strLength == 0 {
            var message: String = ""
            if sequence.name == "" {
                message = "The title must not be blank"
            }
            else if (strLength == 0)
            {
                message = "Nothing to save"
            }
            else {
                message = "The sequence with such name already exists, please rename"
            }
            
            var alertController:UIAlertController?
            alertController = UIAlertController(title: "Info", message: message,preferredStyle: .alert)
            alertController!.addTextField(
                configurationHandler: {
                    (textField: UITextField!) in textField.placeholder = "Enter the name"
                }
            )
            let action = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
                [weak self]
                
                (paramAction:UIAlertAction!) in
                if let textFields = alertController?.textFields {
                    let theTextFields = textFields as [UITextField]
                    let enteredText = theTextFields[0].text
                    sequence.updateName(enteredText!)
                    let textLength = enteredText!.trimmingCharacters(in: CharacterSet.whitespaces).characters.count
                    
                    if textLength != 0 {
                        sequence.saveSequence()
                        NotificationCenter.default.post(name: Notification.Name(rawValue: self!.kDidAddSequences), object: nil)
                        sequences.remove(sequence)
                    }
                    
                    self!.importCollectSequences(sequences)
                }
                })
            
            alertController?.addAction(action)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window!.rootViewController?.present(alertController!, animated: true, completion: nil)
            
            return
        }
        else
        {
            sequence.saveSequence()
            NotificationCenter.default.post(name: Notification.Name(rawValue: kDidAddSequences), object: nil)
            sequences.remove(sequence)
            self.importCollectSequences(sequences)
        }
        }
    }
    
    //=============================================================================================
    
    
    fileprivate func importSequence (_ sequenceName: String, tones: [Tone]) {
        
        let strLength = sequenceName.trimmingCharacters(in: CharacterSet.whitespaces).characters.count
        
        if sequenceName == "" || Service.shared.sequencesWithName(sequenceName).count != 0 || strLength == 0 {
            var message: String = ""
            
            if sequenceName == "" {
                message = "The title must not be blank"
            }
            else if strLength == 0
            {
                message = "Nothing to save"
            }
            else {
                message = "The sequence with such name already exists, please rename"
          
            }
            var alertController:UIAlertController?
            alertController = UIAlertController(title: "Info", message: message,preferredStyle: .alert)
            alertController!.addTextField(
                configurationHandler: {
                    (textField: UITextField!) in textField.placeholder = "Enter the name"
                }
            )
            
            let action = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
                [weak self]
                
                (paramAction:UIAlertAction!) in
                if let textFields = alertController?.textFields {
                    let theTextFields = textFields as [UITextField]
                    let enteredText = theTextFields[0].text
                    self!.importSequence(enteredText!, tones: tones)
            
//                    self!.importSequence(enteredText!, tones: tones)
                }
                })
            
            alertController?.addAction(action)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window!.rootViewController?.present(alertController!, animated: true, completion: nil)
            
            return
        }
        
        let sequence = QFSequence.init(name: sequenceName, tonesArray: tones)
        
        sequence.saveSequence()
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: kDidAddSequences), object: nil)
    }
    
    
    //=============================================================================================
    
    
        fileprivate func saveSequenceFile(_ fromPath: URL) {
        var sequenceName: String = ""
        var tones: [Tone] = []
        
        do {
            let sequenceFileText = try NSString(contentsOf: fromPath, encoding: String.Encoding.utf8.rawValue) as String
            
            var sequenceFileLines:[String] = []
            
            sequenceFileLines = (sequenceFileText.components(separatedBy: NSCharacterSet.newlines))
            sequenceName = sequenceFileLines[0]
            
            for i in 1 ..< sequenceFileLines.count {
                
                let line = sequenceFileLines[i]
                
                let toneString = line.trimmingCharacters(in: CharacterSet.whitespaces)
                let toneItems:[String] = toneString.components(separatedBy: CharacterSet.whitespaces)
                
                if (toneItems.count != 8) {
                    continue
                }
                
                let currentTone: Tone = Tone(componentsArray: toneItems as NSArray)
                tones.append(currentTone)
            }
        }
            
        catch {
            let alertController: UIAlertController = UIAlertController(title: "Info", message: "Wrong format", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            
            alertController.addAction(okAction)
            return
        }
        
        self.importSequence(sequenceName, tones: tones)
    }
}
