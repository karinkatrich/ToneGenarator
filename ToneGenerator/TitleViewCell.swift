//
//  TitleViewCell.swift
//  Quantum Frequency
//
//  Created by Karina on 25.07.16.
//  Copyright © 2016 Karina. All rights reserved.
//

import UIKit

protocol TitleDelegate : class {
    func didRecieveTitle(_ title: String)
    func titleDidUpdate(_ title: String)}


class TitleViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var customEnter : UITextField!
    weak var delegate: TitleDelegate?
    
    override func awakeFromNib() {
        customEnter.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged )
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(self.delegate != nil) {
            self.delegate?.didRecieveTitle(textField.text!)
        }
    }
    
    func textFieldDidChange()  {
        if(self.delegate != nil) {
            self.delegate?.titleDidUpdate(customEnter.text!)
        }
    }
}
