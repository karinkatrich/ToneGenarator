//
//  PresetsTableVC.swift
//  Quantum Frequency
//
//  Created by Карина on 19.07.16.
//  Copyright © 2016 Карина. All rights reserved.
//

import UIKit
import MessageUI
import CoreData

/// PresetsTableViewController is responsible for showing standard and custom sequences, sharing.

class PresetsTableVC: UITableViewController, PresetDelegate, MFMailComposeViewControllerDelegate {
    
    var sequenceList: [QFSequence] = []
    var sequenceNewList: [QFSequence] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
      //  NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(PresetsTableVC.updateSequences), name:"AddedSequencesNotify", object: nil)
    }
    
    @objc func updateSequences()
    {
        self.scanCoreData()
        self.tableView.reloadData()
    }
    
   override func viewWillAppear(_ animated: Bool) {
    
        super.viewWillAppear(animated)
           NotificationCenter.default.addObserver(self,
                                                            selector:#selector(PresetsTableVC.updateSequences),
                                                            name:NSNotification.Name(rawValue: "AddedSequencesNotify"),
                                                            object: nil)
         updateSequences()
        //self.scanCoreData()
        //self.tableView.reloadData()
    }
    
   override func viewWillDisappear(_ animated: Bool) {
   NotificationCenter.default.removeObserver(self,
                                                    name:NSNotification.Name(rawValue: "AddedSequencesNotify"),
                                                    object: nil)
    }
    
    
    //===========================================================================================
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_sequence" {
            let vc = segue.destination as! SequenceTableViewController
            let sequence = sequenceList[(self.tableView.indexPathForSelectedRow! as NSIndexPath).row]
            vc.sequence = sequence
        } else if segue.identifier == "showNew" {
            let vc = segue.destination as! SequenceTableViewController
            let sequence = sequenceNewList[(self.tableView.indexPathForSelectedRow! as NSIndexPath).row]
            vc.sequence = sequence
        } else if segue.identifier == "add_new" {
            let nav: UINavigationController = segue.destination as! UINavigationController
            let vc:CustomTableViewController = nav.viewControllers[0] as! CustomTableViewController
            vc.delegate = self
        }
    }
        
    
    //===========================================================================================

    // MARK: - Testability
    func canSendMail () -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
    
    func mailComposer () -> MFMailComposeViewController {
        return MFMailComposeViewController()
    }

    // MARK: - UI actions
    
    @IBAction func shareButtonPressed() {
        let st = SequenceText(sequences: self.sequenceNewList)
        let filePath = st.write()
        
        var text2: NSString = ""
        
        do {
            text2 = try NSString(contentsOf: filePath as URL, encoding: String.Encoding.utf8.rawValue)
        }
        catch { let alertController: UIAlertController = UIAlertController(title: "Info", message: "Can not send the sequence", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
            return
        }
        
        if (canSendMail()){
            let data = text2.data(using: String.Encoding.utf8.rawValue)
            
            let composeVC = mailComposer()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients([""])
            composeVC.setSubject("Quantum Frequency")
            composeVC.setMessageBody("This is Quantum Frequency object", isHTML: false)
            composeVC.addAttachmentData(data!, mimeType: "text/plain", fileName: "SequencesCollection.sqs")
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
        else{
            // Show some error message here
        }
    }

    
    //===========================================================================================
    

    // MARK: - Internal methods
    
    func scanCoreData() {
        self.sequenceList = DefaultSequences.sequences()
        let sequenceEntityList: [SequenceEntity] = Service.shared.allSequences()
        var sequences: [QFSequence] = []
        for se: SequenceEntity in sequenceEntityList {
            sequences.append(QFSequence(sequence: se))
        }
        
        self.sequenceNewList = sequences
    }

    
    //===========================================================================================
    
    
    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    //===========================================================================================
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return self.sequenceList.count
        case 1:
            return self.sequenceNewList.count
        default:
            return 0
        }
        
    }
    
    
    //===========================================================================================
    

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if (indexPath as NSIndexPath).section == 0 {
            return false
        } else {
            return true
    }
       
    }
        
    
    //===========================================================================================
    
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath as NSIndexPath).section {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "newToneCell", for: indexPath)
            let sequence = sequenceNewList[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = sequence.name
            return cell
        default :
            let cell = tableView.dequeueReusableCell(withIdentifier: "tone_cell", for: indexPath)
            let sequence = sequenceList[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = sequence.name
            return cell
        }
    }
        
    
    //===========================================================================================
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Default"
        default:
            return "Custom"
        }
    }
        
    
    //===========================================================================================
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sequence: QFSequence = self.sequenceNewList[(indexPath as NSIndexPath).row]
           Service.shared.deleteSequenceByTitle(sequence.name)
            // Delete the row from the data source
            sequenceNewList.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }
    
    
    //===========================================================================================
    
    
    // MARK: - PresetDelegate

    func didRecieveSequence(_ sequence: QFSequence) {
      //  self.scanCoreData()
      //  self.tableView.reloadData()
       self.dismiss(animated: true, completion: nil)
        
    }
}

    //===========================================================================================
    
    
    // MARK: - MFMailComposeViewControllerDelegate
    

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
       
     controller.dismiss(animated: true, completion: nil)

    }
