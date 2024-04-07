//
//  FollowListViewControllerViewModel.swift
//  test-News-App
//
//  Created by 山口 航平 on 2024/03/21.
//

import Foundation

class FollowListViewControllerViewModel {
    /// keepしている情報を保持している構造体
    var keepInfoEntityStructs:[CellInfoEntityStruct]? = nil
    
    init() {
        // keepInfoEntityから情報を取得する
        keepInfoEntityStructs = keepInfoRead()
        // 配列を逆転させる
        keepInfoEntityStructs = keepInfoEntityStructs?.reversed()
    }
    ///　KeepInfoエンティティから情報を読み出す
    func keepInfoRead() -> [CellInfoEntityStruct] {
        CoreDataModel().keepInfoRead(containerName: "KeepInfo")
    }
    
    /// KeepInfoエンティティから情報を削除する
    func keepInfoDelete(cellInfo:CellInfoEntityStruct) {
        CoreDataModel().keepInfoDelete(containerName:"KeepInfo", entity: cellInfo)
    }
    /// KeepInfoエンティティに情報を書き込む
    func keepInfoWrite(cellInfo:CellInfoEntityStruct) {
        CoreDataModel().keepInfoUpdate(containerName: "KeepInfo", entity: cellInfo)
    }
    
}
