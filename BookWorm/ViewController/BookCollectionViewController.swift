//
//  ViewController.swift
//  BookWorm
//
//  Created by 정준영 on 2023/07/31.
//

import UIKit
import RealmSwift

final class BookCollectionViewController: UICollectionViewController {
    private let navTitle = "책 검색(Prefetch)"
    private let sectionHeaderTitle = "베스트 셀러(ScrollView Offset)"
    
    private var bookList: [BookInfo] = []
    private let networkManager = AladinAPIService.shared
    private var cellSize: CGFloat = 0
    private var page: Int = 1
    
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configCollectionView()
        setupSearchController()
        Task { await fetchBookList() }
        print(realm.configuration.fileURL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    private func setupSearchController() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: SearchTableViewController.identifier) as! SearchTableViewController
        let searchVC = UISearchController(searchResultsController: vc)
        let searchController = searchVC
        // 🍎 2) 서치(결과)컨트롤러의 사용 (복잡한 구현 가능)
        //     ==> 글자마다 검색 기능 + 새로운 화면을 보여주는 것도 가능
        searchController.searchResultsUpdater = self
        
        // 첫글자 대문자 설정 없애기
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.placeholder = "책 제목 또는 저자를 입력하세요."
        searchController.hidesNavigationBarDuringPresentation = false
        self.navigationItem.searchController = searchController
        self.navigationItem.title = navTitle
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func fetchBookList() async {
        let list = await networkManager.fetchListData(resultPerPage: 12, page: page)
        
        switch list {
        case .success(let result):
            guard let items = result.item else {return}
            let coloredItems = makeRGB(items)
            self.page += 1
            bookList.append(contentsOf: coloredItems)
        case .failure(let error):
            bookList = []
            self.showCancelAlert(
                title: "불러오기 실패!!",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
        }
        collectionView.reloadData()
    }
    
    private func makeRGB(_ bookList: [BookInfo]) -> [BookInfo] {
        let items = bookList.map {
            var book = $0
            book.setColor()
            return book
        }
        return items
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: BookCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
    }
    
    private func configCollectionView() {
        let layout = UICollectionViewFlowLayout(numberOfRows: 2, itemRatio: 1, spacing: 8, inset: .init(top: 10, left: 10, bottom: 10, right: 10), scrollDirection: .vertical)
        collectionView.collectionViewLayout = layout
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return bookList.count
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath
            ) as! BookCollectionViewCell
        cell.bookInfo = bookList[indexPath.item]
        cell.size = cellSize
        cell.storeButton.tag = indexPath.item
        cell.storeButton
            .addTarget(self, action: #selector(storeButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc private func storeButtonTapped(_ sender: UIButton) {
        let bookInfo = bookList[sender.tag]
        let itemId = bookInfo.itemId
        let cell = collectionView.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as! BookCollectionViewCell
        guard let image = cell.coverImageView.image else { return }
        let task = bookInfo.convertToRealm()
        let realmBookList = realm.objects(RealmBookInfo.self)
        let storedBookInfo = realmBookList.where { query in
            query.itemId == bookInfo.itemId
        }.first
        // realm에 데이터가 있고, 저장 버튼 눌린경우 realm에서 제거
        
        
        if let storedBookInfo {
            switch (storedBookInfo.favorite, storedBookInfo.visited) {
            case (true, true):
                try! realm.write {
                    storedBookInfo.favorite = false
                }
            case (true, false):
                // 사진 제거
                removeImageFromDocument(fileName: imagePath(itemId: itemId))
                // realm에서 제거
                try! realm.write {
                    realm.delete(storedBookInfo)
                }
            case (false, _):
                try! realm.write {
                    storedBookInfo.favorite = true
                }
            }

            // realm에 데이터 없거나, 저장 버튼 안 눌린경우 realm에 추가
        } else {
            // 사진 저장
            saveImageToDocument(fileName: imagePath(itemId: itemId), image: image)
            task.favorite = true
            // realm에 저장
            try! realm.write {
                realm.add(task)
            }
        }
        collectionView.reloadItems(at: [IndexPath(item: sender.tag, section: 0)])
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(
            withIdentifier: DetailViewController.identifier
        ) as! DetailViewController
        vc.bookInfo = bookList[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: BookCollectionReusableView.identifier,
            for: indexPath
        ) as! BookCollectionReusableView
        sectionHeader.sectionHeaderViewLabel.text = sectionHeaderTitle
        return sectionHeader
    }
    
    // 스크롤 끝에 닿으면 API  요청
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > collectionView.contentSize.height - collectionView.bounds.size.height {
            Task{ await fetchBookList() }
        }
    }
}


extension BookCollectionViewController: UISearchResultsUpdating {
    // 유저가 글자를 입력하는 순간마다 호출되는 메서드 ===> 일반적으로 다른 화면을 보여줄때 구현
    func updateSearchResults(for searchController: UISearchController) {
        // 글자를 치는 순간에 다른 화면을 보여주고 싶다면 (컬렉션뷰를 보여줌)
        let vc = searchController.searchResultsController as! SearchTableViewController
        // 컬렉션뷰에 찾으려는 단어 전달
        guard let text = searchController.searchBar.text,
              !text.isEmpty else {return}
        vc.searchTerm = text
        vc.page = 1
    }
}
