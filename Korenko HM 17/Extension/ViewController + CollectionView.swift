//
//  ViewController + CollectionView.swift
//  Korenko HM 17
//
//  Created by Artsiom Korenko on 3.06.22.
//

import Foundation
import UIKit

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        catalogFile.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let key = TypeFile(rawValue: section),
              let values = catalogFile[key],
              !values.isEmpty else { return 0 }
        
        return values.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionImageCell.key, for: indexPath) as? CollectionImageCell else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionNameFolderViewCell.key, for: indexPath) as? CollectionNameFolderViewCell else { return UICollectionViewCell() }
        
        guard let key = TypeFile(rawValue: indexPath.section),
              let values = catalogFile[key] else { return UICollectionViewCell() }
        
        switch key {
        case .folder:
            cell.setSelectedAttribute(isSelected: indexForDelet.contains { $0 == indexPath })
            cell.myLabel.text = values[indexPath.row].lastPathComponent
            cell.layer.cornerRadius = 10
            cell.isSelected = true
            return cell
        case .image:
            imageCell.setSelectedAttribute(isSelected: indexForDelet.contains { $0 == indexPath })
            imageCell.myImageView.image = UIImage(contentsOfFile: values[indexPath.row].path)
            imageCell.layer.cornerRadius = 10 
            imageCell.isSelected = true
            return imageCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch activeDeletButton {
        case .off:
            selectionForCollectionView(indexPath: indexPath, isSelected: false)
            transitionInOtherCell(indexPath: indexPath)
        case .on where indexForDelet.contains(where: {$0 == indexPath}):
            selectionForCollectionView(indexPath: indexPath, isSelected: false)
            guard let item = indexForDelet.firstIndex(of: indexPath) else { return }
            indexForDelet.remove(at: item)
            deletFileButton.isEnabled = indexForDelet.count > 0
        case .on:
            selectionForCollectionView(indexPath: indexPath, isSelected: true)
            indexForDelet.append(indexPath)
            deletFileButton.isEnabled = indexForDelet.count > 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch activeDeletButton {
        case .on:
            if indexForDelet.count > 0 {
                guard let item = indexForDelet.firstIndex(of: indexPath) else { return }
                indexForDelet.remove(at: item)
            }
        default: break
        }
        selectionForCollectionView(indexPath: indexPath, isSelected: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
