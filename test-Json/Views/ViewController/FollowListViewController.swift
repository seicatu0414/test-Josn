//
//  FollowListViewController.swift
//  test-News-App
//
//  Created by 山口 航平 on 2024/03/21.
//

import UIKit

class FollowListViewController: UIViewController {
    
    @IBOutlet weak var followListCollectonView: UICollectionView!
    
    var viewModel:FollowListViewControllerViewModel = FollowListViewControllerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        followListCollectonView.delegate = self
        followListCollectonView.dataSource = self
        followListCollectonView.register(UINib(nibName: "HitInfoCollectionCell", bundle: nil), forCellWithReuseIdentifier: HitInfoCollectionCell.reuseIdentifer)
        followListCollectonView.collectionViewLayout = {
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
                return section
            }
            return layout
        }()
    }
    
    func followListViewReload() {
        self.viewModel = FollowListViewControllerViewModel()
        followListCollectonView.reloadData()
    }
}

extension FollowListViewController:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let keepInfoEntityStructs = viewModel.keepInfoEntityStructs else { return 0 }
        return keepInfoEntityStructs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let keepInfoStructs = viewModel.keepInfoEntityStructs else { return UICollectionViewCell() }
        let sectionTitle = keepInfoStructs[indexPath.row].sectionTitle
        let groupTitle = keepInfoStructs[indexPath.row].groupTitle
        let hitID = keepInfoStructs[indexPath.row].hitID
        let hitLabel = keepInfoStructs[indexPath.row].hitLabel
        let hitType = keepInfoStructs[indexPath.row].hitType
        let hitFollowersCount = keepInfoStructs[indexPath.row].hitFollowersCount
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HitInfoCollectionCell.reuseIdentifer, for: indexPath) as! HitInfoCollectionCell

        cell.initCell(sectionTitle: sectionTitle,
                      groupTitle: groupTitle,
                      hitID: hitID,
                      hitLabel: hitLabel,
                      hitType: hitType,
                      hitFollowersCount: hitFollowersCount,
                      isKeep: true)
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // groupsの数
        return 1
    }
}

extension FollowListViewController: UICollectionViewDelegate {
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


