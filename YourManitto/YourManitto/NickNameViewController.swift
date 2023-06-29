//
//  NickNameViewController.swift
//  YourManitto
//
//  Created by 이자민 on 2023/06/28.
//

import UIKit
import Firebase

class NickNameViewController: UIViewController {
    
    @IBOutlet weak var generateNickNameButton: defaultBtn!
    @IBOutlet weak var nickNameTextField: DefaultTextField!
    @IBAction func generateNickNameButton(_ sender: defaultBtn) {
        guard let nickname = nickNameTextField.text else {
            return
        }
        
        // UUID
        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else { return }
        
        // Firebase에 UUID와 닉네임 저장
        let ref = Database.database().reference().child("users").child(uuid)
        ref.setValue(["nickname": nickname]) { (error, _) in
            if let error = error {
                print("Error adding data: \(error)")
            } else {
                print("Data added successfully")
            }
        }
        
        // 로그인 후 처리할 작업 수행
        if let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController"){
            self.navigationController?.pushViewController(mainVC, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "닉네임 설정"
        
        generateNickNameButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([generateNickNameButton.heightAnchor.constraint(equalToConstant: 45)
                                     ])
    }
}

