//
//  ViewController.swift
//  BookWorm
//
//  Created by 정준영 on 2023/07/31.
//

import UIKit

final class BookCollectionViewController: UICollectionViewController {
    static let storyBoardIdentifier = "BookCollectionViewController"
    private let cellIdentifier = BookCollectionViewCell.identifier
    
    private var bookList: [BookInfo] = []
    private let networkManager = NetworkManager.shared
    private var cellSize: CGFloat = 0
//    private var pageCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configCollectionView()
        setupSearchController()
        Task { await fetchBookList() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    private func setupSearchController() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: SearchTableViewController.StoryBoardIdentifier) as! SearchTableViewController
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
        self.navigationItem.title = "책 검색"
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func fetchBookList() async {
        let list = await networkManager.fetchListData()
        
        switch list {
        case .success(let result):
            guard let items = result.item else {return}
            let coloredItems = makeRGB(items)
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
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    private func configCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let spacing:CGFloat = 8
        let width = UIScreen.main.bounds.width - (spacing * 3)
        cellSize = width/2
        layout.itemSize = CGSize(width: width/2, height: width/2)
        layout.sectionInset = UIEdgeInsets(
            top: spacing,
            left: spacing,
            bottom: spacing,
            right: spacing
        )
        collectionView.collectionViewLayout = layout
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.scrollDirection = .vertical
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
                withReuseIdentifier: cellIdentifier, for: indexPath
            ) as! BookCollectionViewCell
        cell.bookInfo = bookList[indexPath.item]
        cell.size = cellSize
        cell.storeButton.tag = indexPath.item
        cell.storeButton
            .addTarget(self, action: #selector(storeButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc private func storeButtonTapped(_ sender: UIButton) {
        let isStored = BookDefaultManager.favoritesBookList.contains(bookList[sender.tag])
        if isStored {
            BookDefaultManager.favoritesBookList.remove(bookList[sender.tag])
        } else {
            BookDefaultManager.favoritesBookList.insert(bookList[sender.tag])
        }
        collectionView.reloadItems(at: [IndexPath(item: sender.tag, section: 0)])
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(
            withIdentifier: DetailViewController.StoryBoardIdentifier
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
        sectionHeader.sectionHeaderViewLabel.text = "Best Seller"
        return sectionHeader
    }
    
    /// 스크롤 끝에 닿으면 API  요청
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if self.collectionView.contentOffset.y > collectionView.contentSize.height - collectionView.bounds.size.height {
//            Task{ await fetchBookList() }
//        }
//    }
}

extension BookCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int)
    -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
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
    }
}

