//
//  DataBaseManager.swift
//  Instagram
//
//  Created by user216341 on 4/26/22.
//

import SQLite3
import Foundation



//public class database{
//static let shared = database()
////var dbQueue : OpaquePointer!
//var dbuURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//func CreatAndOpenDatabase( ) -> OpaquePointer?
//{
//    var db: OpaquePointer?
//
//    let url = NSURL(fileURLWithPath: dbuURL)
//
//    if let pathComponent = url.appendingPathComponent("Insta.sqlite"){
//
//        let filePath=pathComponent.path
//
//        if sqlite3_open(filePath, &db) == SQLITE_OK
//        {
//            print("Succes at \(filePath)")
//            return db
//        }
//        else{
//            print("NU pornit")
//        }
//    }
//    else{
//        print("File path nu bun")
//    }
//  return db
//}
//    func createTable() -> Bool {
//
//        var bRedVal : Bool = false
//
//        let createTable = sqlite3_exec(dbQueue, "CREATE TABLE IF NOT EXIST TEMP (TEMPCOLUMN1 TEXT NULL, TEMPCOLUMN2 TEXT NULL)", nil, nil, nil)
//        if(createTable != SQLITE_OK){
//            print("fara tabla")
//            bRedVal = false
//        }
//        else{
//            bRedVal = true
//        }
//        return bRedVal
//    }
    
    


//}

class SQLiteDatabase {
    
    var db : OpaquePointer?
       var path : String = "myDataBaseName.sqlite"
       init() {
           self.db = createDB()
           self.createTable()
       }
       
       func createDB() -> OpaquePointer? {
           let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(path)
           
           var db : OpaquePointer? = nil
           
           if sqlite3_open(filePath.path, &db) != SQLITE_OK {
               print("There is error in creating DB")
               return nil
           }else {
               print("Database has been created with path \(path)")
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
}

