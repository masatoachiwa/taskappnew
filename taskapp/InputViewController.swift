//
//  InputViewController.swift
//  taskapp
//
//  Created by アプリ開発 on 2019/06/03.
//  Copyright © 2019 Masato.achiwa. All rights reserved.
//

import UIKit
import RealmSwift    // 追加する
import UserNotifications    // 追加


class InputViewController: UIViewController {
    
    
    @IBOutlet var titleTextField: UITextField!
    
    @IBOutlet var contentsTextView: UITextView!
    
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet var categoryTextField: UITextField!  //課題
   
    let realm = try! Realm()
    var task: Task!   // 追加する
    
    
    override func viewDidLoad() {//~~~~~~~~~~~~~~~~~~viewDidLoad~~~~~~~~~~~~
        super.viewDidLoad()
        
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))    //キーボードを消す areget(self)はinputViewのこと
        self.view.addGestureRecognizer(tapGesture)  //タップ認識のインスタンス作成
        
        titleTextField.text = task.title//----------------------------taskの情報を画面に反映させる
        contentsTextView.text = task.contents
        datePicker.date = task.date
        categoryTextField.text = task.category   //課題-------------------ここまで----------------
      
    }//~~~~~~~~~~~~~~viedDidLoadのメソッドここまで~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    
    override func viewWillDisappear(_ animated: Bool) {//画面が非表示になったら呼ぶメソッド------------
        try! realm.write { //realmのデータを書き込む
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
          
            self.task.category = self.categoryTextField.text!   //課題
            self.realm.add(self.task, update: true)   //課題
        }//---------------------------------------------ここまで--------------------------------------------
        
        
        setNotification(task: task)   // 追加
        
        super.viewWillDisappear(animated)
    }
    
    // タスクのローカル通知を登録する --- ここから ---
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        // タイトルと内容を設定(中身がない場合メッセージ無しで音だけの通知になるので「(xxなし)」を表示する)
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        if task.contents == "" {
            content.body = "(内容なし)"
        } else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default
        
        // ローカル通知が発動するtrigger（日付マッチ）を作成
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        
        // identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
        let request = UNNotificationRequest.init(identifier: String(task.id), content: content, trigger: trigger)
        
        // ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録 OK")  // error が nil ならローカル通知の登録に成功したと表示します。errorが存在すればerrorを表示します。
        }
        
        // 未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("---------------/")
            }
        }
    } // --- ここまで追加 ---
    
 
    
    
    
    
    
    
    
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
}
