//
//  StartViewController.swift
//  YourManitto
//
//  Created by 이자민 on 2023/06/23.
//

import UIKit
import Firebase

class StartViewController: UIViewController {

    @IBOutlet weak var otherButton: UIButton!
    @IBAction func otherButtonTapped(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "nickNameView") as? NickNameViewController else {
               return
           }
        navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UUID 가져오기
                guard let uuid = UIDevice.current.identifierForVendor?.uuidString else {
                    print("UUID 못가져와")
                    return
                }
                
                // Firebase에서 UUID 확인
                let databaseRef = Database.database().reference().child("Users").child(uuid)
                databaseRef.observeSingleEvent(of: .value) { snapshot in
                    if snapshot.exists() {
                        // UUID가 등록되어 있는 경우
                        // 메인 화면으로 이동
                        print("가입완료 된 기기 입니다")
                        
                        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else {
                               return
                           }
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        print("UUID 없슴")
                    }
                }


        otherButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    otherButton.heightAnchor.constraint(equalToConstant: 45)
                ])
        
    }
    
}
