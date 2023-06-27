//
//  MyRoomViewController.swift
//  YourManitto
//
//  Created by 이자민 on 2023/06/23.
//

import UIKit
import Firebase

class MyRoomViewController: UIViewController {

    @IBOutlet weak var deleteButton: defaultBtn!
    @IBOutlet weak var MyManittoButton: defaultBtn!
    
    let db = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateMyRoom()
        MyManittoButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    MyManittoButton.heightAnchor.constraint(equalToConstant: 90)
                ])
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([deleteButton.heightAnchor.constraint(equalToConstant: 40)
                                     ])
    }
    
    

}

extension MyRoomViewController{
    func updateMyRoom(){
        db.child("Rooms").child("Room").observeSingleEvent(of: .value, with: {snapshot in
            print("snapshot --> \(snapshot)")
            if let roomData = snapshot.value as? [String: Any] {
                        if let roomName = roomData["roomName"] as? String {
                            DispatchQueue.main.async {
                                self.title = roomName
                            }
                        }
                    }
        })
    }
    
    func saveBasicType(){
        db.child("int").setValue(99)
        db.child("str").setValue("이작심")
    }
    
    func saveMyRoom(){
        let myRoom1 = MyRoom(id: "\(MyRoom.id)", dDay: 7, manitto: "조교유녕")
        MyRoom.id += 1
        db.child("Users").child(myRoom1.id).setValue(myRoom1.toDictionary)
    }
}

struct MyRoom{
    let id:String
    let dDay:Int
    let manitto:String
    static var id:Int = 0
    
    
    var toDictionary:[String:Any]{
        let dict:[String:Any] = ["id":id, "D-day":dDay, "manitto":manitto]
        return dict
    }
}


struct Rooms{
    let rooms:[Room]
    var toDictionary:[String:Any]{
        let roomsArray = rooms.map{$0.toDictionary}
        let dict:[String:Any] = ["rooms":roomsArray]
        return dict
    }
}

struct Room{
    let dDay:Int
    let date:String
    let owner:String
    let roomId:String
    let roomName:String
    let time:String
    let userCount:Int
    
    let users:[Users]
    
    var toDictionary:[String:Any]{
        let usersArray = users.map{$0.toDictionary}
        let dict:[String:Any] = ["dDay":dDay, "date":date,"owner":owner,"roomId":roomId,"roomName":roomName,"time":time,"userCount":userCount,"users":usersArray]
        return dict
    }
    
}

struct Users{
    let user:[User]
    var toDictionary:[String:Any]{
        let userArray = user.map{$0.toDictionary}
        let dict:[String:Any] = ["user":userArray]
        return dict
    }
    
}

struct User{
    let fire:Int
    let heart:Int
    let like:Int
    let luck:Int
    let manitto:String
    let userId:String
    static var userId:Int = 0
    
    var toDictionary:[String:Any]{
        let dict:[String:Any] = ["fire":fire,"heart":heart,"like":like,"luck":luck,"manitto":manitto,"id":userId]
        return dict
    }
}


