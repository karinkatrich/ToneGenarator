//
//  SequenceText.swift
//  Quantum Frequency
//
//  Created by Karina on 03.08.16.
//  Copyright © 2016 Karina. All rights reserved.
//

import UIKit

/// A SequenceText object is responsible for export of sequences.

class SequenceText {
    
    fileprivate var sequences: [QFSequence] = []
    fileprivate var path: URL = URL(fileURLWithPath: "")
    
    init (sequences: [QFSequence]) {
        self.sequences = sequences
    }
    
    
    func write() -> URL {
        
        let file = "SequencesCollection.sqs"
        var text = "Collection\n"
        
        for s: QFSequence in self.sequences {
            text = text + s.text()
        }
        
        
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
            path = URL(fileURLWithPath: dir).appendingPathComponent(file)
            
            //writing
            do {
                try text.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {print("error")}
        }
        
        return path
    }
    
    func writeSeq() -> URL {
        
        let file = "Sequence.sqnc"
        var text =  ""
        
        for s: QFSequence in self.sequences {
            text = text + s.text()
            
        }
        
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
            path = URL(fileURLWithPath: dir).appendingPathComponent(file)
            
            //writing
            do {
                try text.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch { let alertController: UIAlertController = UIAlertController(title: "Info", message: "Wrong format", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: nil)
                
                alertController.addAction(okAction)

            }
            
            //reading
            do {
                let text2 = try NSString(contentsOf: path, encoding: String.Encoding.utf8.rawValue)
                print(text2)
            }
            catch { let alertController: UIAlertController = UIAlertController(title: "Info", message: "Wrong format", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: nil)
                
                alertController.addAction(okAction) }
        }
        
        return path
    }
    
}
