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
    
    private var bookList: [BookList] = []
    private let networkManager = NetworkManager.shared
    private var cellSize: CGFloat = 0
    private var pageCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configCollectionView()
        Task { await fetchBookList() }
    }
    
    private func fetchBookList() async {
        let list = await networkManager.fetchListData(page: pageCount)
        
        switch list {
        case .success(let result):
            guard let items = result.item else {return}
            bookList.append(contentsOf: items)
            pageCount += 1
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
    
    private func setupCollectionView() {
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    private func configCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let spacing:CGFloat = 8
        // 이게 아이폰에서 디바이스 넓이를 가지고올수있는 코드
        let width = UIScreen.main.bounds.width - (spacing * 3)
        cellSize = width/2
        layout.itemSize = CGSize(width: width/2, height: width/2)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        collectionView.collectionViewLayout = layout
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! BookCollectionViewCell
        cell.configureCell(from: bookList[indexPath.item])
        cell.size = cellSize
        return cell
    }
    
    /// 스크롤 끝에 닿으면 API  요청
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.collectionView.contentOffset.y > collectionView.contentSize.height - collectionView.bounds.size.height {
            Task{ await fetchBookList() }
        }
    }
}

