//
//  NextViewController + ImagePicker + extension .swift
//  Korenko HM 17
//
//  Created by Artsiom Korenko on 29.05.22.
//

import Foundation
import UIKit

extension NextViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageURL = info[.imageURL] as? URL,
           let image = info[.originalImage] as? UIImage,
           let editedImage = info[.editedImage] as? UIImage {
            
            let newImageURL = catalogURL.appendingPathComponent(imageURL.lastPathComponent)
            let imageJpegData = editedImage.jpegData(compressionQuality: 1)
            
            do {
                try imageJpegData?.write(to: newImageURL)
                contentOfDirectory.append(newImageURL)
                tableView.reloadData()
            } catch {
                print("Errror")
            }
            dismiss(animated: true)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel")
        dismiss(animated: true)
    }
}
