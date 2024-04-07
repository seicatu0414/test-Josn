//
//  GroupSectionHeader.swift
//  test-News-App
//
//  Created by yamaguchi kohei on 2024/03/24.
//

import UIKit

class GroupSectionHeader: UICollectionReusableView {

    @IBOutlet weak var groupLabel: UILabel!
    static let reuseIdentifer = "GroupSectionHeader"
    // headerのラベルに構造体からテキストを挿入
    func setText(sectionIndex: Int, groupIndexl:Int, sectionsStructs: [SectionStruct]?) {
        guard let sectionsStructs = sectionsStructs else { return }
        self.groupLabel.text = sectionsStructs[sectionIndex].groups[groupIndexl].title
    }
}
