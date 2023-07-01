//
//  WaitingViewController.swift
//  YourManitto
//
//  Created by 이자민 on 2023/06/30.
//

import UIKit
import Firebase

class WaitingViewController: UIViewController,UICollectionViewDataSource {
    var roomInfo: [String: Any]? // 방 정보를 저장할 변수
    var roomCode: String? // 방 코드를 저장할 변수
    var roomUsers: [String] = []

    
    @IBAction func setManitofunc(_ sender: defaultBtn) {
        
        guard let roomCode = roomCode else {
                return
            }
            
            let db = Database.database().reference()
            let roomUserRef = db.child("room_user").child(roomCode)
            
            roomUserRef.observeSingleEvent(of: .value) { snapshot in
                guard snapshot.exists(), let roomUserData = snapshot.value as? [String: Any] else {
                    return
                }
                
                let participantUUIDs = Array(roomUserData.keys)
                var shuffledUUIDs = participantUUIDs.shuffled()
                
                let count = shuffledUUIDs.count
                for index in 0..<count {
                let currentUUID = shuffledUUIDs[index]
                let nextUUID = shuffledUUIDs[(index + 1) % count]
                
                if currentUUID == nextUUID {
                    // 자기 자신이 자신의 마니또인 경우, 다음 다음 참가자의 UUID를 사용
                    let nextNextUUID = shuffledUUIDs[(index + 2) % count]
                    shuffledUUIDs[(index + 1) % count] = nextNextUUID
                }
                
                let participantRef = roomUserRef.child(currentUUID)
                participantRef.updateChildValues(["manito_userId": nextUUID])
            }
        }
    }
    
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var confirmButton: defaultBtn!
    @IBOutlet weak var userCountLabel: UILabel!
    @IBOutlet weak var waitingListCollectionView: UICollectionView!
    override func viewDidLoad() {
        print(roomInfo)
        
        super.viewDidLoad()
        self.confirmButton.isHidden = true
        // 컬렉션 뷰의 데이터 소스 설정
        waitingListCollectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // 세로 스크롤 방향으로 설정
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) // 좌우 마진 설정
                
        waitingListCollectionView.collectionViewLayout = layout
        
        if let roomName = roomInfo?["name"] as? String {
            title = roomName
            print("roomName ---> \(roomName)")
        }
        
        fetchRoomUsers()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 컬렉션 뷰 가로 크기 설정
        if let flowLayout = waitingListCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: waitingListCollectionView.bounds.width - 54, height: 55) // 가로 크기 설정 (-40은 좌우 마진 20씩을 고려한 값)
            }
        }
   // 컬렉션 뷰 데이터 소스 - 아이템 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return roomUsers.count
      }
   
    // 컬렉션 뷰 데이터 소스 - 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "waitingCell", for: indexPath) as? WaitingCollectionViewCell else {
                    fatalError("Unable to dequeue WaitingCollectionViewCell")
                }
        cell.deleteUserButton.isHidden = true
        cell.layer.cornerRadius = 12
        cell.layer.borderWidth = 1 // 테두리 두께 설정
        cell.layer.borderColor = UIColor.lightGray.cgColor // 테두리 색상 설정
        let userName = roomUsers[indexPath.item]
        cell.waitingUserLabel.text = userName
        
        // 방장 여부에 따라 deleteUserButton을 보이거나 숨깁니다.
            if let myUUID = UIDevice.current.identifierForVendor?.uuidString, let roomCode = roomCode {
                let db = Database.database().reference()
                let roomUserRef = db.child("room_user").child(roomCode)
                
                roomUserRef.observeSingleEvent(of: .value) { snapshot in
                    guard snapshot.exists(), let roomUserData = snapshot.value as? [String: Any], let userData = roomUserData[myUUID] as? [String: Any], let isCreator = userData["isCreator"] as? Int else {
                        cell.deleteUserButton.isHidden = true // 방 정보를 가져올 수 없거나 방장 여부를 확인할 수 없으면 버튼을 숨김 처리
                        return
                    }
                    
                    if isCreator == 1 {
                        cell.deleteUserButton.isHidden = false // 방장이면 버튼을 보이도록 설정
                    } else {
                        cell.deleteUserButton.isHidden = true // 방장이 아니면 버튼을 숨김 처리
                    }
                }
            }
        cell.deleteUserButton.tag = indexPath.item
        cell.deleteUserButton.addTarget(self, action: #selector(deleteUser(_:)), for: .touchUpInside)

        return cell
    }
    
    @objc func deleteUser(_ sender: UIButton) {
            let index = sender.tag
            
            guard index >= 0 && index < roomUsers.count else {
                return
            }
            
            let userToDelete = roomUsers[index]
            removeUserFromRoom(userToDelete)
        }

}



class WaitingCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var waitingUserLabel: UILabel!
    @IBOutlet weak var deleteUserButton: UIButton!
    @IBAction func deleteUserFunc(_ sender: UIButton) {
        guard let viewController = findViewController() as? WaitingViewController else {
                    return
                }
                
                // 셀을 포함하는 컬렉션 뷰의 indexPath를 가져옵니다.
                guard let indexPath = viewController.waitingListCollectionView.indexPath(for: self) else {
                    return
                }
                
                let userToDelete = viewController.roomUsers[indexPath.item]
                viewController.removeUserFromRoom(userToDelete)
            }
            
            // 셀이 속한 뷰 컨트롤러를 찾는 메서드
            private func findViewController() -> UIViewController? {
                var responder: UIResponder? = self
                while let currentResponder = responder {
                    if let viewController = currentResponder as? UIViewController {
                        return viewController
                    }
                    responder = currentResponder.next
                }
                return nil
    }
    
    
}

extension WaitingViewController {
    func fetchRoomUsers() {
        guard let roomCode = roomCode, let myUUID = UIDevice.current.identifierForVendor?.uuidString else {
            return
        }
        
        let db = Database.database().reference()
        let roomUserRef = db.child("room_user").child(roomCode)
        
        roomUserRef.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists(), let roomUserData = snapshot.value as? [String: [String: Any]] {
                self.roomUsers = roomUserData.keys.map { $0 }
                self.fetchUserNames()
                
                // 내 UUID와 동일한 값의 isCreator 확인 및 confirmButton 표시 여부 설정
                if let userData = roomUserData[myUUID], let isCreator = userData["isCreator"] as? Int {
                    if isCreator == 1 {
                        self.confirmButton.isHidden = false // 버튼을 보이도록 설정
                        
                        print("방장입니다.")
                    } else {
                        self.noticeLabel.text = "참여자가 다 모일때까지"
                        self.noticeLabel.text! += "\n기다려주세요 :)"
                        self.confirmButton.isHidden = true // 버튼을 숨김 처리
                        
                        print("방장이 아닙니다.")
                    }
                } else {
                    self.confirmButton.isHidden = true // 버튼을 숨김 처리
                    print("내 정보를 찾을 수 없습니다.")
                }
            }
        }
    }

    func fetchUserNames() {
        guard !roomUsers.isEmpty else {
            return
        }
        
        let db = Database.database().reference()
        let usersRef = db.child("users")
        
        usersRef.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists(), let usersData = snapshot.value as? [String: Any] {
                var updatedRoomUsers: [String] = []
                for userID in self.roomUsers {
                    if let userData = usersData[userID] as? [String: Any], let userName = userData["nickname"] as? String {
                        updatedRoomUsers.append(userName)
                    }
                }
                self.roomUsers = updatedRoomUsers
                self.waitingListCollectionView.reloadData()
                self.userCountLabel.text = "총 \(self.roomUsers.count)명"
            }
        }
    }
    
    func removeUserFromRoom(_ userToDelete: String) {
            guard let roomCode = roomCode else {
                return
            }
            
            let db = Database.database().reference()
            let roomUserRef = db.child("room_user").child(roomCode)
            
            // 삭제할 유저의 데이터를 가져옵니다.
            roomUserRef.observeSingleEvent(of: .value) { snapshot in
                guard snapshot.exists(), var roomUserData = snapshot.value as? [String: [String: Any]] else {
                    return
                }
                
                // 삭제할 유저를 제거합니다.
                roomUserData.removeValue(forKey: userToDelete)
                
                // 업데이트된 데이터를 다시 저장합니다.
                roomUserRef.setValue(roomUserData) { error, _ in
                    if let error = error {
                        print("Failed to remove user from room: \(error.localizedDescription)")
                        return
                    }
                    
                    // 삭제 후에 유저 목록을 다시 가져옵니다.
                    self.fetchRoomUsers()
                }
            }
        }
        
}
