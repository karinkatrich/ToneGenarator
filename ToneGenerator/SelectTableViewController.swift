//
//  CustomToneTableViewController.swift
//  Quantum Frequency
//
//  Created by Karina on 25.07.16.
//  Copyright © 2016 Карина. All rights reserved.
//


import UIKit

/// The SelectTableViewController class showing a list of standart tones.

class SelectTableViewController: UITableViewController, ColorViewControllerDelegate {
    
    var selectSequence: SelectSequence?
    var tes = Tone()
    var lCustomTableViewController : CustomTableViewController?
    var toneList: [Tone] = []
    var toneNewList: [Tone] = []
    
    func newSequences() -> [Tone] {
        let t1 = Tone(length: 300, frequency: 111, color: UIColor(red:0.60, green:0.58, blue:0.60, alpha:1.0))
        let t2 = Tone(length: 300, frequency: 159, color: UIColor(red:0.62, green:0.61, blue:0.61, alpha:1.0))
        let t3 = Tone(length: 300, frequency: 174, color: UIColor(red:0.36, green:0.35, blue:0.35, alpha:1.0))
        let t4 = Tone(length: 300, frequency: 222, color: UIColor(red:0.98, green:0.73, blue:0.90, alpha:1.0))
        let t5 = Tone(length: 300, frequency: 261, color: UIColor(red:0.93, green:0.45, blue:0.77, alpha:1.0))
        let t6 = Tone(length: 300, frequency: 285, color: UIColor(red:0.95, green:0.04, blue:0.59, alpha:1.0))
        let t7 = Tone(length: 300, frequency: 333, color: UIColor(red:0.99, green:0.10, blue:0.10, alpha:1.0))
        let t8 = Tone(length: 300, frequency: 372, color: UIColor(red:0.72, green:0.01, blue:0.01, alpha:1.0))
        let t9 = Tone(length: 300, frequency: 396, color: UIColor(red:0.56, green:0.00, blue:0.00, alpha:1.0))
        let t10 = Tone(length: 300, frequency: 417, color: UIColor(red:1.00, green:0.71, blue:0.44, alpha:1.0))
        let t11 = Tone(length: 300, frequency: 444, color: UIColor(red:1.00, green:0.60, blue:0.21, alpha:1.0))
        let t12 = Tone(length: 300, frequency: 483, color: UIColor(red:0.90, green:0.44, blue:0.00, alpha:1.0))
        let t13 = Tone(length: 300, frequency: 528, color: UIColor(red:0.98, green:0.78, blue:0.01, alpha:1.0))
        let t14 = Tone(length: 300, frequency: 555, color: UIColor(red:0.98, green:0.75, blue:0.01, alpha:1.0))
        let t15 = Tone(length: 300, frequency: 594, color: UIColor(red:0.91, green:0.72, blue:0.16, alpha:1.0))
        let t16 = Tone(length: 300, frequency: 615, color: UIColor(red:0.02, green:0.88, blue:0.47, alpha:1.0))
        let t17 = Tone(length: 300, frequency: 639, color: UIColor(red:0.19, green:0.68, blue:0.14, alpha:1.0))
        let t18 = Tone(length: 300, frequency: 666, color: UIColor(red:0.07, green:0.47, blue:0.18, alpha:1.0))
        let t19 = Tone(length: 300, frequency: 726, color: UIColor(red:0.18, green:0.53, blue:0.85, alpha:1.0))
        let t20 = Tone(length: 300, frequency: 741, color: UIColor(red:0.02, green:0.42, blue:0.99, alpha:1.0))
        let t21 = Tone(length: 300, frequency: 777, color: UIColor(red:0.00, green:0.00, blue:0.54, alpha:1.0))
        let t22 = Tone(length: 300, frequency: 837, color: UIColor(red:0.72, green:0.70, blue:0.98, alpha:1.0))
        let t23 = Tone(length: 300, frequency: 852, color: UIColor(red:0.47, green:0.36, blue:0.71, alpha:1.0))
        let t24 = Tone(length: 300, frequency: 888, color: UIColor(red:0.23, green:0.14, blue:0.36, alpha:1.0))
        let t25 = Tone(length: 300, frequency: 948, color: UIColor(red:0.68, green:0.39, blue:0.66, alpha:1.0))
        let t26 = Tone(length: 300, frequency: 963, color: UIColor(red:0.51, green:0.29, blue:0.49, alpha:1.0))
        let t27 = Tone(length: 300, frequency: 999, color: UIColor(red:0.37, green:0.22, blue:0.36, alpha:1.0))
       // let t28 = Tone(length: 300, frequency: 396, color: UIColor(red:0.56, green:0.00, blue:0.00, alpha:1.0))
        //let t29 = Tone(length: 300, frequency: 417, color: UIColor(red:1.00, green:0.71, blue:0.44, alpha:1.0))
       // let t30 = Tone(length: 300, frequency: 528, color: UIColor(red:0.98, green:0.78, blue:0.01, alpha:1.0))
        //let t31 = Tone(length: 300, frequency: 639, color: UIColor(red:0.19, green:0.68, blue:0.14, alpha:1.0))
        //let t32 = Tone(length: 300, frequency: 741, color: UIColor(red:0.02, green:0.42, blue:0.99, alpha:1.0))
        //let t33 = Tone(length: 300, frequency: 852, color: UIColor(red:0.47, green:0.36, blue:0.71, alpha:1.0))
       // let t34 = Tone(length: 300, frequency: 963, color: UIColor(red:0.51, green:0.29, blue:0.49, alpha:1.0))
    //    let t35 = Tone(length: 300, frequency: 174, color: UIColor(red:0.36, green:0.35, blue:0.35, alpha:1.0))
     //   let t36 = Tone(length: 300, frequency: 285, color: UIColor(red:0.95, green:0.04, blue:0.59, alpha:1.0))
      //  let t37 = Tone(length: 300, frequency: 396, color: UIColor(red:0.56, green:0.00, blue:0.00, alpha:1.0))
       // let t38 = Tone(length: 300, frequency: 417, color: UIColor(red:1.00, green:0.71, blue:0.44, alpha:1.0))
      //  let t39 = Tone(length: 300, frequency: 528, color: UIColor(red:0.98, green:0.78, blue:0.01, alpha:1.0))
     //   let t40 = Tone(length: 300, frequency: 639, color: UIColor(red:0.19, green:0.68, blue:0.14, alpha:1.0))
     //   let t41 = Tone(length: 300, frequency: 741, color: UIColor(red:0.02, green:0.42, blue:0.99, alpha:1.0))
   //     let t42 = Tone(length: 300, frequency: 852, color: UIColor(red:0.47, green:0.36, blue:0.71, alpha:1.0))
  //      let t43 = Tone(length: 300, frequency: 963, color: UIColor(red:0.51, green:0.29, blue:0.49, alpha:1.0))
   //     let t44 = Tone(length: 1800, frequency: 726, color: UIColor(red:0.18, green:0.53, blue:0.85, alpha:1.0))
     //   let t45 = Tone(length: 1800, frequency: 528, color: UIColor(red:0.98, green:0.78, blue:0.01, alpha:1.0))
        
        return [t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15, t16, t17, t18,
                t19, t20, t21, t22, t23, t24, t25, t26, t27]
    }
        
    
    //===========================================================================================
    
    
    func updateDelegate(_ customTableViewController:CustomTableViewController) {
        lCustomTableViewController = customTableViewController
    }
    
    
    //===========================================================================================
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scanCoreDataForTone()
        self.tableView.reloadData()
        self.tableView.estimatedRowHeight = 130
        //self.tableView.rowHeight = UITableViewAutomaticDimension

