//
//  InputViewController.swift
//  taskapp
//
//  Created by アプリ開発 on 2019/06/03.
//  Copyright © 2019 Masato.achiwa. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {

    
    @IBOutlet var titleTextField: UITextField!
    
    @IBOutlet var contentsTextView: UITextView!
    
    @IBOutlet var datePicker: UIDatePicker!
    
    let realm = try! Realm()
    var task: Task!   // 追加する
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
        
    }


    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            self.realm.add(self.task, update: true)
        }
        
        super.viewWillDisappear(animated)
    }
    
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    
    
    
    
    

}
