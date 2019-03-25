//
//  ViewController.swift
//  Homepwner
//
//  Created by Oh Sangho on 24/03/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var itemStore: ItemStore!
    var imageStore: ImageStore!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultIdentifier")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
    }
    
    // UIViewController에 TableView 붙여서 하는 경우, editing 오버라이딩해서..
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItem" {
            // tableview의 선택된 셀...
            if let row = tableView.indexPathForSelectedRow?.row {
                // 선택된 셀의 item을 detailView의 item에 전달...
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
                detailViewController.imageStore = imageStore
            }
        }
    }
    
    @IBAction func addNewItem(sender: AnyObject) {
        
        // itemStore에서 직접 아이템 추가함으로써 데이터 업데이트.
        let newItem = itemStore.createItem()
        
        if let index = itemStore.allItems.firstIndex(of: newItem) {
            let indexPath = NSIndexPath(row: index, section: 0) as IndexPath
            
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
}

extension ItemsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return itemStore.allItems.count
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let identifier = "ItemCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ItemCell
            
            let item = itemStore.allItems[indexPath.row]
            
            cell.updateLabels()
            
            cell.nameLabel.text = item.name
            cell.serialNumberLabel.text = item.serialNumber
            cell.valueLabel.text = "$\(item.valueInDollars)"
            
            return cell
        } else {
            let identifier = "defaultIdentifier"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel?.text = "No more items!"
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == indexPath.count-1 {
            return .none
        }
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 삭제 요청...
        if editingStyle == .delete {
            
            let item = itemStore.allItems[indexPath.row]
            
            // aleart(action sheet) 추가....
            let title = "Delete \(item.name)?"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title,
                                       message: message,
                                       preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                
                // itemStore에서 item 데이터 삭제..
                self.itemStore.removeItem(item: item)
                
                // imageStore에서 해당 이미지 캐시 삭제...
                self.imageStore.deleteImageForKey(key: item.itemKey)
                
                // 애니메이션과 함께 테이블 뷰에서 삭제..
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            ac.addAction(deleteAction)
            
            // action sheet 표시...
            present(ac, animated: true, completion: nil)
        }
    }
    
    // move 여부...
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == indexPath.count-1 {
            return false
        } else {
            return true
        }
    }
    
    // 셀 재정렬 제한.......
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        // 마지막 섹션의 셀로 이동하는 경우, 원래 위치로 되돌아 오도록....
        if proposedDestinationIndexPath.section == proposedDestinationIndexPath.count-1 {
            return sourceIndexPath
        } else {
            return proposedDestinationIndexPath
        }
    }
    
    // move method...
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        itemStore.moveItemAtIndex(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    // delete 버튼 변경..
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
}

