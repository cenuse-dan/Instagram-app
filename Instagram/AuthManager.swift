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
        db.self.canCreateNewUser(with: email, username: username){ canCreate in
            
            if canCreate{
                Auth.auth().createUser(withEmail: email, password: password)
                                           
                do{
                      try
                        self.db.insertNewUser(username: username, email: email, password: password)
                        
                    } catch {
                        print(self.db.errorMessage)
                        
                        return
                    }
                  
                    
                        
                    
        }
            else{
                return
            }
    }
        }
    
    
    
    public func loginUser(username: String?, email:String?, password:String, completion: @escaping (Bool)-> Void){
        if let email = email { //email log in
            
            Auth.auth().signIn(withEmail: email, password: password){authResult, error in
                guard authResult != nil , error == nil else{
                    completion(false)
                    return
                }
                
                completion(true)
            }
        }
        
        
        else if let username = username {
            if(self.db.readloguser(usernamel:username, passwordl: password) != true){
                self.db.read()
                

                completion(false)
                return
            }
        completion(true)
        }
    }
    /// Attempt to log out firebase user
    public func logOut(completion: (Bool)->Void){
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        }
        catch{
            
            print(error)
            completion(false)
            return
        }
    }
}









