//
//  MainViewController.swift
//  YourManitto
//
//  Created by 이자민 on 2023/06/22.
//

import UIKit
import Firebase

class MainViewController: UIViewController,UICollectionViewDataSource {
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
        print("fetch 전")
        fetchRoomCodes()
        print("fetch 후")
        ListCollectionView.dataSource=self
     
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
        
        // 컬렉션 뷰 데이터 소스 - 셀 설정
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath) as! RoomCollectionViewCell
         cell.layer.cornerRadius = 12
         cell.layer.borderWidth = 1 // 테두리 두께 설정
         cell.layer.borderColor = UIColor.lightGray.cgColor // 테두리 색상 설정
            
            let roomCode = roomCodes[indexPath.item]
                if let roomInfo = roomData[roomCode] as? [String: Any] {
                    // 방 정보를 사용하여 셀에 표시할 내용 설정
                    // 예: 셀의 텍스트 레이블에 방 이름을 표시
                    if let roomName = roomInfo["roomName"] as? String {
                        cell.roomNameLabel.text = roomName
                    }
                }
                 
            
            return cell
        }
}

class RoomCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var roomNameLabel: UILabel!
}
extension MainViewController{
    
    func fetchRoomCodes() {
        print("fetchRoomCode 실행됨!!!")
            // 파이어베이스에서 Users 테이블의 방 코드들을 가져오는 로직을 구현합니다.
            db.child("Users").child(uuid!).child("myRooms").observeSingleEvent(of: .value) { [weak self] (snapshot) in
                guard let self = self else { return }
                
                if let myRooms = snapshot.value as? [String: [String: String]] {
                    for (_, roomData) in myRooms {
                        print(snapshot)
                        if let roomId = roomData["roomId"] {
                            self.roomCodes.append(roomId)
                        }
                    }
                    
                    self.fetchRoomData() // 가져온 방 코드들을 사용하여 방 정보를 가져옴
                }
            }
        }
        
    func fetchRoomData() {
        // 방 코드를 사용하여 Rooms 테이블에서 방의 정보를 가져오는 로직을 구현합니다.
        let roomDataGroup = DispatchGroup()
        
        for roomCode in roomCodes {
            roomDataGroup.enter()
            
            db.child("Rooms").child(roomCode).observeSingleEvent(of: .value) { [weak self] (snapshot) in
                guard let self = self else { return }
                
                if let roomInfo = snapshot.value as? [String: Any] {
                    self.roomData[roomCode] = roomInfo // 방 정보를 딕셔너리에 저장
                    print("룸이름은!!!\(roomInfo)")
                }
                
                roomDataGroup.leave()
            }
        }
        
        roomDataGroup.notify(queue: .main) {
            self.ListCollectionView.reloadData() // 리스트 컬렉션 뷰를 업데이트하여 데이터 표시
        }
    }
}
