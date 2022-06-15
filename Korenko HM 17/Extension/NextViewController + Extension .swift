//
//  NextViewController + Extension .swift
//  Korenko HM 17
//
//  Created by Artsiom Korenko on 29.05.22.
//

import Foundation
import UIKit

extension NextViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listStringNameFolder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MyCellUITableViewCell.key) as? MyCellUITableViewCell {
            cell.myLabel.text = listStringNameFolder[indexPath.row].description
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "NextStoryboard", bundle: nil)
        if let VC = storyboard.instantiateViewController(withIdentifier: NextViewController.key) as? NextViewController{
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
}
