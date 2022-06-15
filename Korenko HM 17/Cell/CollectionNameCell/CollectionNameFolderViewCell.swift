//
//  CollectionNameFolderViewCell.swift
//  Korenko HM 17
//
//  Created by Artsiom Korenko on 1.06.22.
//

import UIKit

class CollectionNameFolderViewCell: UICollectionViewCell {

    static let key = "CollectionNameFolderViewCell"
    
    @IBOutlet weak var myLabel: UILabel!
    
    @IBOutlet weak var image: UIImageView!
  
    func setSelectedAttribute(isSelected: Bool) {
        self.layer.borderColor = .init(red: 10/255, green: 10/255, blue: 250/255, alpha: 1)
        self.layer.borderWidth = isSelected ? 5 : 0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    

}
