//
//  StoredCollectionViewController.swift
//  BookWorm
//
//  Created by 정준영 on 2023/08/01.
//

import UIKit


final class FavoritesCollectionViewController: UICollectionViewController {
    static let storyBoardIdentifier = "FavoritesCollectionViewController"
    private let cellIdentifier = BookCollectionViewCell.identifier
    
    private var bookList: [BookInfo] = []
    private var cellSize: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configCollectionView()
        setBookList()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBookList()
    }
    
    private func setBookList() {
        let bookArray = Array(BookDefaultManager.favoritesBookList)
        bookList = bookArray.sorted {
            $0.title?.first ?? "a" < $1.title?.first ?? "a"
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
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellIdentifier, for: indexPath
        ) as! BookCollectionViewCell
        cell.bookInfo = bookList[indexPath.item]
        cell.size = cellSize
        cell.storeButton.tag = indexPath.item
        cell.storeButton.addTarget(
            self,
            action: #selector(storeButtonTapped(_:)),
            for: .touchUpInside
        )
        return cell
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
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    @objc private func storeButtonTapped(_ sender: UIButton) {
        let isStored = BookDefaultManager.favoritesBookList.contains(bookList[sender.tag])
        if isStored {
            BookDefaultManager.favoritesBookList.remove(bookList[sender.tag])
        } else {
            BookDefaultManager.favoritesBookList.insert(bookList[sender.tag])
        }
        setBookList()
    }
}
