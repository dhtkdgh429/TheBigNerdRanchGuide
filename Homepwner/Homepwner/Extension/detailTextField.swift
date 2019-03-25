//
//  detailTextField.swift
//  Homepwner
//
//  Created by Sangho Oh on 25/03/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit

class detailTextField: UITextField {
    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        
        self.borderStyle = .line
        return false
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        
        self.borderStyle = .roundedRect
        return true
    }
}