        self.toneList = self.newSequences()
    }
        
    
    //===========================================================================================
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_color" {
            let vc: ColorViewController = segue.destination as! ColorViewController
            vc.delegate = self
        }
    }
    
    
    //===========================================================================================
    
    
    // MARK: - UI actions
    
    func addAction(_ sender: UIButton!) {
        self.performSegue(withIdentifier: "show_color", sender: self)
    }
        
    
    //===========================================================================================
    
    
    @IBAction func CancelSelectBtn(_ sender: AnyObject) {
         _ = navigationController?.popViewController(animated: true)
    }
   
    //===========================================================================================
    
    
    // MARK: - Internal methods
    
    func scanCoreDataForTone() {
        let toneEntityList: [ToneEntity] = Service.shared.customTones()
        var tones: [Tone] = []
        for te: ToneEntity in toneEntityList {
            tones.append(Tone(tone: te))
        }
        self.toneNewList = tones
    }
        
    
    //===========================================================================================
    
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
        
    
    //===========================================================================================
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.toneList.count
        case 1:
            return self.toneNewList.count
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
        let cell:Select = tableView.dequeueReusableCell(withIdentifier: "select_tone", for: indexPath) as! Select
        switch (indexPath as NSIndexPath).section {
        case 0:
            let tone = self.toneList[(indexPath as NSIndexPath).row]
            cell.hzSelect.text = String(tone.frequency)
            cell.minSelect.text = String(tone.length / 60)
            cell.secSelect.text = String(tone.length % 60)
            cell.backgroundColor = tone.color
            return cell
        case 1:
            let tone: Tone = self.toneNewList[(indexPath as NSIndexPath).row]
            cell.hzSelect.text = String(tone.frequency)
            cell.minSelect.text = String(tone.length / 60)
            cell.secSelect.text = String(tone.length % 60)
            cell.backgroundColor = tone.color
            return cell
        default:
            return UITableViewCell()
        }
    }    
    
    
    //===========================================================================================
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Default"
        case 1:
            return "Custom"
        default:
            return ""
        }
    }    
    
    
    //===========================================================================================
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       self.tableView.deselectRow(at: indexPath, animated: true)
        var selectedTone: Tone? = nil
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            selectedTone = self.toneList[(indexPath as NSIndexPath).row]
            break
        case 1:
            selectedTone = self.toneNewList[(indexPath as NSIndexPath).row]
            break
        default:
            selectedTone = nil
            break
        }
        (lCustomTableViewController?.toneSelected(selectedTone!))!
    }
        
    
    //===========================================================================================
    
    
    // Delete each tone by scroll
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let tone: Tone = self.toneNewList[(indexPath as NSIndexPath).row]
        
            Service.shared.deleteToneEntityByTone(tone)
            
            toneNewList.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
      }
    }
  
    
    //===========================================================================================
    
    
    // MARK: SelectDelegate
    
    func didReceiveTone(_ tone: Tone) {
        self.scanCoreDataForTone()
        self.tableView.reloadData()
    }
    
    
    //===========================================================================================

    // MARK: - ColorViewControllerDelegate
    
    func didCancelPressed() {
        
         _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    //===========================================================================================
    
    
       func didSavePressed(_ tone: Tone) {
        
         _ = navigationController?.popViewController(animated: true)
        _ = tone.toneEntity()
        self.scanCoreDataForTone()
        self.tableView.reloadData()
    }
    
    
    //===========================================================================================
    
}
