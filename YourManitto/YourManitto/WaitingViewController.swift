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

    @IBOutlet weak var userCountLabel: UILabel!
    @IBOutlet weak var waitingListCollectionView: UICollectionView!
    override func viewDidLoad() {
        print(roomInfo)
        
        super.viewDidLoad()
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
        fetchRoomUsers()    }
    
    
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
                
        cell.layer.cornerRadius = 12
        cell.layer.borderWidth = 1 // 테두리 두께 설정
        cell.layer.borderColor = UIColor.lightGray.cgColor // 테두리 색상 설정
        let userName = roomUsers[indexPath.item]
        cell.waitingUserLabel.text = userName
        
        return cell
    }

}



class WaitingCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var waitingUserLabel: UILabel!
    
}

extension WaitingViewController {
    func fetchRoomUsers() {
            guard let roomCode = roomCode else {
                return
            }
            
            let db = Database.database().reference()
            let roomUserRef = db.child("room_user").child(roomCode)
            
            roomUserRef.observeSingleEvent(of: .value) { snapshot in
                if snapshot.exists(), let roomUserData = snapshot.value as? [String: Any] {
                    self.roomUsers = Array(roomUserData.keys)
                    self.fetchUserNames()
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
        
}
