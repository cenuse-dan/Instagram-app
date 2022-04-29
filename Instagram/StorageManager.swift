//
//  Storage.swift
//  Instagram
//
//  Created by user216341 on 4/26/22.
//

import FirebaseStorage

public class StorageManager{
    static let shared=StorageManager()
    
    private let bucket = Storage.storage().reference()
    
    public enum  IGStorageManagerError: Error {
        case failedToDownload
    }
    
    public func uploadUserPhotoPost(model: UserPost, completion: @escaping (Result<URL, Error>) -> Void){
        
    }
    
    
    public func downloadImage(with reference: String, completion: @escaping (Result<URL, Error>)  -> Void) {
        bucket.child(reference).downloadURL(completion: { url, error in
            guard let url = url, error == nil else{
                completion(.failure(IGStorageManagerError.failedToDownload))
                return
            }
            completion(.success(url))
        })
    }
}




