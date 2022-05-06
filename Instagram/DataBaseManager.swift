//
//  DataBaseManager.swift
//  Instagram
//
//  Created by user216341 on 4/26/22.
//

import SQLite3
import Foundation
import SQLite




enum SQLiteError: Error {
  case OpenDatabase(message: String)
  case Prepare(message: String)
  case Step(message: String)
  case Bind(message: String)
}

class SQLiteDatabase {
   // static let shared = SQLiteDatabase()
   
    var db : OpaquePointer?
    
       var path : String = "instaDataBase.sqlite"
       init() {
           self.db = createDB()
           //self.createTable()
           
             


    }
    
    public var errorMessage: String {
      if let errorPointer = sqlite3_errmsg(db) {
        let errorMessage = String(cString: errorPointer)
        return errorMessage
      } else {
        return "No error message provided from sqlite."
      }
    }

       func createDB() -> OpaquePointer? {
           //let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(path)
           
           var db : OpaquePointer? = nil
           
           //if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            if sqlite3_open("/Users/user216341/Desktop/Baza de date/instaDataBase.sqlite", &db) != SQLITE_OK {
               print("There is error in creating DB")
               return nil
           }else {
               //print("Database has been created with path ")
               return db
           }
       }
    
    func createTable()  {
          let query = "CREATE TABLE IF NOT EXISTS testusers(id INTEGER PRIMARY KEY AUTOINCREMENT,username TEXT, email TEXT, password TEXT);"
          var statement : OpaquePointer? = nil
          
          if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
              if sqlite3_step(statement) == SQLITE_DONE {
                  //print("Table creation success")
              }else {
                  print("Table creation fail")
              } 
          } else {
              print("Prepration fail")
          }
      }
    func returnpass() ->String {
        let email = AuthManager.shared.curruser()
        let query = "SELECT * FROM UsersInsta WHERE email= '" + email + "' ;"
        var statement : OpaquePointer?
        var pass = "fgdfg"
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW {
                pass = String(describing: String(cString: sqlite3_column_text(statement, 8)))
            }
        }
      else{
          print("Prepration fail")
      }
        return pass
    }
    func returnId() ->Int {
        let email = AuthManager.shared.curruser()
        let query = "SELECT * FROM UsersInsta WHERE email= '" + email + "' ;"
        var statement : OpaquePointer?
        var id = 4
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW {
                id = Int(sqlite3_column_int(statement, 0))
            }
        }
      else{
          print("Prepration fail")
      }
        return id
    }

    /// Check if username and email are available
    /// - Paramters
    ///     -email: String used for email
    ///     -username: String used for username
    public func canCreateNewUser(with email: String, username: String, completion: (Bool)-> Void){
        var queryStatement :OpaquePointer? = nil
        let query = "select count(*) from UsersInsta where email = '" + email + "' and username = '" + username + "';"
        
        if sqlite3_prepare(self.db, query, -1, &queryStatement, nil) == SQLITE_OK{
              while(sqlite3_step(queryStatement) == SQLITE_ROW){
                   let count = sqlite3_column_int(queryStatement, 0)
                  // print("\(count)")
                  if count > 0 {
                      completion(false)
                  }
                  else{
                      completion(true)
                  }
              }

        }
     
     
    }
    func postcount() {
        var queryStatement :OpaquePointer? = nil
        let query = "select count(*) from Userpost;"
        
        if sqlite3_prepare(self.db, query, -1, &queryStatement, nil) == SQLITE_OK{
              while(sqlite3_step(queryStatement) == SQLITE_ROW){
                   let count = sqlite3_column_int(queryStatement, 0)
                   print("\(count)")
                 
              }

        }
        else{
            print("Prepration fail")
            print(errorMessage)
        }
    }
    func countuser() {
        var queryStatement :OpaquePointer? = nil
        let email = AuthManager.shared.curruser()
        let query = "select id from UsersInsta where email = '" + email + "';"
        
        if sqlite3_prepare(self.db, query, -1, &queryStatement, nil) == SQLITE_OK{
              while(sqlite3_step(queryStatement) == SQLITE_ROW){
                   let count = sqlite3_column_int(queryStatement, 0)
                   print("\(count)")
                 
              }

        }
        else{
            print("Prepration fail")
            print(errorMessage)
        }
    }
    public func returnEmail(username: String) ->String {
     
        let query = "SELECT * FROM UsersInsta WHERE username = '" + username + "' ;"
        var statement : OpaquePointer?
        var email = ""
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW {
                email = String(describing: String(cString: sqlite3_column_text(statement, 7)))
            }
        }
      else{
          print("Prepration fail")
      }
        print(email)
        return email
    }
    
    public func insertNewUser (username: String, email: String, password: String) throws{
        let query = "INSERT INTO UsersInsta (username,email,password) VALUES (?, ?, ?)"
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
   
            sqlite3_bind_text(statement, 1, (username as NSString).utf8String, -1,nil)
            sqlite3_bind_text(statement, 2, (email as NSString).utf8String, -1,nil)
            sqlite3_bind_text(statement, 3, (password as NSString).utf8String, -1,nil)
        
            guard sqlite3_step(statement) == SQLITE_DONE else {
              throw SQLiteError.Step(message: errorMessage)
            }
            print("Successfully inserted row.")
        
            
        }
        else {
           print("Query is not as per requirement")
        }
    }
    func printAllUsers()
    {
          let query = "SELECT * FROM UsersInsta"
          var statement : OpaquePointer?
          if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
              while sqlite3_step(statement) == SQLITE_ROW {
                  var username = "NULL"
                  let id = Int(sqlite3_column_int(statement, 0))
                  if (sqlite3_column_text(statement, 1) != nil){
                  username = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                  }
                  let email = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                  let password = String(describing: String(cString: sqlite3_column_text(statement, 3)))

                //print("\n",id,username,email,password,"\n")
              }
          }


      }
    
    func returnUserPosts() ->[UserPost]{
        let email = AuthManager.shared.curruser()
        //print(email)
  
        let query = "SELECT * from Userpost where iduser  = (select id from UsersInsta where email = '" + email + "');"
        var userPosts = [UserPost]()
        let user = self.returnTheCurrentUser()
       // print(user)
        var statement : OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let type = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                let iduser = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                let photo = String(describing: String(cString: sqlite3_column_text(statement, 3)))
                let thumbnail = String(describing: String(cString: sqlite3_column_text(statement, 4)))
               // print (type,iduser,photo,thumbnail)
                if type == "photo"{
                    userPosts.append(UserPost(identifier: ("post \(id)"), postType: .photo, thumbnailImage: URL(string: thumbnail)!, postURL: URL(string: photo)!, caption: "nu ma intereseaza", likeCount: [], comments: [], createdDate: Date(), taggedUsers: [], owner: user))
                }
                else{
                    userPosts.append(UserPost(identifier: ("post \(id)"), postType: .video, thumbnailImage: URL(string: thumbnail)!, postURL: URL(string: photo)!, caption: "nu ma intereseaza", likeCount: [], comments: [], createdDate: Date(), taggedUsers: [], owner: user))
                }
        
            }
        }
        return userPosts
    }
    func insertphoto(url :String){
        let email = AuthManager.shared.curruser()
        let id = returnId()
        print(email,id)
        let query = "INSERT INTO Userpost (iduser, image, thumbnail) VALUES (\(id), '\(url)', '\(url)');"
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            guard sqlite3_step(statement) == SQLITE_DONE else {
              print(errorMessage)
                return
            }
            print("Successfully inserted row.")
        
            
        }
        else {
           print("Query is not as per requirement")
        }
    }
    
    func returnTheCurrentUser() ->User
    {
            //Aici pica
          let email = AuthManager.shared.curruser()
          var user = User(username: "", bio: "", name: "", birthDate: "", gender: "", profilePhoto: URL(string: "www.google.com")!)
          let query = "SELECT * FROM UsersInsta WHERE email = '" + email + "';"
          var statement : OpaquePointer?
          var bio = ""
          var name = ""
          var birthdate = ""
          var gender = ""
          var photo = ""
          if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
              while sqlite3_step(statement) == SQLITE_ROW {
                  
                  let username = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                  if sqlite3_column_text(statement, 2) != nil {
                      bio =  String(describing: String(cString: sqlite3_column_text(statement, 2)))
                      
                  }
                  if sqlite3_column_text(statement, 3) != nil {
                      name = String(describing: String(cString: sqlite3_column_text(statement, 3)))
                      
                  }
                  if sqlite3_column_text(statement, 4) != nil {
                      birthdate = String(describing: String(cString: sqlite3_column_text(statement, 4)))
                      
                  }
                  if sqlite3_column_text(statement, 5) != nil {
                      gender = String(describing: String(cString: sqlite3_column_text(statement, 5)))
                      
                  }
                  if sqlite3_column_text(statement, 6) != nil {
                      photo = String(describing: String(cString: sqlite3_column_text(statement, 6)))
                      
                  }
                  if photo == ""{
                      photo = "www.google.com"
                  }
                  let photoURL = URL(string: photo)
                  
                  user = User(username: username, bio: bio, name: name, birthDate: birthdate, gender: gender, profilePhoto: photoURL!)
               // print("\n",id,username,bio,name,birthdate,gender,photo,"\n")
             
              }
          }
        else{
            print("Prepration fail")
        }
         //print (user)
         return user
      }
    
    func updateName(name: String ){
       // let updateStatementString = "UPDATE UsersInsta set name = '" + name + "' where id = 1"
        let email = AuthManager.shared.curruser()
        let updateStatementString = "UPDATE UsersInsta set name = '" + name + "' where email = '" + email + "';"
        //print(updateStatementString)
          var updateStatement: OpaquePointer?
        
        do {
          updateStatement = try prepareStatement(sql: updateStatementString)
        }
        catch{
            print(error)
        }
        defer{
            sqlite3_finalize(updateStatement)
        }
        
        
          if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
              SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
              print("\nSuccessfully updated row.")
            } else {
              print("\nCould not update row.")
            }
          } else {
            print("\nUPDATE statement is not prepared")
          }
          
        }
    func updateBio(bio: String ){
        let email = AuthManager.shared.curruser()
        let updateStatementString = "UPDATE UsersInsta set bio = '" + bio + "' where email = '" + email + "';"
          var updateStatement: OpaquePointer?
        
        do {
          updateStatement = try prepareStatement(sql: updateStatementString)
        }
        catch{
            print(error)
        }
        defer{
            sqlite3_finalize(updateStatement)
        }
        
        
          if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
              SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
              print("\nSuccessfully updated row.")
            } else {
              print("\nCould not update row.")
            }
          } else {
            print("\nUPDATE statement is not prepared")
          }
          
        }
    
    func updateGender(gender: String ){
        let email = AuthManager.shared.curruser()
        let updateStatementString = "UPDATE UsersInsta set gender = '" + gender + "' where email = '" + email + "';"
          var updateStatement: OpaquePointer?
        
        do {
          updateStatement = try prepareStatement(sql: updateStatementString)
        }
        catch{
            print(error)
        }
        defer{
            sqlite3_finalize(updateStatement)
        }
        
        
          if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
              SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
              print("\nSuccessfully updated row.")
            } else {
              print("\nCould not update row.")
            }
          } else {
            print("\nUPDATE statement is not prepared")
          }
          
        }
    
    func updatePhoto(url: String ){
        let email = AuthManager.shared.curruser()
        let updateStatementString = "UPDATE UsersInsta set profilePhoto = '" + url + "' where email = '\(email)'"
        //print(updateStatementString)
          var updateStatement: OpaquePointer?
        
        do {
          updateStatement = try prepareStatement(sql: updateStatementString)
        }
        catch{
            print(error)
        }
        defer{
            sqlite3_finalize(updateStatement)
        }
        
        
          if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
              SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
              print("\nSuccessfully updated row.")
            } else {
              print("\nCould not update row.")
            }
          } else {
            print("\nUPDATE statement is not prepared")
          }
          //print(url)
        }
    
    func updatePass(pass: String ){
        let updateStatementString = "UPDATE UsersInsta set password = '" + pass + "' where id = 1"
        //print(updateStatementString)
          var updateStatement: OpaquePointer?
        
        do {
          updateStatement = try prepareStatement(sql: updateStatementString)
        }
        catch{
            print(error)
        }
        defer{
            sqlite3_finalize(updateStatement)
        }
        
        
          if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
              SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
              print("\nSuccessfully updated row.")
            } else {
              print("\nCould not update row.")
            }
          } else {
            print("\nUPDATE statement is not prepared")
          }
          
        }

        
    

    func readloguser (usernamel: String, passwordl:String) -> Bool{
        let query = "SELECT * FROM UsersInsta;"
        var statement : OpaquePointer?
        var test = false
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW {
                var username = "NULL"
           
                if (sqlite3_column_text(statement, 1) != nil){
                username = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                }
               
                let password = String(describing: String(cString: sqlite3_column_text(statement, 8)))

                if(username == usernamel && passwordl == password){
                    test = true
                }
            }
        }
        return test
    }
    
    func readloguserwhere (usernamel: String, passwordl:String) -> String{
        let querySql = "SELECT * FROM UsersInsta WHERE username = ? AND password = ? ;"
        var statement : OpaquePointer?
        var username = "NULL"
        print (usernamel)
        if sqlite3_prepare_v2(db, querySql, -1, &statement, nil) == SQLITE_OK{
            sqlite3_bind_text(statement, 1, (usernamel as NSString).utf8String, -1,nil)
            sqlite3_bind_text(statement, 2, (passwordl as NSString).utf8String, -1,nil)
            while sqlite3_step(statement) == SQLITE_ROW {
             
               
                if (sqlite3_column_text(statement, 1) != nil){
                username = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                }
               
                
                //print("\n",username,"\n")
                
            }
        }
        return username
    
    func delete(){
        let query = "DELETE FROM testusers WHERE 1 = 1"
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {

           

                if sqlite3_step(statement) == SQLITE_DONE {
                    print("Successfully deleted row.")
                } else {
                    print("Could not delete row.")
                }
            } else {
                print("DELETE statement could not be prepared")
            }




            sqlite3_finalize(statement)


            print("delete")


        }
    }
    

}
extension SQLiteDatabase {
 func prepareStatement(sql: String) throws -> OpaquePointer? {
  var statement: OpaquePointer?
  guard sqlite3_prepare_v2(db, sql, -1, &statement, nil)
      == SQLITE_OK else {
    throw SQLiteError.Prepare(message: errorMessage)
  }
  return statement
 }
}
