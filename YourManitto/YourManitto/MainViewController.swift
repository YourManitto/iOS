//
//  MainViewController.swift
//  YourManitto
//
//  Created by 이자민 on 2023/06/22.
//

import UIKit

class MainViewController: UIViewController,UICollectionViewDataSource {

    @IBOutlet weak var ListCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            return 8 // 첫 번째 값만 표시하므로 1을 반환
        }
        
        // 컬렉션 뷰 데이터 소스 - 셀 설정
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath)
         cell.layer.cornerRadius = 12
         cell.layer.borderWidth = 1 // 테두리 두께 설정
         cell.layer.borderColor = UIColor.lightGray.cgColor // 테두리 색상 설정
                 
            
            return cell
        }
}
