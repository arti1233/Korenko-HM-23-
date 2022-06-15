//
//  ViewController.swift
//  Korenko HM 17
//
//  Created by Artsiom Korenko on 25.05.22.
//

import UIKit


enum TypeFile: Int {
    case folder = 0
    case image
    
    var description: String {
        switch self {
        case .folder:
            return "Folder"
        case .image:
            return "Image"
        }
    }
}

enum StatusEdit {
    case off
    case on
}



class ViewController: UIViewController {
    static let key = "ViewController"
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editFileButton: UIButton!
    @IBOutlet weak var deletFileButton: UIButton!
    @IBOutlet weak var createFileButton: UIButton!
    
    let fileManager = FileManager.default
    var catalogURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    var contentOfDirectory: [URL] = []
    var nameTitle = "Catolog Browser"
    var catalogFile: [TypeFile: [URL]] = [:]
    var segment: Int = 0
    var activeDeletButton: StatusEdit = .off
    var indexForDelet: [IndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = nameTitle
        deletFileButton.isHidden = true
        deletFileButton.isEnabled = false
        
        segmentController.selectedSegmentIndex = segment
        changeSegmentControll(index: segment)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: MyCellUITableViewCell.key, bundle: nil), forCellReuseIdentifier: MyCellUITableViewCell.key)
        tableView.register(UINib(nibName: ForImageTableViewCell.key, bundle: nil), forCellReuseIdentifier: ForImageTableViewCell.key)
       
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: CollectionNameFolderViewCell.key, bundle: nil), forCellWithReuseIdentifier: CollectionNameFolderViewCell.key)
        collectionView.register(UINib(nibName: CollectionImageCell.key, bundle: nil), forCellWithReuseIdentifier: CollectionImageCell.key)
        tableView.allowsMultipleSelection = true
        collectionView.allowsMultipleSelection = true
        
        reloadContentOfDirectory()
        
        print(catalogURL)
    }
    
    //MARK: - Actions
    
    @IBAction func addButton(_ sender: Any) {
        let chooseAnActionController = UIAlertController(title: "Chosse an action", message: "", preferredStyle: .alert)
        let createDirectories = UIAlertAction(title: "Create directory", style: .default) { _ in
            let alertController = UIAlertController(title: "Create a new catalog", message: "Print a name", preferredStyle: .alert)
            alertController.addTextField { textField in
                textField.placeholder = "Name folder"
            }
            let okButton = UIAlertAction(title: "OK", style: .default){ [self] _ in
                guard let textField = alertController.textFields?[0],
                      let text = textField.text else { return }
                let textWithoutWhitespace = text.trimmingCharacters(in: .whitespaces)
                createDirectory(name: textWithoutWhitespace)
            }
            let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
            alertController.addAction(okButton)
            alertController.addAction(cancelButton)
            self.present(alertController, animated: true)
        }
        
        let chooseAnImageButton = UIAlertAction(title: "Choose an image", style: .default) { _ in
            self.imagePickerForAllerController()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
        
        chooseAnActionController.addAction(createDirectories)
        chooseAnActionController.addAction(chooseAnImageButton)
        chooseAnActionController.addAction(cancelButton)
        present(chooseAnActionController, animated: true)
    }
    
    @IBAction func didCnangeSegment(_ sender: UISegmentedControl) {
        changeSegmentControll(index: sender.selectedSegmentIndex)
    }
    
    @IBAction func editFileButton(_ sender: Any) {
        changeActiveDeletButton()
    }
    
    @IBAction func deletFileButton(_ sender: Any) {
        indexForDelet.forEach { indexPath in
            guard let key = TypeFile(rawValue: indexPath.section),
                  var values = catalogFile[key] else { return }
            
            self.deletElelementsInFileManager(atPath: values[indexPath.row].path, atURL: values[indexPath.row])
            values.remove(at: indexPath.row)
        }
        reloadContentOfDirectory()
        reloadAll()
        activeDeletButton = .on
        changeActiveDeletButton()
    }
    
    
    
    //MARK: - Методы
    
// обновление contentOfDirectory
    func reloadContentOfDirectory(){
        do {
            contentOfDirectory = try fileManager.contentsOfDirectory(at: catalogURL, includingPropertiesForKeys: nil)
        } catch {
            print("ERROR 1")
        }
        
        contentOfDirectory = contentOfDirectory.filter({$0.lastPathComponent != ".DS_Store"})
        catalogFile[.folder] = contentOfDirectory.filter({$0.hasDirectoryPath})
        catalogFile[.image] = contentOfDirectory.filter({!$0.hasDirectoryPath})
    }
    
// обновление тaблиц
    
    func reloadAll(){
        indexForDelet.removeAll()
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    
    
// метод для кнопки editFileButton
    func changeActiveDeletButton(){
        switch activeDeletButton {
        case .off:
            editFileButton.isSelected = true
            deletFileButton.isHidden = false
            createFileButton.isEnabled = false
            activeDeletButton = .on
        case .on:
            editFileButton.isSelected = false
            deletFileButton.isHidden = true
            createFileButton.isEnabled = true
            activeDeletButton = .off
        }
    }
    
// метод для создания Folder
    func createDirectory(name: String){
        do {
            let myCatalogURL = catalogURL.appendingPathComponent("\(name)")
            try fileManager.createDirectory(at: myCatalogURL, withIntermediateDirectories: false)
            catalogFile[.folder]?.append(myCatalogURL)
            contentOfDirectory.append(myCatalogURL)
            collectionView.reloadData()
            tableView.reloadData()
        } catch {
            let errorAlertController = UIAlertController(title: "ERROR", message: "Direcory exists", preferredStyle: .alert)
            let errorOkButton = UIAlertAction(title: "OK", style: .destructive)
            errorAlertController.addAction(errorOkButton)
            present(errorAlertController, animated: true)
        }
    }
    
    
//  метод из менения segmentContoller
    func changeSegmentControll(index: Int){
        segment = index
        tableView.isHidden = index == 1
        collectionView.isHidden = index == 0
        collectionView.reloadData()
        tableView.reloadData()
    }
    
// метод удаления элементов для кнопки deletFileButton
    func deletElelementsInFileManager(atPath: String, atURL: URL) {
        if fileManager.fileExists(atPath: atPath) {
            do {
                try fileManager.removeItem(at: atURL)
            } catch {
                print("Error delet")
            }
        }
    }
    
// image Picker for alertController 
    
    func imagePickerForAllerController(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true)
    }
    
// переход в зависимости от ячейки
    
    func transitionInOtherCell(indexPath: IndexPath){
        guard let key = TypeFile(rawValue: indexPath.section),
              let values = catalogFile[key] else { return }
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if key == .folder, let VC = mainStoryboard.instantiateViewController(withIdentifier: ViewController.key) as? ViewController{
            VC.nameTitle = values[indexPath.row].lastPathComponent
            VC.catalogURL = values[indexPath.row]
            VC.segment = segment
        
            self.navigationController?.pushViewController(VC, animated: true)
        }
        let imageStoryboard = UIStoryboard(name: "ImageStoryboard", bundle: nil)
        if key == .image, let arrayImagesURL = catalogFile[.image], let VC = imageStoryboard.instantiateViewController(withIdentifier: ImageViewController.key) as? ImageViewController{
            VC.arrayImagesURL = arrayImagesURL
            VC.imageFirst = values[indexPath.row]
            VC.modalTransitionStyle = .coverVertical
            self.present(VC, animated: true)
        }
    }
    
// выделение для tableView
    
    func selectionForCellTableView (indexPath: IndexPath, isSelected: Bool){
        guard let key = TypeFile(rawValue: indexPath.section) else { return }
        
        switch key {
        case .folder:
            guard let folderCell = tableView.cellForRow(at: indexPath) as? MyCellUITableViewCell else { return }
            folderCell.setSelectedAttribute(isSelected: isSelected)
            folderCell.isSelected = isSelected
        case .image:
            guard let imageCell = tableView.cellForRow(at: indexPath) as? ForImageTableViewCell else { return }
            imageCell.setSelectedAttribute(isSelected: isSelected)
            imageCell.isSelected = isSelected
        }
    }
 
// // выделение для CollectionView
    
    func selectionForCollectionView (indexPath: IndexPath, isSelected: Bool) {
        guard let key = TypeFile(rawValue: indexPath.section) else { return }
        
        switch key {
        case .folder:
            guard let folderCell = collectionView.cellForItem(at: indexPath) as? CollectionNameFolderViewCell else { return }
            folderCell.setSelectedAttribute(isSelected: isSelected)
            folderCell.isSelected = isSelected
        case .image:
            guard let imageCell = collectionView.cellForItem(at: indexPath) as? CollectionImageCell else { return }
            imageCell.setSelectedAttribute(isSelected: isSelected)
            imageCell.isSelected = isSelected
        }
    }
    
}







