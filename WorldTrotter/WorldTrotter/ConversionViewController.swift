//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Oh Sangho on 16/03/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController {
    
    @IBOutlet private var celsiusLabel: UILabel!
    @IBOutlet private var textField: UITextField!
    @IBOutlet internal var conversionView: UIView!
    
    // 숫자 포맷..
    private let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        // 소숫점 최소 0, 최대 1개까지 보여줌..
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    private var fahrenheitValue: Double? {
        didSet {
            updateCelsiusLabel()
        }
    }
    
    private var celsiusValue: Double? {
        if let value = fahrenheitValue {
            return (value - 32) * (5/9)
        } else {
            return nil
        }
    }
    
    
    override func viewDidLoad() {
        celsiusLabel.text = "???"
        print("Conversion View did load!!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDarkMode()
    }
    
    private func setDarkMode() {
        // 현재 시간 구하기.
        let cal = Calendar.current
        let date = Date()
        let now = cal.component(.hour, from: date)
        print("now : \(now)")
        
        let defaultPercent = CGFloat(0.400 / 24)
        let colorResult = (defaultPercent + 0.2) * CGFloat(now)
        print("color data : \(colorResult)")
        
        conversionView.backgroundColor = UIColor.init(red: colorResult, green: colorResult, blue: colorResult, alpha: 1.0)
        
    }
    
    private func updateCelsiusLabel() {
        if let value = celsiusValue {
            celsiusLabel.text = numberFormatter.string(for: value)
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    @IBAction func fahrenheitFieldEditingChanged(textField: UITextField) {
        if let text = textField.text, let value = Double(text) {
            fahrenheitValue = value
        } else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        textField.resignFirstResponder()
    }
}

extension ConversionViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 소수점(.) 2개 이상 입력 시 false
        let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSeparator = string.range(of: ".")
        
        if existingTextHasDecimalSeparator != nil && replacementTextHasDecimalSeparator != nil {
            return false
        }
        
        // 문자 허용하지 않기..
        let letterSet = CharacterSet.letters
        for uni in string.unicodeScalars {
            if letterSet.contains(uni) {
                return false
            }
        }
        return true
    }
}
