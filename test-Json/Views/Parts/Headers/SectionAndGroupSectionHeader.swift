//
//  SectionHeader.swift
//  test-News-App
//
//  Created by 山口 航平 on 2024/03/22.
//

import UIKit

class SectionAndGroupSectionHeader: UICollectionReusableView {

    @IBOutlet weak var sectionLabel: UILabel!    
    @IBOutlet weak var groupLabel: UILabel!
    static let reuseIdentifer = "SectionAndGroupSectionHeader"
    // headerのラベルに構造体からテキストを挿入
    func setText(sectionIndex: Int, groupIndexl:Int, sectionsStructs: [SectionStruct]?) {
        guard let sectionsStructs = sectionsStructs else { return }
        self.sectionLabel.text = sectionsStructs[sectionIndex].title
        self.groupLabel.text = sectionsStructs[sectionIndex].groups[groupIndexl].title
    }
}
