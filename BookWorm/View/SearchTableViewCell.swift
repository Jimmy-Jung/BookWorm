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
        titleLabel.text = ""
        authorLabel.text = ""
        customerReviewRankLabel.text = ""
        priceStandard.text = ""
        priceSales.text = ""
        coverImageView.image = nil
        starCollection.forEach {
            $0.image = UIImage(systemName: "star")
        }
    }
    
    public var bookInfo: BookInfo? {
        didSet {
            configContent()
        }
    }
    private func configContent() {
        guard let bookInfo else {return}
        let category = bookInfo.categoryName ?? "카테고리"
        let title = bookInfo.title ?? "책 이름"
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
        
        configImage()
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
        let imageUrl = bookInfo?.cover ?? ""
        let url = URL(string: imageUrl)
        if url != nil {
            coverImageView.kf.setImage(with: url)
        } else {
            coverImageView.image = UIImage(named: ImageString.defaultBookCover)
        }
    }
}
