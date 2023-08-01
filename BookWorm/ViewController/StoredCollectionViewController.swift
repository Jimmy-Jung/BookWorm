//
//  StoredCollectionViewController.swift
//  BookWorm
//
//  Created by 정준영 on 2023/08/01.
//

import UIKit


class StoredCollectionViewController: UICollectionViewController {
    static let storyBoardIdentifier = "StoredCollectionViewController"
    private let cellIdentifier = BookCollectionViewCell.identifier
    
    private var bookList: [BookInfo] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
