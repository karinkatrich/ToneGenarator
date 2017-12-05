//
//  ColorViewController.swift
//  SwiftyPicker
//
//  Created by Fabian Canas on 9/14/15.
//  Copyright © 2015 Fabián Cañas. All rights reserved.
//

import UIKit
import iOS_Color_Picker

protocol ColorViewControllerDelegate: class {
    func didCancelPressed()
    func didSavePressed(_ tone: Tone)
}


/// The ColorViewController class defines a rectangular area on the screen and the interfaces for managing the content of colorPicker in that area, with custom frequency, length and color.

class ColorViewController: UIViewController, FCColorPickerViewControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var frequencyTextField: UITextField?
    @IBOutlet weak var minutesTextField: UITextField?
    @IBOutlet weak var secondsTextField: UITextField?
    
    @IBOutlet weak var colorPickerView: HRColorPickerView!
    
    var tone:Tone?
    
    weak var delegate: ColorViewControllerDelegate?
    
    var color = UIColor.blue {
        didSet {
            self.view?.backgroundColor = color
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextFields()
        
        colorPickerView.color = UIColor.blue
        colorPickerView.addTarget(self, action: #selector(ColorViewController.colorChanged(_:)), for: UIControlEvents.valueChanged)
        
        if (self.tone != nil) {
            self.setTone(self.tone!)
        }
    }
        
    
    //===========================================================================================
    
    
    func colorChanged(_ event: UIEvent) {
        print("Now color is: ", colorPickerView.color)
        view.backgroundColor = colorPickerView.color
    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pickColor(_ sender :AnyObject) {
        let colorPicker = FCColorPickerViewController()
        colorPicker.color = color
        colorPicker.delegate = self
        present(colorPicker, animated: true, completion: nil)
    }
    
    func colorPickerViewController(_ colorPicker: FCColorPickerViewController, didSelect color: UIColor) {
        self.color = color
        dismiss(animated: true, completion: nil)
    }
    
    
    //===========================================================================================
    
    
    func colorPickerViewControllerDidCancel(_ colorPicker: FCColorPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
        
    
    //===========================================================================================
    
    
    // MARK: - Public methods
    
    
    /// Allocated and initializes a Tone class based on the data in text fields on the interface.
    func editedTone() -> Tone {
        let length: Int = (Int((self.minutesTextField?.text)!)! * 60) + Int((self.secondsTextField?.text)!)!
        let tone: Tone = Tone(length: length, frequency: Int(self.frequencyTextField!.text!)!, color: self.colorPickerView.color)
        return tone
    }
    
    
    //===========================================================================================

    
    func setTone(_ tone: Tone) {
        
        self.frequencyTextField?.text = String(tone.frequency)
        self.minutesTextField?.text = String(tone.length / 60)
        self.secondsTextField?.text = String(tone.length % 60)
        self.colorPickerView.color = tone.color
        
    }
    
    
    //===========================================================================================

    
    // MARK: - UI actions
    
    @IBAction func CancelBtn(_ sender: AnyObject) {
        
        self.delegate?.didCancelPressed()
        
    }
    
    
    //===========================================================================================
    
    
    @IBAction func saveButtonPressed(_ sender: AnyObject) {
        
        if (frequencyTextField!.text!.isEmpty || minutesTextField!.text!.isEmpty || secondsTextField!.text!.isEmpty) {
        
            let alertController: UIAlertController = UIAlertController(title: "Info", message: "Fill all fields.", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil)
            
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)

        } else if  (frequencyTextField!.text == "0" || minutesTextField!.text == "0"  || secondsTextField!.text == "0") {
                
                let alertController: UIAlertController = UIAlertController(title: "Info", message: "The input can`t be zero", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil)
                
                alertController.addAction(okAction)
                
                present(alertController, animated: true, completion: nil)
            
        } else {
            
            self.delegate?.didSavePressed(self.editedTone())
            
        }

    }

    
    //===========================================================================================
    
    // MARK: UITextFieldDelegate
    
    func initializeTextFields()
    {
        frequencyTextField!.delegate = self
        frequencyTextField!.keyboardType = .numberPad
        minutesTextField!.delegate = self
        minutesTextField!.keyboardType = .numberPad
        secondsTextField!.delegate = self
        secondsTextField!.keyboardType = .numberPad
    }
        
    
    //===========================================================================================
    
    
     internal func textField(_ frequencytextField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) ->  Bool  {
        let invalidCharacters = CharacterSet.decimalDigits.inverted
        
        let range = string.rangeOfCharacter(from: invalidCharacters)
        
        if (range == nil) {
            return true
        }
        else {
            return (range?.isEmpty)!
        }
    }
        
    
}


