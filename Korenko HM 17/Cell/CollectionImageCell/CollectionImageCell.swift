//
//  CollectionImageCell.swift
//  Korenko HM 17
//
//  Created by Artsiom Korenko on 1.06.22.
//

import UIKit

class CollectionImageCell: UICollectionViewCell {

    static let key = "CollectionImageCell"
    
    @IBOutlet weak var myImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
         
    }
   
    
    func setSelectedAttribute(isSelected: Bool) {
        self.layer.borderColor = .init(red: 10/255, green: 10/255, blue: 255/255, alpha: 1)
        self.layer.borderWidth = isSelected ? 5 : 0
    }
}
