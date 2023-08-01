//
//  SearchTableViewController.swift
//  BookWorm
//
//  Created by 정준영 on 2023/08/01.
//

import UIKit

final class SearchTableViewController: UITableViewController {
    static let StoryBoardIdentifier = "SearchTableViewController"
    
    private var bookList: [BookInfo] = []
    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier)
        
    }
    
    
}
