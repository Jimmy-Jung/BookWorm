//
//  StoredCollectionViewController.swift
//  BookWorm
//
//  Created by 정준영 on 2023/08/01.
//

import UIKit
import RealmSwift

final class FavoritesCollectionViewController: UICollectionViewController {
    static let storyBoardIdentifier = "FavoritesCollectionViewController"
    private let cellIdentifier = BookCollectionViewCell.identifier
    private var bookList: Results<RealmBookInfo>!
    private var cellSize: CGFloat = 0
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configCollectionView()
        getBookList()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    private func getBookList() {
        bookList = realm.objects(RealmBookInfo.self).sorted(byKeyPath: "title", ascending: true)
        
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
        cell.bookInfo = BookInfo.init(from: bookList[indexPath.item])
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
        collectionView.deselectItem(at: indexPath, animated: true)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(
            withIdentifier: DetailViewController.StoryBoardIdentifier
        ) as! DetailViewController
        vc.bookInfo = BookInfo.init(from: bookList[indexPath.item])
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc private func storeButtonTapped(_ sender: UIButton) {
        let task = bookList[sender.tag]
        try! realm.write {
            realm.delete(task)
        }
        collectionView.deleteItems(at: [IndexPath(item: sender.tag, section: 0)])
    }
}
