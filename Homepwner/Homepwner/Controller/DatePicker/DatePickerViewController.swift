//
//  DatePickerViewController.swift
//  Homepwner
//
//  Created by Sangho Oh on 25/03/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit

class DatePickerViewController : UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var item: Item?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        item?.dateCreated = datePicker.date
    }
}
