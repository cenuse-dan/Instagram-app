//
//  DataBaseManager.swift
//  Instagram
//
//  Created by user216341 on 4/26/22.
//

import SQLite3
import Foundation




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
           let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(path)
           
           var db : OpaquePointer? = nil
           
           if sqlite3_open(filePath.path, &db) != SQLITE_OK {
               print("There is error in creating DB")
               return nil
           }else {
               //print("Database has been created with path \(path) \(filePath)")
               return db
           }
       }
    
    func createTable()  {
          let query = "CREATE TABLE IF NOT EXISTS testusers(id INTEGER PRIMARY KEY AUTOINCREMENT,username TEXT, email TEXT, password TEXT);"
          var statement : OpaquePointer? = nil
          
          if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
              if sqlite3_step(statement) == SQLITE_DONE {
                  print("Table creation success")
              }else {
                  print("Table creation fail")
              } 
          } else {
              print("Prepration fail")
          }
      }
    
    /// Check if username and email are available
    /// - Paramters
    ///     -email: String used for email
    ///     -username: String used for username
    public func canCreateNewUser(with email: String, username: String, completion: (Bool)-> Void){
        completion(true)
    }
    public func insertNewUser (username: String, email: String, password: String) throws{
        let query = "INSERT INTO testusers (username,email,password) VALUES (?, ?, ?)"
        
        
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (username as NSString).utf8String, -1,nil)
            sqlite3_bind_text(statement, 2, (email as NSString).utf8String, -1,nil)
            sqlite3_bind_text(statement, 3, (password as NSString).utf8String, -1,nil)
        
            guard sqlite3_step(statement) == SQLITE_DONE else {
              throw SQLiteError.Step(message: errorMessage)
            }
            print("Successfully inserted row.")
            read()
        }
        else {
           print("Query is not as per requirement")
        }
    }
    func read()
    {
          let query = "SELECT * FROM testusers;"
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

                print("\n",id,username,email,password,"\n")
              }
          }
         
      }
    func readloguser (usernamel: String, passwordl:String) -> Bool{
        let query = "SELECT * FROM testusers;"
        var statement : OpaquePointer?
        var test = false
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW {
                var username = "NULL"
                let id = Int(sqlite3_column_int(statement, 0))
                if (sqlite3_column_text(statement, 1) != nil){
                username = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                }
                let email = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                let password = String(describing: String(cString: sqlite3_column_text(statement, 3)))

                if(username == usernamel && passwordl == password){
                    test = true
                }
            }
        }
        return test
    }
    
    func readloguserwhere (usernamel: String, passwordl:String) -> String{
        let querySql = "SELECT * FROM testusers WHERE username = ? AND password = ? ;"
        var username = "NULL"
        var statement : OpaquePointer?
       // print (usernamel)
        if sqlite3_prepare_v2(db, querySql, -1, &statement, nil) == SQLITE_OK{
            sqlite3_bind_text(statement, 1, (usernamel as NSString).utf8String, -1,nil)
            sqlite3_bind_text(statement, 2, (passwordl as NSString).utf8String, -1,nil)
            while sqlite3_step(statement) == SQLITE_ROW {
                var username = "NULL"
                let id = Int(sqlite3_column_int(statement, 0))
                if (sqlite3_column_text(statement, 1) != nil){
                username = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                }
                let email = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                let password = String(describing: String(cString: sqlite3_column_text(statement, 3)))
                print("\n",username,"\n")
                
            }
        }
        return username
    func readlogemail(emaill:String, passwordl:String) -> Bool{
        let query = "SELECT * FROM testusers;"
        var statement : OpaquePointer?
        var test = false
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW {
                var username = "NULL"
                let id = Int(sqlite3_column_int(statement, 0))
                if (sqlite3_column_text(statement, 1) != nil){
                username = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                }
                let email = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                let password = String(describing: String(cString: sqlite3_column_text(statement, 3)))

                if(email==emaill && passwordl == password){
                    test = true                }
            }
        }
        return test
    }
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
