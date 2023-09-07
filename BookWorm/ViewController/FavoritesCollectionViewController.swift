//
//  StoredCollectionViewController.swift
//  BookWorm
//
//  Created by 정준영 on 2023/08/01.
//

import UIKit
import RealmSwift

final class FavoritesCollectionViewController: UICollectionViewController {
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
        bookList = realm.objects(RealmBookInfo.self).where({
            $0.favorite == true
        }).sorted(byKeyPath: "title", ascending: true)
        
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: BookCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
    }
    
    private func configCollectionView() {
        let layout = UICollectionViewFlowLayout(numberOfRows: 2, itemRatio: 1, spacing: 10, inset: .init(top: 10, left: 10, bottom: 10, right: 10), scrollDirection: .vertical)
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
            withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath
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
            withIdentifier: DetailViewController.identifier
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
