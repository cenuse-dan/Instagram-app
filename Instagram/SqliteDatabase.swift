//
//  SqliteDatabase.swift
//  Instagram
//
//  Created by user216341 on 5/3/22.
//

import Foundation
import SQLite

class SQDB {
//    init(){}
//    var dbsq: AnyObject
//
//    func connectDataBase () -> AnyObject{
//    do {
//         dbsq = try Connection("/Users/user216341/Desktop/Baza de date/instaDataBase.sqlite")
//        return dbsq
//    }
//    catch
//    {
//        print(error.localizedDescription)
//    }
//
//    }
//    self.dbsq = connectDataBase()
//    let id = Expression<Int64>("id")
//    let name = Expression<String?>("name")
//    let email = Expression<String>("email")
//    let balance = Expression<Double>("balance")
//    let verified = Expression<Bool>("verified")
//    let users = Table("users")
//    func createTable() {
//    try dbsq.run(users.create { t in     // CREATE TABLE "users" (
//        t.column(id, primaryKey: true) //     "id" INTEGER PRIMARY KEY NOT NULL,
//        t.column(email, unique: true)  //     "email" TEXT UNIQUE NOT NULL,
//        t.column(name)                 //     "name" TEXT
//    })
//    }
    init(){
    }
    var db: AnyObject
    func createConnection (){
    do {
        
         db = try Connection("/Users/user216341/Desktop/Baza de date/instaDataBase.sqlite")
    }
        catch{
            print(error)
        }
    }
        let users = Table("users")
        let id = Expression<Int64>("id")
        let name = Expression<String?>("name")
        let email = Expression<String>("email")

//        try db.run(users.create { t in
//            t.column(id, primaryKey: true)
//            t.column(name)
//            t.column(email, unique: true)
//        })
        // CREATE TABLE "users" (
        //     "id" INTEGER PRIMARY KEY NOT NULL,
        //     "name" TEXT,
        //     "email" TEXT NOT NULL UNIQUE
        // )
    func insertion(){
        let insert = users.insert(name <- "Alice", email <- "alice@mac.com")
        do{
        let rowid = try db.run(insert)
        }
        catch{
            
        }
        // INSERT INTO "users" ("name", "email") VALUES ('Alice', 'alice@mac.com')
    }
    func read(){
        for user in try db.prepare(users) {
            print("id: \(user[id]), name: \(user[name]), email: \(user[email])")
            // id: 1, name: Optional("Alice"), email: alice@mac.com
        }
    }
        // SELECT * FROM "users"
    func update {
        let alice = users.filter(id == rowid)

        try db.run(alice.update(email <- email.replace("mac.com", with: "me.com")))
    }
        // UPDATE "users" SET "email" = replace("email", 'mac.com', 'me.com')
        // WHERE ("id" = 1)

       // try db.run(alice.delete())
        // DELETE FROM "users" WHERE ("id" = 1)

        print(try db.scalar(users.count)) // 0
        // SELECT count(*) FROM "users"
    } catch {
        print (error)
    }
    }
    
}
