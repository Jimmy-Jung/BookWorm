//
//  DetailViewController.swift
//  BookWorm
//
//  Created by 정준영 on 2023/08/01.
//

import UIKit
import SafariServices

enum PresentType {
    case full
    case nav
}
protocol Present {
    func makeCloseButton()
}

final class DetailViewController: UIViewController, Present {
    static let StoryBoardIdentifier = "DetailViewController"
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet var starCollection: [UIImageView]!
    @IBOutlet weak var customerReviewRankLabel: UILabel!
    @IBOutlet weak var priceStandard: UILabel!
    @IBOutlet weak var priceSales: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var memoTextView: UITextView!
    var bookInfo: BookInfo!
    var type: PresentType?
    let placeholderText = "텍스트를 입력하세요."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "상세 설명"
        fetchMemo()
        configContent()
        makeCloseButton()
        configDescription()
        keyboardNotification()
        visitCheck()
        memoTextView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !memoTextView.text.isEmpty {
            bookInfo.memo = memoTextView.text
            BookDefaultManager.memoBookList.insert(bookInfo)
        }
    }
    private func fetchMemo() {
        BookDefaultManager.memoBookList.forEach { book in
            if book == bookInfo {
                bookInfo.memo = book.memo
            }
        }
    }
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        if descriptionLabel.countCurrentLines() > 5 {
            descriptionLabel.numberOfLines = 8
            sender.isHidden = true
        }
    }
    
    @IBAction func buyButtonTapped(_ sender: UIButton) {
        guard let urlString = bookInfo.link else {
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
    }
    private func visitCheck() {
        if !BookDefaultManager.visitedBookList.contains(bookInfo) {
            BookDefaultManager.visitedBookList.insert(bookInfo, at: 0)
        }
        
    }
    private func configDescription() {
        descriptionLabel.numberOfLines = 5
        if descriptionLabel.countCurrentLines() <= 5 {
            moreButton.isHidden = true
        }
        
    }
    func makeCloseButton() {
        switch type {
        case .full:
            let xmark = UIImage(systemName: "xmark")
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: xmark, style: .plain, target: self, action: #selector(closeButtonTapped))
            navigationItem.leftBarButtonItem?.tintColor = .black
        case .nav:
            break
        case .none:
            break
        }
    }
    @objc func closeButtonTapped() {
        dismiss(animated: true)
    }
    private func configContent() {
        let category = bookInfo.categoryName ?? "카테고리"
        let title = bookInfo.title ?? "책 이름"
        let autor = bookInfo.author ?? "저자"
        let rank = bookInfo.customerReviewRank ?? 0
        let priceSD = bookInfo.priceStandard ?? 0
        let priceSL = bookInfo.priceSales ?? 0
        let description = bookInfo.description?.count == 0 ? "설명 없음" : (bookInfo.description ?? "설명")
        let memo = bookInfo.memo ?? placeholderText
        categoryNameLabel.text = category
        titleLabel.text = title
        authorLabel.text = autor
        customerReviewRankLabel.text = "(\(rank))"
        priceStandard.text = makePriceString(price: priceSD) + "→"
        priceSales.text = makePriceString(price: priceSL)
        descriptionLabel.text = description
        memoTextView.text = memo
        if memo == placeholderText {
            memoTextView.textColor = .lightGray
        } else {
            memoTextView.textColor = .label
        }
        configImage()
        starCollection.forEach {
            $0.image = UIImage(systemName: "star")
        }
        configStar(rank: rank)
    }
    
    private func makePriceString(price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: price))! + "원"
    }
    
    private func configStar(rank: Int) {
        let filledStar = UIImage(systemName: "star.fill")
        let halfFilledStar = UIImage(systemName: "star.lefthalf.fill")
        let halfRank = rank / 2
        if halfRank > 5 {
            return
        }
        for i in 0..<halfRank {
            starCollection[i].image = filledStar
        }
        if rank % 2 != 0 {
            starCollection[halfRank].image = halfFilledStar
        }
    }
    
    private func configImage() {
        let imageUrl = bookInfo.cover ?? ""
        let url = URL(string: imageUrl)
        if url != nil {
            coverImageView.kf.setImage(with: url)
        } else {
            coverImageView.image = UIImage(named: ImageString.defaultBookCover)
        }
    }


}

extension DetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
        }
        textView.textColor = .label
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      if (text == "\n") {
        textView.resignFirstResponder()
      } else {
      }
      return true
    }
}

extension DetailViewController {
    /// 키보드 노티피케이션 등록
    private func keyboardNotification() {
        // 키보드 올라올 때 알림 등록
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        // 키보드 내려갈 때 알림 등록
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // MARK: - @objc Method
    /// 키보드 올라갈때 호출 메서드
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification
            .userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        // 신조어 화면 높이 조정 및애니메이션 추가
        UIView.animate(withDuration: notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25) {
            self.view.bounds.origin.y = keyboardFrame.height - 90
            self.view.layoutIfNeeded()
        }
    }
    
    /// 키보드 내려갈때 호출 메서드
    @objc func keyboardWillHide(_ notification: Notification) {
        // 신조어 화면 높이 조정 및애니메이션 추가
        UIView.animate(withDuration: notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25) {
            self.view.bounds.origin.y = 0
            self.view.layoutIfNeeded()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
