//
//  ViewController.swift
//  taskapp
//
//  Created by アプリ開発 on 2019/06/01.
//  Copyright © 2019 Masato.achiwa. All rights reserved.
//

import UIKit
import RealmSwift  //Realmのインスタンス取得

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate { //プロトコルの追加（約束）
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var searchBar: UISearchBar!  //課題
 
    let realm = try! Realm()  // ←追加　インスタンスの作成
    
    // DB内のタスクが格納されるリスト。
    // 日付近い順\順でソート：降順
    // 以降内容をアップデートするとリスト内は自動的に更新される。
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: false)   //objects(_:)メソッドでクラスを指定しての一覧を取得します。そしてsorted(byKeyPath:ascending:)メソッドでソート（並べ替え）して配列を取り出します。 dateは日付、TaskはTask.swiftのこと falseは降順
    
//    //taskArrayの流れ　　InputViewControllerのtexteField等の文字をRealmのデータベース内Taskに格納
//    InputViewControlleの画面が変わったら、各文字列をViewcontrollerに代入
    
   
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self   //selfとはVieControllerのことt。ableViewはselfに任せて表示データや、挙動を任せる
        tableView.dataSource = self
         searchBar.delegate = self  //課題プロトコル追加必要
    }
    
    // segue で画面遷移するに呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let inputViewController:InputViewController = segue.destination as! InputViewController
        
        if segue.identifier == "cellSegue" {  //segueのidentifierがcellsegueなら
            let indexPath = self.tableView.indexPathForSelectedRow  //テーブルの選んだ番号を代入します
            inputViewController.task = taskArray[indexPath!.row]   //inputViewContorollerの変数taskにtaslArrayの情報を
        } else {
            let task = Task()
            task.date = Date()
            
            let allTasks = realm.objects(Task.self)
            if allTasks.count != 0 {
                task.id = allTasks.max(ofProperty: "id")! + 1
            }
            
            inputViewController.task = task
        }
    }
    // 入力画面から戻ってきた時に TableView を更新させる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //------------------課題追加コード-----------------------------------------------
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            taskArray = realm.objects(Task.self)
        } else {
            taskArray = realm
                .objects(Task.self)
                .filter("category BEGINSWITH %@", searchText)
        }
          print("こんにちは")
        tableView.reloadData()
    }
  
    //--------------------課題追加コード----------------------------------------------
    
    
    //func numberOfSections(in tableView: UITableView) -> Int {  削除
    //    return 2
   // }
    
    // MARK: UITableViewDataSourceプロトコルのメソッド ~~~~~~~~~~~~~~~~~~~~~~~~~~
    // データの数（＝セルの数）を返すメソッド　　テーブル何に何行並べるかを返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count  // taskArray.の数分だけセルを返す
    }
    
    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    // 再利用可能な cell を得る~~~~~~~~~~~~~~ここまで~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
        
        // Cellに値を設定する.  --- ここから -------------------------------------------
        let task = taskArray[indexPath.row]      //taskにtaskArryの列番号の情報を打ち込む
        cell.textLabel?.text = task.title           //cellのテキストラベルにtaskの文字を打ち込む。　　taskにセルの情報を入れて、それをcellに入れる感じ
        
        let formatter = DateFormatter()      //formatterにDateFormatterの情報を入れる
        formatter.dateFormat = "yyyy-MM-dd HH:mm"  //formatter. のフォーマットを決めた
        
        let dateString:String = formatter.string(from: task.date)    //dateStringにformatterの情報を文字列型で入れる（task.のdate情報からから）
        cell.detailTextLabel?.text = dateString
        // --- ここまで追加 -----------------------------------------------------------
        
        
        return cell
    }
    
    // MARK: UITableViewDelegateプロトコルのメソッド~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // 各セルを選択した時に実行されるメソッド「tableView(_:didSelectRowAt:)」
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue",sender: nil)
        // ↑追加する（segueのID、cellSegueを指定して画面遷移
    }
    
    // セルが削除が可能なことを伝えるメソッド「tableView(_:editingStyleForRowAt:)」
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // Delete ボタンが押された時に呼ばれるメソッド　「tableView(_:commit:forRowAt:)」
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ここまで~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     
        
        // --- ここから ---
        if editingStyle == .delete {   //editinStyleって何？
            // データベースから削除する
            try! realm.write {     //エラーが発生する可能性のある処理　
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } // --- ここまで追加 ---
        
        
        
    }
    
    
}
