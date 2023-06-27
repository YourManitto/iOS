//
//  SettingViewController.swift
//  YourManitto
//
//  Created by 이자민 on 2023/06/26.
//

import UIKit

class SettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let settings = ["닉네임 변경", "피드백 및 문의사항","개인정보 동의","탈퇴하기"]
    
    @IBOutlet weak var settingTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTableView.dataSource = self
        settingTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = settings[indexPath.row]
        
        if indexPath.row == 3 { // 탈퇴하기 셀
                cell.textLabel?.textColor = .red
            } else {
                cell.textLabel?.textColor = .black
            }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
