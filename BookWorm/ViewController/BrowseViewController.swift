//
//  BrowseViewController.swift
//  BookWorm
//
//  Created by 정준영 on 2023/08/02.
//

import UIKit
import SnapKit

final class BrowseViewController: UIViewController {
    @IBOutlet weak var collectionViewHeaderTitleLabel: UILabel!
    @IBOutlet weak var browseCollectionView: UICollectionView!
    @IBOutlet weak var browseTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configureCollectionView()
        setupTableView()
    }
    private func setupCollectionView() {
        let collectionViewCellNib = UINib(nibName: BrowseCollectionViewCell.identifier, bundle: nil)
        browseCollectionView.register(collectionViewCellNib, forCellWithReuseIdentifier: BrowseCollectionViewCell.identifier)
        browseCollectionView.delegate = self
        browseCollectionView.dataSource = self
    }
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 85, height: 120)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        browseCollectionView.collectionViewLayout = layout
    }
    
    
    private func setupTableView() {
        let tableViewCellNib = UINib(nibName: SearchTableViewCell.identifier, bundle: nil)
        browseTableView.register(tableViewCellNib, forCellReuseIdentifier: SearchTableViewCell.identifier)
        browseTableView.delegate = self
        browseTableView.dataSource = self
        browseTableView.tableHeaderView?.frame.size.height = 160
    }


}
// MARK: - CollectionView
extension BrowseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrowseCollectionViewCell.identifier, for: indexPath) as! BrowseCollectionViewCell
        return cell
    }
}

// MARK: - TableView
extension BrowseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as! SearchTableViewCell
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let backView = UIView()
        let label = UILabel()
        label.text = "요즘 인기 작품"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        
        backView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(8)
        }
        
        return backView
    }
}


