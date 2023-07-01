//
//  UpdateNickNameViewController.swift
//  YourManitto
//
//  Created by 이자민 on 2023/06/30.
//

import UIKit
import Firebase

class UpdateNickNameViewController: UIViewController {
    var currentUserRef: DatabaseReference!
    @IBOutlet weak var nickNameTextField: UITextField!
    
    @IBOutlet weak var currentNicknameLabel: UILabel!
    @IBAction func updateNickNameButton(_ sender: Any) {
        
        guard let nickname = nickNameTextField.text else {
            return
        }
        
        // UUID
        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else { return }
        
        // Firebase에 UUID와 닉네임 저장
        let ref = Database.database().reference().child("users").child(uuid)
        ref.updateChildValues(["nickname": nickname]) { (error, _) in
            if let error = error {
                print("Error updating data: \(error)")
            } else {
                print("Data updated successfully")
            }
        }
        // 팝업 창을 생성하여 닉네임 변경이 완료되었음을 알림
        let alertController = UIAlertController(title: "알림", message: "닉네임 변경이 완료되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
            // 네비게이션 컨트롤러에서 최상위 뷰 컨트롤러를 제거하고 이전 화면으로 돌아감
            self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)

    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "닉네임 변경"
        // UUID
       guard let uuid = UIDevice.current.identifierForVendor?.uuidString else { return }
       
       // Firebase에 UUID와 닉네임 저장
       currentUserRef = Database.database().reference().child("users").child(uuid)
       
       // 현재 닉네임 가져오기
       currentUserRef.observeSingleEvent(of: .value) { snapshot in
           if let userData = snapshot.value as? [String: Any],
              let currentNickname = userData["nickname"] as? String {
               self.currentNicknameLabel.text = currentNickname
           }
       }
    }
    


}
