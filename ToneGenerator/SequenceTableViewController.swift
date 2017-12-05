//
//  SequenceTableViewController.swift
//  Quantum Frequency
//
//  Created by Карина on 20.07.16.
//  Copyright © 2016 Карина. All rights reserved.
//

import UIKit
import AVFoundation
import MessageUI


/// The SequenceTableViewController class creates a controller object that manages a sequence: playing, sharing.

class SequenceTableViewController: UITableViewController, SPlayerDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, UIApplicationDelegate {
    

    var current: Int = 0
    
    var sequence: QFSequence?
    var playButton: UIButton?
    var sequencePlayer: SequencePlayer?


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = sequence?.name
        self.tableView.estimatedRowHeight = 130
       // self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.playButton = UIButton(type: .custom)
        self.playButton!.setTitle("Play ▶︎", for: UIControlState())
        self.playButton!.addTarget(self, action: #selector(playSequencePlayer), for: .touchUpInside)
        self.playButton!.setTitleColor(UIColor.white, for: UIControlState())
        self.playButton!.backgroundColor = UIColor.black
        let buttonWidth = tableView.bounds.width
        self.playButton!.frame = CGRect(x: 0.0, y: 0.0, width: buttonWidth, height: 44.0)
        
        self.navigationController?.delegate = self
       _ = UIApplication.shared.applicationState
        
        sequencePlayer = SequencePlayer(s: FMSynthesizer.sharedSynth())
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
        super.viewWillAppear(animated)
        
        if let row = tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: row, animated: false)
        }
        
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(stopPlaying),
                                                         name: NSNotification.Name.UIApplicationDidEnterBackground,
                                                         object: nil)
        
    }
        
    
    //===========================================================================================
    

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                            name: NSNotification.Name.UIApplicationDidEnterBackground,
                                                            object: nil)
    }
    
    
    //===========================================================================================
    
    
    func stopPlaying() {
        if self.sequencePlayer!.playing() {
            self.sequencePlayer?.stop()
        }
    }
        
    
    //===========================================================================================
    

    func navigationController(_: UINavigationController, willShow willShowViewController: UIViewController, animated: Bool) {
        if willShowViewController != self && sequencePlayer!.playing() {
            sequencePlayer?.stop()
        }
    }
        
    
    //===========================================================================================
   
    
    // MARK: - UI actions
    
//       func actionTriggered(sender: UIButton!) {
//        
//        // Get current values.
//        let i = current
//        let max = 10
//        
//        // If we still have progress to make.
//        if i <= max {
//            // Compute ratio of 0 to 1 for progress.
//            let ratio = Float(i) / Float(max)
//            // Set progress.
//            simpleProgress.progress = Float(ratio)
//            // Write message.
//            current++
//        }
//    }
    
    func playSequencePlayer(_ sender: UIButton!) {
        sequencePlayer?.playSequence(sequence, sPlayerDelegate:self)
        self.playButton!.setTitle("Stop ■", for: UIControlState())
        self.playButton!.removeTarget(self, action: #selector(playSequencePlayer), for: .touchUpInside)
        

            self.playButton!.addTarget(self, action: #selector(stopSequencePlayer), for: .touchUpInside)
    }
    
    
    
    //===========================================================================================
    
    
    func stopSequencePlayer(_ sender: UIButton!) {
        sequencePlayer?.stop()
        self.toReadyToPlayState()
    }
    
    
    //===========================================================================================
    
    func didStartPlayTone(_ index: Int, length: Int) {
        let indexPath = IndexPath.init(row: index, section: 0)
        let cell:ToneCell = tableView.cellForRow(at: indexPath) as! ToneCell
        
        cell.didStartPlayTone(length)
    }
    
    //===========================================================================================
    

    func didFinishPlaying() {
        self.toReadyToPlayState()
    }
    
    
    //===========================================================================================
    
    
    func toReadyToPlayState() -> Void {
        self.playButton!.setTitle("Play ▶︎", for:UIControlState() )
        self.playButton!.removeTarget(self, action: #selector(stopSequencePlayer), for: .touchUpInside)
        self.playButton!.addTarget(self, action: #selector(playSequencePlayer), for: .touchUpInside)
    }
    
    
    //===========================================================================================
    
    
    @IBAction func shareSequenceButtonPressed() {

        if (self.sequence!.name == "Solfeggio 7" || self.sequence!.name == "Solfeggio 9" || self.sequence!.name == "Connection" || self.sequence!.name == "DNA Repair")
        { let alertController: UIAlertController = UIAlertController(title: "Info", message: "Can not send base sequence", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil)
            
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients([""])
        composeVC.setSubject("Quantum Frequency")
        composeVC.setMessageBody("This is Quantum Frequency object", isHTML: false)
        
        let attachmentName = self.sequence!.name
        
        composeVC.addAttachmentData((self.sequence?.data())! as Data, mimeType: "text/plain", fileName: String(format: "\(attachmentName).sqnc" ))
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    }
    
    //===========================================================================================
    
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sequence!.tones.count
    }
        
    
    //===========================================================================================
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ToneCell = tableView.dequeueReusableCell(withIdentifier: "tone_cell", for: indexPath) as! ToneCell
        
        let tone = self.sequence!.tones[(indexPath as NSIndexPath).row]
        cell.hzCount.text = String(tone.frequency)
        cell.minCount.text = String(tone.length / 60)
        cell.secCount.text = String(tone.length % 60)
        cell.backgroundColor = tone.color
        
        return cell
    }
            
    
    //===========================================================================================
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let min = sequence!.length() / 60
        let sec = sequence!.length() % 60
        return "Tones \(min) M \(sec) S"
    }
    
    
    //===========================================================================================
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.playButton
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (self.playButton?.frame.size.height)!
    }
    
    //===========================================================================================
    
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
        
    
    //===========================================================================================
}
