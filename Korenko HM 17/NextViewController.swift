//
//  NextViewController.swift
//  Korenko HM 17
//
//  Created by Artsiom Korenko on 29.05.22.
//

import UIKit

class NextViewController: UIViewController {
    
    static let key = "NextViewController"
    @IBOutlet weak var tableView: UITableView!
    let fileManager = FileManager.default
    var catalogURL: URL!
    var contentOfDirectory: [URL] = []
    var listStringNameFolder: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = ""
        tableView.register(UINib(nibName: MyCellUITableViewCell.key, bundle: nil), forCellReuseIdentifier: MyCellUITableViewCell.key)
        
        catalogURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            contentOfDirectory = try fileManager.contentsOfDirectory(at: catalogURL, includingPropertiesForKeys: nil)
        } catch {
            print("ERROR 1")
        }
        
        print(catalogURL)
        listStringNameFolder = contentOfDirectory.map({$0.lastPathComponent}).filter({$0 != ".DS_Store"})
        
    
    }
    
    @IBAction func addButton(_ sender: Any) {
        let chooseAnActionController = UIAlertController(title: "Chosse an action", message: "", preferredStyle: .alert)
        let createDirectory = UIAlertAction(title: "Create directory", style: .default) { _ in
            let alertController = UIAlertController(title: "Create a new catalog", message: "Print a name", preferredStyle: .alert)
            alertController.addTextField { textField in
                textField.placeholder = "Name folder"
            }
            let okButton = UIAlertAction(title: "OK", style: .default){ [self] _ in
                guard let textField = alertController.textFields?[0],
                      let text = textField.text else { return }

                let textWithoutWhitespace = text.trimmingCharacters(in: .whitespaces)

                do {
                    let myCatalogURL = catalogURL.appendingPathComponent("\(textWithoutWhitespace)")
                    try fileManager.createDirectory(at: myCatalogURL, withIntermediateDirectories: false)
                    listStringNameFolder.append("\(textWithoutWhitespace)")
                    tableView.reloadData()
                } catch {
                    let errorAlertController = UIAlertController(title: "ERROR", message: "Direcory exists", preferredStyle: .alert)
                    let errorOkButton = UIAlertAction(title: "OK", style: .destructive)
                    errorAlertController.addAction(errorOkButton)
                    present(errorAlertController, animated: true)
                }
            }
            let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
            alertController.addAction(okButton)
            alertController.addAction(cancelButton)
            self.present(alertController, animated: true)
        }

        let chooseAnImageButton = UIAlertAction(title: "Choose an image", style: .default) { _ in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
        }

        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            let storyboard = UIStoryboard(name: "NextStoryboard", bundle: nil)
            if let VC = storyboard.instantiateViewController(withIdentifier: NextViewController.key) as? NextViewController{
                self.navigationController?.pushViewController(VC, animated: true)
            }

        }

        chooseAnActionController.addAction(createDirectory)
        chooseAnActionController.addAction(chooseAnImageButton)
        chooseAnActionController.addAction(cancelButton)
        present(chooseAnActionController, animated: true)
    }
    
    
    
}
