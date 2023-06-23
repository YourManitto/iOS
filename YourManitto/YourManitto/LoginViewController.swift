//
//  LoginViewController.swift
//  YourManitto
//
//  Created by 이자민 on 2023/06/23.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func emailLoginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                // 로그인 실패
                print("이메일 로그인 실패: \(error.localizedDescription)")
            } else {
                // 로그인 성공
                print("이메일 로그인 성공")
                
                // 로그인 후 처리할 작업 수행
                let vcName = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController")
                        vcName?.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
                        vcName?.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
                        self.present(vcName!, animated: true, completion: nil)            }
        }
    }

}
