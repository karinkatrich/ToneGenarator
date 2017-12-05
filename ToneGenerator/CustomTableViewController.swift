//
//  CustomTableViewController.swift
//  Quantum Frequency
//
//  Created by Карина on 19.07.16.
//  Copyright © 2016 Карина. All rights reserved.
//

import UIKit
import MessageUI

/// The SequenceTableViewController class creates a controller object that manages a sequence: with custom name and custom list of tones.

class CustomTableViewController: UITableViewController, TitleDelegate, ColorViewControllerDelegate {
    
    var sequenceTitle: String = ""
    var playButton: UIButton?
    var sequence: QFSequence = QFSequence(name:"")
    var selectedToneIndex: Int = 0
    weak var delegate: PresetDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.sequenceTitle = self.sequence.name
        
        let playButton = UIButton(type: .custom)
        playButton.setTitle("Play ▶︎", for: UIControlState())
        playButton.addTarget(self, action: #selector(playAction), for: .touchUpInside)
        playButton.setTitleColor(UIColor.white, for: UIControlState())
        playButton.backgroundColor = UIColor.black
        let buttonWidth = tableView.bounds.width
        playButton.frame = CGRect(x: 0.0, y: 0.0, width: buttonWidth, height: 44.0)
    }
            
    
    //===========================================================================================
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_select" {
            let vc: SelectTableViewController = segue.destination as! SelectTableViewController
            vc.updateDelegate(self)
        }
    }
    
    
    //===========================================================================================
    
    
    // MARK: - UI actions
    
    
    @IBAction func CancelCustomBtn(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
  
    //===========================================================================================
    

    @IBAction func NewSaveBtnPressed(_ sender: AnyObject) {
        self.view.endEditing(true)
        
        let strLength = sequenceTitle.trimmingCharacters(in: CharacterSet.whitespaces).characters.count
        
        if (self.sequenceTitle == "") {
            let alertController: UIAlertController = UIAlertController(title: "Info", message: "The title must not be blank", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
            return
        } else if (strLength == 0) {
            let alertController: UIAlertController = UIAlertController(title: "Info", message: "The title must not be blank", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
            return
            
        } else if (Service.shared.sequencesWithName(self.sequenceTitle).count != 0) {
            let alertController: UIAlertController = UIAlertController(title: "Info", message: "The sequence with specified name already exists", preferredStyle: UIAlertControllerStyle.alert)
            
            // Create the actions
            let  renameAction = UIAlertAction(title: "Rename", style: UIAlertActionStyle.default) {
                UIAlertAction in NSLog("RENAME Pressed")
            }
            
            let substituteAction = UIAlertAction(title: "Substitute", style: UIAlertActionStyle.cancel) {
                UIAlertAction in NSLog("SUBSTITUTE Pressed")
                
                Service.shared.deleteSequenceByTitle(self.sequenceTitle)
                self.sequence.updateName(self.sequenceTitle)
                self.NewSaveBtnPressed(self.sequenceTitle as AnyObject)
                self.tableView.reloadData()
                //self.sequenceTitle = ""
            }
            
            // Add the actions
            alertController.addAction(renameAction)
            alertController.addAction(substituteAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
            return
        } else if(self.sequence.tones.count == 0){
            let alertController: UIAlertController = UIAlertController(title: "Info", message: "Nothing to save", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
            return
        }
    
        self.sequence.updateName(self.sequenceTitle)
                if (self.delegate != nil) {
            self.sequence.saveSequence()
            //self.sequence.save()
            self.tableView.reloadData()
            self.delegate?.didRecieveSequence(self.sequence)
        }

    }
    
    
    //===========================================================================================
    
    
    // MARK: - Internal methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let whitespaceSet = CharacterSet.whitespaces
        let range = string.rangeOfCharacter(from: whitespaceSet)
        if let _ = range {
            
            let alertController: UIAlertController = UIAlertController(title: "Info", message: "The title must have not spaces", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
            return false

        }
        else {
            return true
        }
    }
    
    
    //===========================================================================================
    
    
    func playAction(_ sender: UIButton!) {
        
    }
    //===========================================================================================
    
    
    func toneSelected(_ tone:Tone) {
        self.sequence.appendTone(tone)
        self.tableView.reloadData()
         _ = navigationController?.popViewController(animated: true)
    }
    
    
    //===========================================================================================
    
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    //===========================================================================================
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            // Tones.
            return self.sequence.tones.count
        case 2:
            // Add a tone >
            return 1
        default:
            return 0
        }
    }
    
    
    
    //===========================================================================================
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            // Return the cell for Sequence title.
            
            let cell: TitleViewCell = tableView.dequeueReusableCell(withIdentifier: "title_cell", for: indexPath) as! TitleViewCell
            cell.customEnter.text = self.sequenceTitle
            cell.delegate = self
            return cell
        case 1:
            let cell: CustomTone = tableView.dequeueReusableCell(withIdentifier: "custom_cell", for: indexPath) as! CustomTone
            let tone = self.sequence.tones[(indexPath as NSIndexPath).row]
            cell.hzCountCust.text = String(tone.frequency)
            cell.minCountCust.text = String(tone.length / 60)
            cell.secCountCust.text = String(tone.length % 60)
            cell.backgroundColor = tone.color
            return cell
        default:
            // Return the standard cell for "Add a tone >".
            let cell = tableView.dequeueReusableCell(withIdentifier: "standard_cell", for: indexPath)
            cell.textLabel!.text = "Add a tone"
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    
    //===========================================================================================
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 1:
            let min = self.sequence.length() / 60
            let sec = self.sequence.length() % 60
            return " Tones \(min) M \(sec) S"
        default:
            return ""
        }
    }
    
    
    //===========================================================================================
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath as NSIndexPath).section == 1 {
            
            self.selectedToneIndex = (indexPath as NSIndexPath).row
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "colorViewController") as! ColorViewController
            vc.tone = self.sequence.tones[(indexPath as NSIndexPath).row]
            vc.delegate = self
            
            let nc = UINavigationController.init(rootViewController:vc)
            
            self.present(nc, animated: true, completion: nil)
            
        }
    }
    
    
    //===========================================================================================
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.playButton
    }
    
    
    //===========================================================================================

    
    // MARK: TitleDelegate
    
    func didRecieveTitle(_ title: String) {
        self.sequenceTitle = title
    }
    
    func titleDidUpdate(_ title: String) {
        self.sequenceTitle = title
    }
    

    //===========================================================================================
    
    
    // MARK: - ColorViewControllerDelegate
    
    func didCancelPressed() {
        
        self.presentedViewController!.dismiss(animated: true, completion: nil)
        
    }
    
    //===========================================================================================

    
    func didSavePressed(_ tone: Tone) {
        
        self.presentedViewController!.dismiss(animated: true, completion: nil)
        
        self.sequence.tones[self.selectedToneIndex] = tone
        
        self.tableView.reloadData()
    }

    
    //===========================================================================================

    //===========================================================================================
    
    

    
}
