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
    public var searchTerm: String? {
        didSet {
            DispatchQueue.main.asyncAfter(
                deadline: DispatchTime.now() + 0.3
            ) { [weak self] in
                Task{ await self?.network() }
            }
        }
    }
    
    private func network() async {
        guard let term = searchTerm else { return }
        // 네트워킹 전에 배열 비우기
        bookList = []
        let list = await networkManager.fetchSearchData(searchTerm: term)
        switch list {
        case .success(let result):
            guard let items = result.item else {return}
            bookList = items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        case .failure(let error):
            if error == .urlError {
                print(error.localizedDescription)
            } else {
                self.showCancelAlert(
                    title: "불러오기 실패!!",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
            }
        }
    }
    
    private func setupTableView() {
        tableView.rowHeight = 135
        let identifier = SearchTableViewCell.identifier
        let nib = UINib(nibName: identifier , bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as! SearchTableViewCell
        cell.bookInfo = bookList[indexPath.row]
        return cell
    }
    
}
