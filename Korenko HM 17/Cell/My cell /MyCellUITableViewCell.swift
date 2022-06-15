//
//  MyCellUITableViewCell.swift
//  Korenko HM 17
//
//  Created by Artsiom Korenko on 25.05.22.
//

import UIKit
import SnapKit



class MyCellUITableViewCell: UITableViewCell {

    static var key = "MyCellUITableViewCell"
   
    @IBOutlet weak var okImageView: UIImageView!
    var myLabel: UILabel! {
        didSet {
            myLabel.textColor = .white
        }
    }

    var myImage: UIImageView! {
        didSet {
            myImage.image = UIImage(systemName: "folder")
            myImage.tintColor = .white
        }
    }
    
    func setSelectedAttribute(isSelected: Bool) {
        self.okImageView.isHidden = !isSelected 
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        okImageView.isHidden = true
        
        myImage = UIImageView()
        contentView.addSubview(myImage)
        myImage.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(16)
        }
        myLabel = UILabel()
        myLabel.numberOfLines = 0
        contentView.addSubview(myLabel)
        myLabel.snp.makeConstraints {
            $0.bottom.top.trailing.equalToSuperview().inset(16)
            $0.leading.equalTo(myImage.snp.trailing).offset(16)
        }
    }
}
