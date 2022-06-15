//
//  ForImageTableViewCell.swift
//  Korenko HM 17
//
//  Created by Artsiom Korenko on 29.05.22.
//

import UIKit
import SnapKit

class ForImageTableViewCell: UITableViewCell {

    static let key = "ForImageTableViewCell"
    
    @IBOutlet weak var okImageView: UIImageView!
    var myImageView: UIImageView! {
        didSet {
            myImageView.contentMode = .scaleToFill
        }
    }
    
    func setSelectedAttribute(isSelected: Bool) {
        self.okImageView.isHidden = !isSelected
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        myImageView = UIImageView()
        contentView.addSubview(myImageView)
        okImageView.isHidden = true
        
        myImageView.snp.makeConstraints {
            $0.top.bottom.centerWithinMargins.equalToSuperview().inset(0)
            $0.height.width.equalTo(70)
        }
    }
}
