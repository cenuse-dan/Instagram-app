//
//  EditProfileViewController.swift
//  Instagram
//
//  Created by user216341 on 4/21/22.
//

import UIKit
import FirebaseStorage

struct EditProfileFormModel{
    let label: String
    let placeholder: String
    var value: String?
}

final class EditProfileViewController: UIViewController, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    let storage = Storage.storage().reference()

  
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FormTableViewCell.self,
                           forCellReuseIdentifier: FormTableViewCell.identifier)
        
        return tableView
    }()
    
    
    private var models = [[EditProfileFormModel]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        tableView.tableHeaderView = createTableHeaderView()
        view.addSubview(tableView)
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done,
                                                            target: self ,
                                                            action: #selector(didTapSave))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .plain,
                                                            target: self ,
                                                            action: #selector(didTapCancel))
     
        
    }
    private let SaveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    
    private let CancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
   
    private func configureModels(){
        //name, username, website, bio
        let section1Labels = ["Name","Username","Bio"]
        var section1 = [EditProfileFormModel]()
        for label in section1Labels {
            let model = EditProfileFormModel(label: label,
                                             placeholder:"Enter \(label)...",
                                             value: nil)
            section1.append(model)
            
        }
        models.append(section1)
        
        //email, phone, gender
        let section2Labels = ["Email","Gender"]
        var section2 = [EditProfileFormModel]()
        for label in section2Labels {            let model = EditProfileFormModel(label: label,
                                             placeholder:"Enter \(label)...",
                                             value: nil)
            section2.append(model)
            
        }
        models.append(section2)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame=view.bounds
    }
        // Mark: - Tableview
        
    private func createTableHeaderView() -> UIView {
        
        let header = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: view.width,
                                          height: view.height/4).integral)
        let size = header.height/1.5
        let profilePhotoButton = UIButton(frame: CGRect(x: (view.width-size)/2, y: (header.height-size)/2, width: size, height: size))
        header.addSubview(profilePhotoButton)
        profilePhotoButton.layer.masksToBounds = true
        profilePhotoButton.layer.cornerRadius = size/2.0
        profilePhotoButton.tintColor = .label
        profilePhotoButton.addTarget(self, action: #selector(didTapChangeProfilePicture), for: .touchUpInside)
        profilePhotoButton.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
        profilePhotoButton.layer.borderWidth = 1
        profilePhotoButton.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        SaveButton.frame = CGRect (x: header.width-size/2, y: (header.height-size)/2, width: size/2, height: size/4)
        CancelButton.frame = CGRect (x: 0, y: (header.height-size)/2, width: size/2, height: size/4)
        
        return header
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 1 else {
            return nil
        }
        return "Private Information"
    }
        @objc private func didTapProfileButton(){
        
        }
    
    
        func numberOfSections(in tableView: UITableView) -> Int {
            return models.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return models[section].count
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FormTableViewCell.identifier,
                                                 for: indexPath) as! FormTableViewCell
        cell.configure(with: model)
        cell.delegate = self
        
        return cell
    }
    
    
    
        //Mark: - Action
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ProfileViewController().viewDidLoad()
    }
    @objc private func didTapSave(){
        //save info to database
        dismiss(animated: true,completion: nil)
        let vc = ProfileViewController()
        present(vc, animated: false)
       // print("si asta e save")
        ProfileViewController().viewDidLoad()
        ProfileViewController().viewDidAppear(true)
        ProfileViewController().viewDidDisappear(true)
        self.viewDidDisappear(true)
        
    }
    @objc private func didTapCancel(){
        dismiss(animated: true,
                completion: nil)
            
        
    }
    
    @objc public func didTapChangeProfilePicture()  {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "Change Profile Picture", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Choose from Gallery", style: .default, handler: {_ in
            let picker2 = UIImagePickerController()
            picker2.sourceType = .photoLibrary
            picker2.delegate = self
            picker2.allowsEditing = true
            self.present(picker2,animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        actionSheet.popoverPresentationController?.sourceView = view
        actionSheet.popoverPresentationController?.sourceRect = view.bounds
        present(actionSheet, animated: true)
        //SQLiteDatabase().updatePhoto(url: "https://elasq.com/wp-content/uploads/2021/09/car-18.png")
    }
    func imagePickerController(_ picker2: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker2.dismiss(animated: true,completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        guard let imageData = image.pngData() else {
            return
        }
        let ref = storage.child("profileimages/photo.png")
        ref.putData(imageData, metadata: nil, completion: {_,error in
            guard  error == nil else {
                print("Failed to upload ")
                print(error)
                return
            }
            ref.downloadURL(completion: {url, error in
                guard let url = url, error == nil else {
                    print(error)
                    return
                }
                let urlString = url.absoluteString
                DispatchQueue.main.async {
                    //self.nameLabel.text = urlString
                  
                    SQLiteDatabase().updatePhoto(url: urlString)
                }
                
                //print("Download URL: \(urlString)")
                UserDefaults.standard.set(urlString, forKey: "url")
            })
        })
    
    }
    func imagePickerControllerDidCancel(_ picker2: UIImagePickerController){
        picker2.dismiss(animated: true,completion: nil)
    }

}


extension EditProfileViewController: FormTableViewCellDelegate {
    func formTableViewCell(cell: FormTableViewCell, didUpdateField updatedModel: EditProfileFormModel) {
        // Update the model
    
        if (updatedModel.label == "Name"){
            SQLiteDatabase().updateName(name:updatedModel.value!)
            print(SQLiteDatabase().returnpass())
        }
        if (updatedModel.label == "Bio"){
            SQLiteDatabase().updateBio(bio:updatedModel.value!)
        }
        if(updatedModel.label == "Email"){
            SQLiteDatabase().updateEmail(newEmail: updatedModel.value!)
            AuthManager.shared.changeEmail(emailc: updatedModel.value!)
        }
        if (updatedModel.label == "Gender"){
            SQLiteDatabase().updateGender(gender:updatedModel.value!)
            
        }
            
    }
    
}


