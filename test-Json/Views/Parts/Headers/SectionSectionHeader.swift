//
//  SectionSectionHeader.swift
//  test-News-App
//
//  Created by yamaguchi kohei on 2024/03/24.
//


import UIKit

class SectionSectionHeader: UICollectionReusableView {

    @IBOutlet weak var sectionLabel: UILabel!
    static let reuseIdentifer = "SectionSectionHeader"
    // headerのラベルに構造体からテキストを挿入
    func setText(sectionIndex: Int, groupIndexl:Int, sectionsStructs: [SectionStruct]?) {
        guard let sectionsStructs = sectionsStructs else { return }
        self.sectionLabel.text = sectionsStructs[sectionIndex].title
    }
}
