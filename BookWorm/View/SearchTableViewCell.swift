//
//  SearchTableViewCell.swift
//  BookWorm
//
//  Created by 정준영 on 2023/08/01.
//

import UIKit

final class SearchTableViewCell: UITableViewCell {
    static let identifier = "SearchTableViewCell"
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var categoryNameLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private var starCollection: [UIImageView]!
    @IBOutlet private weak var customerReviewRankLabel: UILabel!
    @IBOutlet private weak var priceStandard: UILabel!
    @IBOutlet private weak var priceSales: UILabel!
    
    override func prepareForReuse() {
        categoryNameLabel.text = ""
        titleLabel.text = "데이터 불러오기 실패"
        authorLabel.text = ""
        customerReviewRankLabel.text = ""
        priceStandard.text = ""
        priceSales.text = ""
        coverImageView.image = UIImage(named: ImageString.defaultBookCover)
        starCollection.forEach { $0.image = UIImage(systemName: "star") }
    }

    public var bookInfo: BookInfo? {
        didSet {
            configContent()
            configImage()
            configStar()
        }
    }
    
    private func configContent() {
        guard let bookInfo else {return}
        let category = bookInfo.categoryName ?? "카테고리"
        let title = bookInfo.title ?? "데이터 불러오기 실패"
        let autor = bookInfo.author ?? "저자"
        let rank = bookInfo.customerReviewRank ?? 0
        let priceSD = bookInfo.priceStandard ?? 0
        let priceSL = bookInfo.priceSales ?? 0
        
        categoryNameLabel.text = category
        titleLabel.text = title
        authorLabel.text = autor
        customerReviewRankLabel.text = "(\(rank))"
        priceStandard.text = makePriceString(price: priceSD) + "→"
        priceSales.text = makePriceString(price: priceSL)
    }
    
    private func makePriceString(price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: price))! + "원"
    }

    private func configStar() {
        let rank = bookInfo?.customerReviewRank ?? 0
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
        guard let imageUrl = bookInfo?.cover,
        let url = URL(string: imageUrl) else { return }
        coverImageView.kf.setImage(with: url)
    }
}
