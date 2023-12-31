//
//  MakeRoomViewController.swift
//  YourManitto
//
//  Created by 이자민 on 2023/06/26.
//

import UIKit
import Firebase

class MakeRoomViewController: UIViewController {
    let db = Database.database().reference()
    
 
    @IBOutlet weak var generateRoomID: defaultBtn!
    @IBOutlet weak var roomNameTextField: DefaultTextField!
    @IBOutlet weak var dDayBtn: defaultBtn!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
            super.viewDidLoad()
        generateRoomID.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([generateRoomID.heightAnchor.constraint(equalToConstant: 45)
                                     ])
        // 오늘 날짜 가져오기
        let currentDate = Date()
        
        // datePicker의 minimumDate를 오늘 날짜로 설정
        datePicker.minimumDate = currentDate
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        // 현재 선택된 값으로 초기 설정
        updateLabels()
        // 버튼의 글씨 크기 설정
        dDayBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        roomNameTextField.delegate = self
        }
        
        @objc func datePickerValueChanged() {
            updateLabels()
            // 날짜 선택 후 창 닫기
                view.endEditing(true)
        }
        
        func updateLabels() {
            let dateFormatter = DateFormatter()
                    
            // 날짜 형식 설정
                    dateFormatter.dateFormat = "yyyy년 MM월 dd일"
                    let selectedDateString = dateFormatter.string(from: datePicker.date)
                    dateLabel.text = selectedDateString
                    
                    // 시간 형식 설정
                    dateFormatter.dateFormat = "h:mm a"
                    let selectedTime = dateFormatter.string(from: datePicker.date)
                    timeLabel.text = "\(selectedTime) 마니또 공개가 맞나요? "
                    
                    // D-day 계산
                    let currentDate = Date()
                    let selectedDate = dateFormatter.date(from: selectedDateString) ?? Date()
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: currentDate), to: calendar.startOfDay(for: selectedDate))
                    let dDay = components.day ?? 0
                    
                    dDayBtn.setTitle("D - \(dDay)", for: .normal)
        }
    
    @IBAction func generateRoomID(_ sender: UIButton) {
        guard let roomName = roomNameTextField.text, !roomName.isEmpty else {
                // 방 이름이 없을 경우 팝업 표시
                showAlert(title: "알림", message: "방 이름을 입력해주세요.")
                return
            }
                let generatedID = generateUniqueID()
                generateNewRoom(roomName: roomName,generatedID: generatedID)
            
            // 생성된 ID 출력
            print(generatedID)
        // 팝업 창 생성
            let alertController = UIAlertController(title: "참여 코드", message: generatedID, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
                // 클립보드에 참여 코드 복사
                UIPasteboard.general.string = generatedID

                // 토스트 메시지 표시
                self.showToast(message: "클립보드에 복사 완료")
                if let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController"){
                    self.navigationController?.pushViewController(mainVC, animated: true)
                }
            }
            alertController.addAction(okAction)
            
            // 팝업 창 표시
            present(alertController, animated: true, completion: nil)
        }
    
    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.systemFont(ofSize: 12)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)

        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func generateUniqueID() -> String {
            let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            let idLength = 8
            
            var generatedID = ""
            
            // 중복 검사를 수행하여 충돌 가능성을 줄임
            repeat {
                generatedID = ""
                
                // ID를 랜덤하게 생성
                for _ in 0..<idLength {
                    let randomIndex = Int.random(in: 0..<characters.count)
                    let character = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
                    generatedID.append(character)
                }
            } while !isIDUnique(generatedID)
            
            return generatedID
        }

    func isIDUnique(_ id: String) -> Bool {
            // 기존에 생성된 ID 목록과 비교하여 중복 여부 확인
            // 중복이 없으면 true, 중복이 있으면 false 반환하는 로직을 구현해야 합니다.
            // 여기서는 임의로 true를 반환하도록 설정하였습니다. 실제로는 기존에 생성된 ID 목록을 저장하고 비교해야 합니다.
            return true
        }
    
    
}

extension MakeRoomViewController{
    func generateNewRoom(roomName: String,generatedID:String){
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        
        dateFormatter.dateFormat = "h:mm a"
        let selectedTime = dateFormatter.string(from: datePicker.date)
        
        // D-day 계산
        let currentDate = Date()
        let selectedDateString = dateFormatter.date(from: selectedDate) ?? Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: currentDate), to: calendar.startOfDay(for: selectedDateString))
        let dDay = components.day ?? 0
        
        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else {
                print("UUID 못가져와")
                return
            }
        
        
        let room_user = Room_User(luck_cnt: 0, heart_cnt: 0, like_cnt: 0, fire_cnt: 0, isCreator: true, manito_roomId: generatedID, manito_userId: "")
        
        db.child("room_user").child(room_user.manito_roomId).child(uuid).setValue(room_user.toDictionary)
        
        let room = Room(date: selectedDate, time: selectedTime,name:roomName,isMatch: false)
        db.child("rooms").child(generatedID).setValue(room.toDictionary)
    }
    
}

extension MakeRoomViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
