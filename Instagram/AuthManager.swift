//
//  AuthManager.swift
//  Instagram
//
//  Created by user216341 on 4/26/22.
//
import FirebaseAuth

public class AuthManager{
    static let shared=AuthManager()
    var db=SQLiteDatabase()
    
    public func registerNewUser(username:String, email: String, password: String){
                    // Insert in database
        
                    do {
                      try
                        self.db.insertNewUser(username: username, email: email, password: password)
                    } catch {
                        print(self.db.errorMessage)
                    }
                    //self.db.insertNewUser(username: username, email: email, password: password)
                    
                        
                    }
    
    
    public func loginUser(username: String?, email:String?, password:String, completion: @escaping (Bool)-> Void){
        if let email = email {
//            if (self.db.readlogemail(emaill: email, passwordl: password) != true){
//                print("pizza")
//                completion(false)
//                return
//            }
//            completion(true)
//            }
            print("penus")}
        
        
        else if let username = username {
            if(self.db.readloguser(usernamel:username, passwordl: password) != true){
                print("ce imi bag pula ",self.db.readloguserwhere(usernamel:username, passwordl: password))
                print("pizza")

                completion(false)
                return
            }
        completion(true)
        }
    }
}

