//
//  MainViewControllerViewModel.swift
//  test-News-App
//
//  Created by 山口 航平 on 2024/03/18.
//

import Foundation
import UIKit

class MainViewControllerViewModel {
    var keepInfoEntityStructs:[CellInfoEntityStruct]? = nil
    var apiStruct:APIStruct? = nil
    /// apiStructからsectionに所属する全てのgroupsを返す
    func fetchTopics() async {
        // keepInfoEntityから情報を取得する
        keepInfoEntityStructs = keepInfoRead()
        guard keepInfoEntityStructs != nil else { return }
        await sendMainApi()
    }
    
    /// apiStructからsectionに所属する全てのgroupsを返す
    func returnSectionInAllGroups() ->[GroupStruct] {
        guard let sectionStructs = apiStruct?.sections else { return  [GroupStruct]() }
        var totalGroups = [GroupStruct]()
        for sectionStruct in sectionStructs {
            totalGroups.append(contentsOf:sectionStruct.groups)
        }
        return totalGroups
    }
    /// IndexPathを分解しsectionIndex、groupIndexとして返す
    func returnSectionAndGroupIndex(groupIndex:Int) -> (sectionIndex:Int,groupIndex:Int) {
        guard let sectionStructs = apiStruct?.sections else { return (sectionIndex:0,groupIndex:0) }
        var groupIndex = groupIndex
        for (sectionIndex,sectionStruct) in sectionStructs.enumerated() {
            // groupIndex
            if groupIndex + 1 > sectionStruct.groups.count {
                groupIndex = groupIndex - sectionStruct.groups.count
            } else {
                return (sectionIndex:sectionIndex,groupIndex:groupIndex)
            }
        }
        return (sectionIndex:0,groupIndex:0)
    }
    
    // Cell生成に必要な情報を返す
    func createCellInfoStruct(indexPath: IndexPath) -> CellInfoEntityStruct {
        var cellInfoStruct = CellInfoEntityStruct.init(sectionTitle: "", groupTitle: "", hitID: "", hitLabel: "", hitType: "", hitFollowersCount: "")
        
        let index = returnSectionAndGroupIndex(groupIndex: indexPath.section)
        let sectionTitle = apiStruct?.sections[index.sectionIndex].title
        let groupTitle = apiStruct?.sections[index.sectionIndex].groups[index.groupIndex].title
        guard let hitStruct = apiStruct?.sections[index.sectionIndex].groups[index.groupIndex].hits[indexPath.row] else { return CellInfoEntityStruct.init(sectionTitle: "", groupTitle: "", hitID: "", hitLabel: "", hitType: "", hitFollowersCount: "") }
        cellInfoStruct = CellInfoEntityStruct(sectionTitle: sectionTitle, groupTitle: groupTitle, hitID: hitStruct.id, hitLabel: hitStruct.label, hitType: hitStruct.type, hitFollowersCount: hitStruct.folloersCount)
        return cellInfoStruct
    }
    /// すでにキープしている案件か否かの判定処理
    func isAlreadyKeep(sectionTitle: String?, groupTitle: String?, hitID: String?) -> Bool {
        guard let keepInfoEntityStructs = self.keepInfoEntityStructs else { return false }
        for keepInfoEntityStruct in keepInfoEntityStructs {
            guard let keepSectionTitle = keepInfoEntityStruct.sectionTitle else { return false }
            guard let keepGroupTitle = keepInfoEntityStruct.groupTitle else { return false }
            guard let keepHitID = keepInfoEntityStruct.hitID else { return false }
            if sectionTitle == keepSectionTitle,
               groupTitle == keepGroupTitle,
               hitID == keepHitID {
                return true
            }
        }
        return false
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
    
    func sendMainApi() async {
        do {
            //通信処理
            self.apiStruct = try await APIModel().sendMainApi()
        } catch Errors.castError{
            print("キャスト失敗")
        } catch Errors.decodingError {
            print("デコード失敗")
        } catch Errors.networkError(let statusCode) {
            print("通信失敗:ステータスコード\(statusCode)")
        } catch {
            print("不明なエラー")
        }

    }
}

