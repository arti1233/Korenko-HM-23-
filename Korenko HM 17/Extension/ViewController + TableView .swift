//
//  ViewController + Extension .swift
//  Korenko HM 17
//
//  Created by Artsiom Korenko on 26.05.22.
//

import Foundation
import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        catalogFile.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let key = TypeFile(rawValue: section),
              let values = catalogFile[key],
              !values.isEmpty else { return 0 }
        
        return values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let imageCell = tableView.dequeueReusableCell(withIdentifier: ForImageTableViewCell.key) as? ForImageTableViewCell else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyCellUITableViewCell.key) as? MyCellUITableViewCell else { return UITableViewCell() }
        
        guard let key = TypeFile(rawValue: indexPath.section),
              let values = catalogFile[key] else { return UITableViewCell() }
        
        switch key {
        case .folder:
            cell.setSelectedAttribute(isSelected: indexForDelet.contains { $0 == indexPath })
            cell.myLabel.text = values[indexPath.row].lastPathComponent
            cell.isSelected = true
            return cell
        case .image:
            imageCell.setSelectedAttribute(isSelected: indexForDelet.contains { $0 == indexPath })
            imageCell.myImageView.image = UIImage(contentsOfFile: values[indexPath.row].path)
            imageCell.isSelected = true
            return imageCell
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch activeDeletButton {
        case .off:
            selectionForCellTableView(indexPath: indexPath, isSelected: false)
            transitionInOtherCell(indexPath: indexPath)
        case .on where indexForDelet.contains(where: {$0 == indexPath}):
            selectionForCellTableView(indexPath: indexPath, isSelected: false)
            guard let item = indexForDelet.firstIndex(of: indexPath) else { return }
            indexForDelet.remove(at: item)
            deletFileButton.isEnabled = indexForDelet.count > 0
        case .on:
            selectionForCellTableView(indexPath: indexPath, isSelected: true)
            indexForDelet.append(indexPath)
            deletFileButton.isEnabled = indexForDelet.count > 0 
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        switch activeDeletButton {
        case .on:
            if indexForDelet.count > 0 {
                guard let item = indexForDelet.firstIndex(of: indexPath) else { return }
                indexForDelet.remove(at: item)
                deletFileButton.isEnabled = !(indexForDelet.count == 0)
            }
        default: break
        }
        selectionForCellTableView(indexPath: indexPath, isSelected: false)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let key = TypeFile(rawValue: section),
              let values = catalogFile[key],
              !values.isEmpty else { return "" }
        
        return key.description
        
    }
    
}

