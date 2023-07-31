//
//  DetailViewController.swift
//  BookWorm
//
//  Created by 정준영 on 2023/08/01.
//

import UIKit

final class DetailViewController: UIViewController {
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
    public var bookInfo: BookInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configContent()
        title = "상세 설명"
        // Do any additional setup after loading the view.
    }
    private func configContent() {
        let category = bookInfo.categoryName ?? "카테고리"
        let title = bookInfo.title ?? "책 이름"
        let autor = bookInfo.author ?? "저자"
        let rank = bookInfo.customerReviewRank ?? 0
        let priceSD = bookInfo.priceStandard ?? 0
        let priceSL = bookInfo.priceSales ?? 0
        let description = bookInfo.description?.count == 0 ? "설명 없음" : (bookInfo.description ?? "설명")
        
        categoryNameLabel.text = category
        titleLabel.text = title
        authorLabel.text = autor
        customerReviewRankLabel.text = "(\(rank))"
        priceStandard.text = makePriceString(price: priceSD) + "→"
        priceSales.text = makePriceString(price: priceSL)
        descriptionLabel.text = description
        
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
        let emptyStar = UIImage(systemName: "star")
        
        let rankAsFloat = Float(rank)
        let numberOfFullStars = Int(rankAsFloat / 2.0)
        let hasHalfStar = rankAsFloat.truncatingRemainder(dividingBy: 2.0) != 0
        let numberOfEmptyStars = 5 - numberOfFullStars - (hasHalfStar ? 1 : 0)
        
        for i in 0..<numberOfFullStars {
            starCollection[i].image = filledStar
        }
        if (hasHalfStar) {
            starCollection[numberOfFullStars].image = halfFilledStar
        }
        for i in (numberOfFullStars + 1)..<(numberOfFullStars + 1 + numberOfEmptyStars) {
            starCollection[i].image = emptyStar
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