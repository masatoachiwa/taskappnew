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
    
            
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
