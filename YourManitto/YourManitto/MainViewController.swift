//
//  MainViewController.swift
//  YourManitto
//
//  Created by 이자민 on 2023/06/22.
//

import UIKit
import Firebase

class MainViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {
    let db = Database.database().reference()
    var uuid: String? // UUID 값을 저장할 변수
    var roomCodes: [String] = [] // 방 코드를 저장할 배열
    var roomData: [String: Any] = [:] // 방 정보를 저장할 딕셔너리
    @IBOutlet weak var ListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UUID 값을 가져옴
                if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                    self.uuid = uuid
                }
        fetchRoomsForUser()
        ListCollectionView.dataSource=self
        ListCollectionView.delegate = self
     
         let layout = UICollectionViewFlowLayout()
         layout.scrollDirection = .vertical // 세로 스크롤 방향으로 설정
         layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) // 좌우 마진 설정
                 
         ListCollectionView.collectionViewLayout = layout
     
    }
    
    @IBAction func makeRoomButton(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "makeRoom") as? MakeRoomViewController else {
                return
            }
            navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func enterRoomButton(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "enterRoom") as? EnterRoomViewController else{
            return
            
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 대기실로 이동
       func navigateToWaitingRoom(with roomCode: String, roomInfo: [String: Any]) {
           guard let vc = storyboard?.instantiateViewController(withIdentifier: "waitingRoom") as? WaitingViewController else {
               return
           }

           vc.roomCode = roomCode
           vc.roomInfo = roomInfo
           navigationController?.pushViewController(vc, animated: true)
       }

       // 내 방으로 이동
       func navigateToMyRoom(with roomCode: String, roomInfo: [String: Any]) {
           guard let vc = storyboard?.instantiateViewController(withIdentifier: "myRoom") as? MyRoomViewController else {
               return
           }

           vc.roomCode = roomCode
           vc.roomInfo = roomInfo
           navigationController?.pushViewController(vc, animated: true)
       }
    
    
    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         
         // 컬렉션 뷰 가로 크기 설정
         if let flowLayout = ListCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
             flowLayout.itemSize = CGSize(width: ListCollectionView.bounds.width - 54, height: 80) // 가로 크기 설정 (-40은 좌우 마진 20씩을 고려한 값)
         }
     }
    
    // 컬렉션 뷰 데이터 소스 - 아이템 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomCodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell 선택됨")
        let roomCode = roomCodes[indexPath.item]
        print(roomCode)
            if let roomInfo = roomData[roomCode] as? [String: Any] {
                print(roomInfo)
            if let isMatch = roomInfo["isMatch"] as? Int {
                if isMatch == 0 {
                    print("매칭 전")
                    navigateToWaitingRoom(with: roomCode, roomInfo: roomInfo)
                } else {
                    print("매칭 완료")
                    navigateToMyRoom(with: roomCode, roomInfo: roomInfo)
                }
            }
        }
    }
    
    // 컬렉션 뷰 데이터 소스 - 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath) as! RoomCollectionViewCell
         cell.layer.cornerRadius = 12
         cell.layer.borderWidth = 1 // 테두리 두께 설정
         cell.layer.borderColor = UIColor.lightGray.cgColor // 테두리 색상 설정
        
        let roomCode = roomCodes[indexPath.item]
        if let roomInfo = roomData[roomCode] as? [String: Any] {
            if let roomName = roomInfo["name"] as? String {
                cell.roomNameLabel.text = roomName
                print("roomName ---> \(roomName)")
            }
            
        }
      
        return cell
    }
}


class RoomCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var roomNameLabel: UILabel!
}



extension MainViewController{
    func fetchRoomsForUser() {
        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else {
            print("UUID를 가져올 수 없습니다.")
            return
        }
        
        let roomUserRef = db.child("room_user")
        
        // room_user 테이블의 모든 항목을 탐색하여 내 UUID를 포함하는 roomID들을 구합니다.
        roomUserRef.observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                var roomIDs: [String] = []
                
                for child in snapshot.children {
                    guard let roomSnapshot = child as? DataSnapshot else {
                        continue
                    }
                    
                    let roomData = roomSnapshot.value as? [String: Any]
                    
                    // 내 UUID를 포함하는 roomID를 찾습니다.
                    if let userIds = roomData?.keys.compactMap({ $0 as? String }), userIds.contains(uuid) {
                        roomIDs.append(roomSnapshot.key)  // 방 코드를 추가합니다.
                    }
                }
                
                // 방 정보를 가져옵니다.
                self.fetchRoomInfo(roomIDs: roomIDs)
            } else {
                print("room_user 데이터가 없습니다.")
            }
        })
    }

    func fetchRoomInfo(roomIDs: [String]) {
        let roomsRef = db.child("rooms")
        
        // roomIDs에 해당하는 방 정보를 가져옵니다.
        for roomID in roomIDs {
            roomsRef.child(roomID).observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.exists() {
                    if let roomData = snapshot.value as? [String: Any] {
                        // 가져온 방 정보 활용
                        print("방 정보: \(roomData)")
                        
                        // 방 코드를 roomCodes 배열에 추가합니다.
                        self.roomCodes.append(roomID)
                        
                        // 방 정보를 저장합니다.
                        self.roomData[roomID] = roomData
                        
                        // 방 정보를 가져올 때마다 컬렉션 뷰를 새로고침합니다.
                        self.ListCollectionView.reloadData()
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy년 MM월 dd일"

                        let sortedRoomCodes = self.roomCodes.sorted { (roomCode1: String, roomCode2: String) -> Bool in
                            guard let roomInfo1 = self.roomData[roomCode1] as? [String: Any],
                                  let roomInfo2 = self.roomData[roomCode2] as? [String: Any],
                                  let dateString1 = roomInfo1["date"] as? String,
                                  let dateString2 = roomInfo2["date"] as? String,
                                  let date1 = dateFormatter.date(from: dateString1),
                                  let date2 = dateFormatter.date(from: dateString2) else {
                                return false
                            }
                            return date1 < date2
                        }
                        
                        // 정렬된 방 코드 배열을 업데이트합니다.
                        self.roomCodes = sortedRoomCodes
                        
                        // 정렬된 방 정보를 사용하여 컬렉션 뷰를 다시 로드합니다.
                        self.ListCollectionView.reloadData()
                    }
                } else {
                    print("방 ID에 해당하는 정보가 없습니다.")
                }
            })
        }
    }

}
