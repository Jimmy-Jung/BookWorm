//
//  SearchTableViewController.swift
//  BookWorm
//
//  Created by 정준영 on 2023/08/01.
//

import UIKit
import SafariServices

final class SearchTableViewController: UITableViewController, UITableViewDataSourcePrefetching {
    
    private var bookList: [BookInfo] = []
    private let networkManager = AladinAPIService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    private var networkWorkItem: DispatchWorkItem?
    var page = 1
    var searchTerm: String? {
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
    
    private func network(prefetch: Bool = false) async {
        guard let term = searchTerm else { return }
        let list = await networkManager.fetchSearchData(searchTerm: term, resultPerPage: 10 ,page: page)
        switch list {
        case .success(let result):
            guard let items = result.item else {return}
            if prefetch {
                bookList += items
                self.page += 1
            } else {
                bookList = items
            }
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
        tableView.prefetchDataSource = self
        tableView.rowHeight = 135
        let identifier = SearchTableViewCell.identifier
        let nib = UINib(nibName: identifier , bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchTableViewCell.identifier
        ) as! SearchTableViewCell
        cell.bookInfo = bookList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(
            withIdentifier: DetailViewController.identifier
        ) as! DetailViewController
        vc.bookInfo = bookList[indexPath.item]
        vc.type = .full
        let nv = UINavigationController(rootViewController: vc)
        nv.modalPresentationStyle = .fullScreen
        present(nv, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if bookList.count - 1 == indexPath.row {
                // 이전에 예약된 네트워크 요청을 취소합니다.
                networkWorkItem?.cancel()
                
                // 지연 후 새로운 네트워크 요청을 예약합니다.
                let workItem = DispatchWorkItem { [weak self] in
                    Task { await self?.network(prefetch: true) }
                }
                networkWorkItem = workItem
                DispatchQueue.main.asyncAfter(
                    deadline: DispatchTime.now() + 0.5,
                    execute: workItem
                )
            }
        }
    }
}
