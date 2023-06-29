//
//  EnterRoomViewController.swift
//  YourManitto
//
//  Created by 이자민 on 2023/06/26.
//

import UIKit
import Firebase

class EnterRoomViewController: UIViewController, UITextFieldDelegate {
    let db = Database.database().reference()
    @IBOutlet weak var roomIdTextField: UITextField!
    
    
    @IBAction func enterRoomButton(_ sender: defaultBtn) {
        guard let roomId = roomIdTextField.text, !roomId.isEmpty else {
            // 방 이름이 없을 경우 팝업 표시
            showAlert(title: "알림", message: "방 이름을 입력해주세요.")
            return
        }
        
        guard let roomID = roomIdTextField.text else {
            print("입력한 방 ID가 유효하지 않습니다.")
            return
        }
        let roomsRef = db.child("rooms")
        roomsRef.observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                let roomData = snapshot.value as? [String: Any]
                if roomData?.keys.contains(roomID) ?? false {
                    print("일치하는 방이 있습니다.")
                    // 일치하는 방이 있을 때의 동작을 수행할 수 있습니다.
                    if let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController"){
                        self.navigationController?.pushViewController(mainVC, animated: true)
                    }
                    self.enterNewRoom(roomID: roomID)
                    
                } else {
                    print("일치하는 방이 없습니다.")
                    // 일치하는 방이 없을 때의 동작을 수행할 수 있습니다.
                }
            } else {
                print("방 데이터가 없습니다.")
            }
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        roomIdTextField.delegate = self
    }
    
}
extension EnterRoomViewController{
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func enterNewRoom(roomID: String){
        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else {
                print("UUID 못가져와")
                return
            }
        
        let roomUserRef = db.child("room_user").child(roomID).child(uuid)
            roomUserRef.observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.exists() {
                    // 이미 참여한 방인 경우 팝업창 표시
                    self.showAlert(title: "알림", message: "이미 참여한 방입니다.")
                } else {
                    // 새로운 방 참여 정보 추가
                    let roomUser = Room_User(luck_cnt: 0, heart_cnt: 0, like_cnt: 0, fire_cnt: 0, isCreator: false, manito_roomId: roomID, manito_userId: "")
                    roomUserRef.setValue(roomUser.toDictionary)
                }
            })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

