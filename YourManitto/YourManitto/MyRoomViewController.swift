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
    var roomInfo: [String: Any]? // 방 정보를 저장할 변수
    var roomCode: String? // 방 코드를 저장할 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateMyRoom()
        MyManittoButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    MyManittoButton.heightAnchor.constraint(equalToConstant: 90)
                ])
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([deleteButton.heightAnchor.constraint(equalToConstant: 45)
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
    
//    func saveBasicType(){
//        db.child("int").setValue(99)
//        db.child("str").setValue("이작심")
//    }
//
//    func saveMyRoom(){
//        let myRoom1 = MyRoom(id: "\(MyRoom.id)", dDay: 7, manitto: "조교유녕")
//        MyRoom.id += 1
//        db.child("Users").child(myRoom1.id).setValue(myRoom1.toDictionary)
//    }
}

//struct MyRoom{
//    let id:String
//    let dDay:Int
//    let manitto:String
//    static var id:Int = 0
//
//
//    var toDictionary:[String:Any]{
//        let dict:[String:Any] = ["id":id, "D-day":dDay, "manitto":manitto]
//        return dict
//    }
//}


//struct Rooms{
//    let rooms:[Room]
//    var toDictionary:[String:Any]{
//        let roomsArray = rooms.map{$0.toDictionary}
//        let dict:[String:Any] = ["rooms":roomsArray]
//        return dict
//    }
//}
//
//struct Room{
//    let id:String
//    static var id:Int = 0
//    let dDay:Int
//    let date:String
//    let owner:String
//    let roomId:String
//    let roomName:String
//    let time:String
//    let userCount:String
//    static var userCount:Int = 1
//
//    let user:[User]
//
//    var toDictionary:[String:Any]{
//        let usersArray = user.map{$0.toDictionary}
//        let dict:[String:Any] = ["id":id,"dDay":dDay, "date":date,"owner":owner,"roomId":roomId,"roomName":roomName,"time":time,"userCount":userCount,"users":usersArray]
//        return dict
//    }
//
//}
//
//struct User{
//    let fire:Int
//    let heart:Int
//    let like:Int
//    let luck:Int
//    let manitto:String
//    let userId:String
//    static var userId:Int = 0
//
//    var toDictionary:[String:Any]{
//        let dict:[String:Any] = ["fire":fire,"heart":heart,"like":like,"luck":luck,"manitto":manitto,"id":userId]
//        return dict
//    }
//}
//
//struct Users{
//    //let uuid: String
//    //let nickname: String
//    let myRooms: [MyRoom]
//
//    var toDictionary: [String: Any] {
//        let myRoomsArray = myRooms.map { $0.toDictionary }
//        let dict: [String: Any] = ["myRooms": myRoomsArray]
//        return dict
//    }
//}
//struct MyRoom{
//    let roomId:String
//
//    var toDictionary:[String:Any]{
//        let dict:[String:Any] = ["roomId":roomId]
//        return dict
//    }
//}

struct Room{
    let date:String
    let time:String
    let name:String
    let isMatch:Bool
    
    var toDictionary:[String:Any]{
        let dict:[String:Any] = ["date":date, "time":time,"name":name,"isMatch":isMatch]
        return dict
    }
}

struct User{
    let nickname:String
    
    var toDictionary:[String:Any]{
        let dict:[String:Any] = ["nickname":nickname]
        return dict
    }
}

struct Room_User{
    let luck_cnt:Int
    let heart_cnt:Int
    let like_cnt:Int
    let fire_cnt:Int
    let isCreator:Bool
    let manito_roomId:String
    let manito_userId:String
    
    var toDictionary:[String:Any]{
        let dict:[String:Any] = ["luck_cnt":luck_cnt,"heart_cnt":heart_cnt,"like_cnt":like_cnt,"fire_cnt":fire_cnt,"isCreator":isCreator,"manito_roomId":manito_roomId,"manito_userId":manito_userId]
        return dict
    }
}

