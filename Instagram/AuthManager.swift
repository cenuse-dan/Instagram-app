//
//  AuthManager.swift
//  Instagram
//
//  Created by user216341 on 4/26/22.
//
import FirebaseAuth
import AVFoundation

public class AuthManager{
    static let shared=AuthManager()
    var db=SQLiteDatabase()
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
            //self.db.readloguserwhere(usernamel: username, passwordl: password)
            if(self.db.readloguser(usernamel:username, passwordl: password) != true){
               
                

                completion(false)
                return
            }
        completion(true)
            
            let mail = self.db.returnEmail(username: username)
            print(Auth.auth().signIn(withEmail: mail, password: password))
         
        }
    }
    
    public func registerNewUser(username:String, email: String, password: String){
                    // Insert in database
        db.self.printAllUsers()
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
    
   
    public func curruser () ->String {
        if (Auth.auth().currentUser == nil){
            print("USERNAME",LoginViewController().usernameEmailField.text!)
            let mail = self.db.returnEmail(username: LoginViewController.shared.usernameEmailField.text!)
            Auth.auth().signIn(withEmail: mail, password: LoginViewController.shared.passwrodField.text!) {arg, error in
                if let error = error {
                    print ("nu vrea frate")
                }
            }
           // return (Auth.auth().currentUser?.email)!
        }
        else{
            return (Auth.auth().currentUser?.email)!
        }
         return ""
         
    }
    
    public func changeEmail(emailc: String) {
        let pass = SQLiteDatabase().returnpass()
        let email = Auth.auth().currentUser?.email
        print(pass,email!)
        Auth.auth().signIn(withEmail: email!, password: pass)
        
        Auth.auth().currentUser?.updateEmail(to: emailc) { error in
                //  var er = "erorr"
                  if let error = error{
                      //print(error)
                      if (error.localizedDescription == "This operation is sensitive and requires recent authentication. Log in again before retrying this request."){
                           print("Trebuie relogare")
                       




                  }
                      else{
                          print(error.localizedDescription)
                       
                      }

                  }


                  else{
                      print("a mers")
              
                  }
                
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









