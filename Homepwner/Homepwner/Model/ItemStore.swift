//
//  ItemStore.swift
//  Homepwner
//
//  Created by Oh Sangho on 24/03/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit

class ItemStore {
    var allItems = [Item]()
    
    // File URL Setting...
    let itemArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("items.archive")
    }()
    
    init() {
        if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemArchiveURL.path) as? [Item] {
            allItems = archivedItems
        }
    }
    
    func saveChanges() -> Bool {
        print("Saving items to: \(itemArchiveURL.path)")
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path)
    }
    
    public func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    
    public func removeItem(item: Item) {
        if let index = allItems.firstIndex(of: item) {
            allItems.remove(at: index)
        }
    }
    
    public func moveItemAtIndex(fromIndex: Int, toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        // 다시 삽입할 수 있도록 임시로 이동할 객체의 레퍼런스를 저장..
        let movedItem = allItems[fromIndex]
        
        allItems.remove(at: fromIndex)
        allItems.insert(movedItem, at: toIndex)
    }
}
