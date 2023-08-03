//
//  SearchTableViewController.swift
//  BookWorm
//
//  Created by 정준영 on 2023/08/01.
//

import UIKit
import SafariServices

final class SearchTableViewController: UITableViewController {
    static let StoryBoardIdentifier = "SearchTableViewController"
    
    private var bookList: [BookInfo] = []
    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    private var networkWorkItem: DispatchWorkItem?

    public var searchTerm: String? {
        didSet {
            // 이전에 예약된 네트워크 요청을 취소합니다.
            networkWorkItem?.cancel()

            // 지연 후 새로운 네트워크 요청을 예약합니다.
            let workItem = DispatchWorkItem { [weak self] in
                Task { await self?.network() }
            }
            networkWorkItem = workItem
            DispatchQueue.main.asyncAfter(
                deadline: DispatchTime.now() + 0.3,
                execute: workItem
            )
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
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return bookList.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchTableViewCell.identifier
        ) as! SearchTableViewCell
        cell.bookInfo = bookList[indexPath.row]
        return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard let urlString = bookList[indexPath.row].link else {
            self.showCancelAlert(
                title: "웹페이지를 열 수 없습니다.",
                message: "주소가 잘못되었습니다. 다시 시도해 주세요.",
                preferredStyle: .alert
            )
            return
        }
        if let url = URL(string: urlString) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
