//
//  ViewController.swift
//  test-News-App
//
//  Created by 山口 航平 on 2024/03/18.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var viewModel:MainViewControllerViewModel = MainViewControllerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.register(UINib(nibName: "HitInfoCollectionCell", bundle: nil), forCellWithReuseIdentifier: HitInfoCollectionCell.reuseIdentifer)
        mainCollectionView.register(UINib(nibName: "SectionAndGroupSectionHeader", bundle: nil),forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader,withReuseIdentifier: SectionAndGroupSectionHeader.reuseIdentifer)
        mainCollectionView.register(UINib(nibName: "SectionSectionHeader", bundle: nil),forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader,withReuseIdentifier: SectionSectionHeader.reuseIdentifer)
        mainCollectionView.register(UINib(nibName: "GroupSectionHeader", bundle: nil),forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader,withReuseIdentifier: GroupSectionHeader.reuseIdentifer)
        mainCollectionView.collectionViewLayout = {
            let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
                let size: CGFloat = self.view.bounds.width
                let itemWidth = 165.0
                let itemHight = 90.0
                let cell2cellSpace = 20.0
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .absolute(itemHight))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(size), heightDimension: .absolute(itemHight))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                //item間の横のスペースの設定
                group.interItemSpacing = .fixed(cell2cellSpace)
                let section = NSCollectionLayoutSection(group: group)
                let sectionLeading = (self.view.bounds.width - (itemWidth * 2 + cell2cellSpace)) / 2
                
                section.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: sectionLeading, bottom: 0.0, trailing: 0.0)
                //グループ間の高さの設定
                section.interGroupSpacing = 8.0
                let headerHight = 60.0
                let headerSize = NSCollectionLayoutSize(widthDimension: .absolute(size), heightDimension: .estimated(headerHight))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [header]
                return section
            }
            return layout
        }()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainViewReload()
    }
    
    @MainActor
    func mainViewReload() {
        Task {
            await viewModel.fetchTopics()
            self.mainCollectionView.reloadData()
        }
    }
}


extension MainViewController:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 全てのGroupを取得
        let allGroups = viewModel.returnSectionInAllGroups()
        let hitsCnt = allGroups[section].hits.count
        // Groupに所属するhitsの数
        return hitsCnt
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellInfo = viewModel.createCellInfoStruct(indexPath: indexPath)
        let sectionTitle = cellInfo.sectionTitle
        let groupTitle = cellInfo.groupTitle
        let hitID = cellInfo.hitID
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HitInfoCollectionCell.reuseIdentifer, for: indexPath) as! HitInfoCollectionCell
        let isAlreadyKeep = viewModel.isAlreadyKeep(sectionTitle: sectionTitle, groupTitle: groupTitle, hitID: hitID)
        cell.initCell(sectionTitle: sectionTitle,
                      groupTitle: groupTitle,
                      hitID: cellInfo.hitID,
                      hitLabel: cellInfo.hitLabel,
                      hitType: cellInfo.hitType,
                      hitFollowersCount: cellInfo.hitFollowersCount,
                      isKeep: isAlreadyKeep)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionAndGroupIndexPath = viewModel.returnSectionAndGroupIndex(groupIndex: indexPath.section)
            
            //　groupの先頭かつgrouptitleが存在していたら
            if sectionAndGroupIndexPath.groupIndex == 0,viewModel.apiStruct?.sections[sectionAndGroupIndexPath.sectionIndex].groups[sectionAndGroupIndexPath.groupIndex].title == "" {
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionSectionHeader.reuseIdentifer, for: indexPath) as? SectionSectionHeader else {
                   fatalError("Could not find proper header")
               }
                header.setText(sectionIndex: sectionAndGroupIndexPath.sectionIndex,groupIndexl:sectionAndGroupIndexPath.groupIndex, sectionsStructs: viewModel.apiStruct?.sections)
                return header
            } else if sectionAndGroupIndexPath.groupIndex != 0 {
                // groupの先頭ではなかったら
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: GroupSectionHeader.reuseIdentifer, for: indexPath) as? GroupSectionHeader else {
                   fatalError("Could not find proper header")
               }
                header.setText(sectionIndex: sectionAndGroupIndexPath.sectionIndex,groupIndexl:sectionAndGroupIndexPath.groupIndex, sectionsStructs: viewModel.apiStruct?.sections)
                return header
            } else {
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionAndGroupSectionHeader.reuseIdentifer, for: indexPath) as? SectionAndGroupSectionHeader else {
                   fatalError("Could not find proper header")
                }
                header.setText(sectionIndex: sectionAndGroupIndexPath.sectionIndex,groupIndexl:sectionAndGroupIndexPath.groupIndex, sectionsStructs: viewModel.apiStruct?.sections)
                return header
            }
       }

       return UICollectionReusableView()
   }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let sectionsStructs = viewModel.apiStruct?.sections else { return 0}
        var groupsCnt = 0
        for sectionsStruct in sectionsStructs {
            groupsCnt += sectionsStruct.groups.count
        }
        // groupsの数
        return groupsCnt
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? HitInfoCollectionCell {
            let isKeep = cell.changeKeepStatus()
            if isKeep {
                viewModel.keepInfoWrite(cellInfo: cell.cellInfo)
            } else {
                viewModel.keepInfoDelete(cellInfo: cell.cellInfo)
            }
        }
    }
}


