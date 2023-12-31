//
//  BrowseViewController.swift
//  BookWorm
//
//  Created by 정준영 on 2023/08/02.
//

import UIKit
import SnapKit
import RealmSwift

final class BrowseViewController: UIViewController {
    // MARK: - IBOutlet

    @IBOutlet weak var collectionViewHeaderTitleLabel: UILabel!
    @IBOutlet weak var browseCollectionView: UICollectionView!
    @IBOutlet weak var browseTableView: UITableView!
    
    // MARK: - Private Properties
    private var visitedBookList: Results<RealmBookInfo>?
    private var noteworthyBookList: [BookInfo] = []
    private let networkManager = AladinAPIService.shared
    private let visitedBookListHeaderTitle = "최근 본 작품"
    private let noteworthyBookListHeaderTitle = "주목할 만한 신간"
    let realm = try! Realm()
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configureCollectionView()
        setupTableView()
        fetchVisitedBookList()
        Task{ await fetchNoteworthyBookList() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        visitedBookList = BookDefaultManager.visitedBookList
        browseCollectionView.reloadData()
    }
    
    // MARK: - Private Methods
    private func fetchVisitedBookList() {
        visitedBookList = realm.objects(RealmBookInfo.self).where {
            $0.visited == true
        }
        if visitedBookList?.count == 0 {
            browseTableView.tableHeaderView?.frame.size.height = 0
        }
        browseTableView.reloadData()
    }
    
    private func fetchNoteworthyBookList() async {
        let list = await networkManager.fetchListData(kindOfList: .ItemNewSpecial)
        
        switch list {
        case .success(let result):
            guard let items = result.item else {return}
            noteworthyBookList.append(contentsOf: items)
        case .failure(let error):
            noteworthyBookList = []
            self.showCancelAlert(
                title: "불러오기 실패!!",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
        }
        browseTableView.reloadData()
        
    }
    

    private func setupCollectionView() {
        let collectionViewCellNib = UINib(
            nibName: BrowseCollectionViewCell.identifier,
            bundle: nil
        )
        browseCollectionView.register(
            collectionViewCellNib,
            forCellWithReuseIdentifier: BrowseCollectionViewCell.identifier
        )
        browseCollectionView.delegate = self
        browseCollectionView.dataSource = self
        collectionViewHeaderTitleLabel.text = visitedBookListHeaderTitle
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
        browseTableView.register(
            tableViewCellNib,
            forCellReuseIdentifier: SearchTableViewCell.identifier
        )
        browseTableView.delegate = self
        browseTableView.dataSource = self
        browseTableView.tableHeaderView?.frame.size.height = 160
        browseTableView.rowHeight = 135
    }
    
    


}
// MARK: - CollectionView
extension BrowseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return visitedBookList?.count ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BrowseCollectionViewCell.identifier,
            for: indexPath
        ) as! BrowseCollectionViewCell
        guard let visitedBookList else { return cell }
        cell.bookInfo = BookInfo.init(from: visitedBookList[indexPath.item])
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(
            withIdentifier: DetailViewController.identifier
        ) as! DetailViewController
        guard let visitedBookList else { return }
        vc.bookInfo = BookInfo.init(from: visitedBookList[indexPath.item])
  
        navigationController?.pushViewController(vc, animated: true)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - TableView
extension BrowseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteworthyBookList.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchTableViewCell.identifier
        ) as! SearchTableViewCell
        cell.bookInfo = noteworthyBookList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(
            withIdentifier: DetailViewController.identifier
        ) as! DetailViewController
        vc.bookInfo = noteworthyBookList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let backView = UIView()
        backView.backgroundColor = .secondarySystemBackground
        let label = UILabel()
        label.text = noteworthyBookListHeaderTitle
        label.font = .systemFont(ofSize: 17, weight: .bold)
        
        backView.addSubview(label)
        label.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
        return backView
    }
}


