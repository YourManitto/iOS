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
                if let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController"){
                    self.navigationController?.pushViewController(mainVC, animated: true)
                }
            }
        }
    }

}
