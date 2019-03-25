//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Sangho Oh on 25/03/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var nameField: detailTextField!
    @IBOutlet weak var serialNumberField: detailTextField!
    @IBOutlet weak var valueField: detailTextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    var imageStore: ImageStore!
    
    private let numberFormatter: NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        serialNumberField.delegate = self
        valueField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        valueField.text = numberFormatter.string(from: item!.valueInDollars as NSNumber)
        dateLabel.text = dateFormatter.string(from: item!.dateCreated as Date)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        // 뷰를 빠져나올 때, 변경 사항을 Item에 저장...
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text
        
        if let valueText = valueField.text, let value = numberFormatter.number(from: valueText) {
            item.valueInDollars = value.intValue
        } else {
            item.valueInDollars = 0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDate" {
            let datePickerViewController = segue.destination as! DatePickerViewController
            datePickerViewController.item = item
        }
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        
        // 기기에 카메라가 있으면, 카메라. 없으면, 사진 라이브러리 오픈.
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
}

// MARK: - UITextFieldDelegate
extension DetailViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


// MARK: - UIImagePickerControllerDelegate
extension DetailViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // 딕셔너리에서 선택된 이미지....
        let image = info[.originalImage] as! UIImage
        
        // 이미지를 item key(uuid)로 저장소에 set...
        imageStore.setImage(image: image, forKey: item.itemKey)
        
        self.imageView.image = image
        
        // 화면 dismiss
        dismiss(animated: true, completion: nil)
    }
}
