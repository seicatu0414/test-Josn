
//  CollectionCard.swift
//  test-News-App
//
//  Created by 山口 航平 on 2024/03/18.


import Foundation
import UIKit

protocol HitInfoCollectionCellDelegate:AnyObject {
    func tapKeep()
}

class HitInfoCollectionCell: UICollectionViewCell {
    @IBOutlet weak var hitTitleLabel: UILabel!
    @IBOutlet weak var followersCntLabel: UILabel!
    @IBOutlet weak var keepImageView: UIImageView!
    
    static let reuseIdentifer = "HitInfoCollectionCell"
    var cellInfo:CellInfoEntityStruct!
    var isKeep = false
    
    func initCell(sectionTitle:String?,groupTitle:String?,hitID:String?,hitLabel:String?,hitType:String?,hitFollowersCount:String?,isKeep:Bool){
        let sectionTitle = sectionTitle ?? ""
        let groupTitle = groupTitle ?? ""
        let hitID = hitID ?? ""
        let hitLabel = hitLabel ?? ""
        let hitType = hitType ?? ""
        let hitFollowersCount = hitFollowersCount ?? ""
        let cellInfoEntity = CellInfoEntityStruct(sectionTitle: sectionTitle,
                                                  groupTitle: groupTitle,
                                                  hitID: hitID,
                                                  hitLabel: hitLabel,
                                                  hitType:  hitType,
                                                  hitFollowersCount: hitFollowersCount)
        self.cellInfo = cellInfoEntity
        hitTitleLabel.text = cellInfo.hitLabel
        guard let hitFollowersCount = cellInfo.hitFollowersCount else { return }
        followersCntLabel.text = "\(String(describing: hitFollowersCount))がフォロー"
        self.isKeep = isKeep
        if isKeep {
            keepImageView.image = UIImage(named: "checked")
        } else {
            keepImageView.image = UIImage(named: "unchecked")
        }
        self.layer.cornerRadius = 10
    }
    /// keepの状態の変更
    func changeKeepStatus() -> Bool {
        if isKeep {
            keepImageView.image = UIImage(named: "unchecked")
            self.isKeep = false
            return self.isKeep
        } else {
            keepImageView.image = UIImage(named: "checked")
            self.isKeep = true
            return self.isKeep
        }
    }
}
