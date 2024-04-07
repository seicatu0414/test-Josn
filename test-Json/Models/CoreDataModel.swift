//
//  SourceDataModel.swift
//  test-News-App
//
//  Created by 山口 航平 on 2024/03/18.
//
import CoreData

class CoreDataModel {
    
    /// 指定された名前の永続コンテナを検索しそれを返す
    func searchContainer(containerName:String)->NSPersistentContainer? {
        let container: NSPersistentContainer
        if containerName == "KeepInfo" {
            container = NSPersistentContainer(name: "KeepInfo")
            container.loadPersistentStores(completionHandler: {_,error in
                if (error as NSError?) != nil {
                    fatalError("Keepの失敗")
                }
            })

        } else {
            fatalError("containerNameの間違い")
        }
        return container
    }
    
    /// コンテナからKeepInfoエンティティを読み込みKeepInfoEntityStruct配列群として返す
     func keepInfoRead(containerName:String) -> [CellInfoEntityStruct] {
        guard let container = searchContainer(containerName:containerName) else { return [] }
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<KeepInfo> = KeepInfo.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            return results.map { CellInfoEntityStruct(sectionTitle: $0.sectionTitle,
                                              groupTitle: $0.groupTitle,
                                              hitID: $0.hitID,
                                              hitLabel: $0.hitLabel,
                                              hitType: $0.hitType,
                                              hitFollowersCount: $0.hitFollowersCount)
            }
        } catch {
            fatalError("KeepInfoコンテナの読み込み失敗")
        }
    }
    
    /// 指定されたKeepInfoEntityStructの情報を使用してKeepInfoエンティティを更新、または新規追加
    func keepInfoUpdate(containerName:String, entity:CellInfoEntityStruct) {
        guard let container = searchContainer(containerName:containerName) else { return }
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<KeepInfo> = KeepInfo.fetchRequest()
        guard let hitsID = entity.hitID else { return }
        fetchRequest.predicate = NSPredicate(format: "hitID == %@", hitsID)
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                // 新たに作成
                let newKeepInfo = KeepInfo(context: context)
                newKeepInfo.groupTitle = entity.groupTitle
                newKeepInfo.hitFollowersCount = entity.hitFollowersCount
                newKeepInfo.hitID = entity.hitID
                newKeepInfo.hitLabel = entity.hitLabel
                newKeepInfo.hitType = entity.hitType
                newKeepInfo.sectionTitle = entity.sectionTitle
            } else {
                // 一致した場合更新(状態はViewModelで保持するからいらないかも)
                for result in results {
                    result.groupTitle = entity.groupTitle
                    result.hitFollowersCount = entity.hitFollowersCount
                    result.hitID = entity.hitID
                    result.hitLabel = entity.hitLabel
                    result.hitType = entity.hitType
                    result.sectionTitle = entity.sectionTitle
                }
            }
            try context.save()
        } catch {
            fatalError("更新処理の失敗：更新または新規登録")
        }
    }
    
    /// 指定されたhitsIDと一致する全てのKeepInfoエンティティを削除
    func keepInfoDelete(containerName:String, entity:CellInfoEntityStruct) {
        guard let container = searchContainer(containerName:containerName) else { return }
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<KeepInfo> = KeepInfo.fetchRequest()
        guard let hitsID = entity.hitID else { return }
        fetchRequest.predicate = NSPredicate(format: "hitID == %@", hitsID)
        do {
            let results = try context.fetch(fetchRequest)
            for result in results {
                // 一致した場合削除
                context.delete(result)
            }
            try context.save()
        } catch {
            fatalError("更新処理の失敗；削除")
        }
    }
}
