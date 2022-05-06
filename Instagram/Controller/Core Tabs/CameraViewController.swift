//
//  CameraViewController.swift
//  Instagram
//
//  Created by user216341 on 4/21/22.
//

import UIKit
import AVFoundation
import FirebaseStorage

class CameraViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let storage = Storage.storage().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = "Upload a photo"
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.addSubview(photoImageView)
        view.addSubview(nameLabel)
        view.addSubview(uploadButton)
        view.addSubview(photoImageView2)

        guard let urlString = UserDefaults.standard.value(forKey: "url" ) as? String,
        let url = URL(string: urlString) else {
            return
        }
        //
        //nameLabel.text = urlString
        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
               // self.photoImageView.image = image
            }
           
        })
        task.resume()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        photoImageView.frame = CGRect(x: 0, y: (view.height/8)+20, width: view.width, height: view.width)
//photoImageView2.frame = CGRect(x: view.width/4, y: nameLabel.bottom, width: 200, height: 200)
       // print(view.width)
        nameLabel.frame = CGRect(x: 0, y: 0, width: view.width, height: 200)
        uploadButton.frame = CGRect (x: (view.width/8)*3, y: photoImageView.bottom+50, width: 100, height: 50)
        uploadButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        ///// ASTA !!!!!!!!!!!!!!!!!!!!!!
     
        
        
        
    }
    public var photoImageView: UIImageView = {
  
        var imageView = UIImageView()
        imageView.image = UIImage(named: "test")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    public var photoImageView2: UIImageView = {
  
        var imageView = UIImageView()
        imageView.image = UIImage(named: "test")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let uploadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Upload", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
       
        return button
    }()
    public let nameLabel: UILabel = {
       // let user = SQLiteDatabase().readtest()
        var label = UILabel()
        //label.text = user.name // De aici ea el numele orice ar fi
        //label.text = "pizza"
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
   @objc private func didTapButton() {
        print("BUTTON")
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker,animated: true)
       //self.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true,completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        guard let imageData = image.pngData() else {
            return
        }
        let ref = storage.child("images/photo.png")
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
                    self.photoImageView.image = image
                    SQLiteDatabase().insertphoto(url: urlString)
                }
                
                //print("Download URL: \(urlString)")
                UserDefaults.standard.set(urlString, forKey: "url")
            })
        })
    
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true,completion: nil)
    }

}
