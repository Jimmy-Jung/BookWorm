//
//  ViewController.swift
//  BookWorm
//
//  Created by 정준영 on 2023/07/31.
//

import UIKit
import Kingfisher

final class BookCollectionViewController: UICollectionViewController {
    static let storyBoardIdentifier = "BookCollectionViewController"
    private let cellIdentifier = BookCollectionViewCell.identifier
    
    private var bookList: [BookList] = []
    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configCollectionView()
        print("11")
        Task { await fetchBookList() }
    }
    
    private func fetchBookList() async {
        let list = await networkManager.fetchListData()
        switch list {
        case .success(let result):
            guard let items = result.item else {return}
            bookList = items
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
        let inset: CGFloat = 20
        let spacing: CGFloat = 8
        let width = UIScreen.main.bounds.width - (spacing + inset*2 )
        layout.itemSize = CGSize(width: width/2, height: width/2)
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = inset
        collectionView.collectionViewLayout = layout
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! BookCollectionViewCell
        let title = bookList[indexPath.item].title ?? "책 이름"
        let rank = bookList[indexPath.item].customerReviewRank ?? 0
        let imageUrl = bookList[indexPath.item].cover ?? ""
        let url = URL(string: imageUrl)
        cell.titleLabel.text = title
        cell.rankLabel.text = "\(rank)/10"
        if url != nil {
            cell.coverImageView.kf.setImage(with: url)
        } else {
            cell.coverImageView.image = UIImage(named: ImageString.defaultBookCover)
        }
        
        return cell
    }

}

