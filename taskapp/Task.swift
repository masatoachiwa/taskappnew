//
//  Task.swift
//  taskapp
//
//  Created by アプリ開発 on 2019/06/03.
//  Copyright © 2019 Masato.achiwa. All rights reserved.
//

import RealmSwift

class Task: Object {
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = 0
    
    // タイトル
    @objc dynamic var title = ""
    
    // 内容
    @objc dynamic var contents = ""
    
    /// 日時
    @objc dynamic var date = Date()
    
  ///カテゴリー
  @objc dynamic var category = ""
 
    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }
}
