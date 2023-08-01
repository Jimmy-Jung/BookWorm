//
//  BookCollectionViewCell.swift
//  BookWorm
//
//  Created by 정준영 on 2023/07/31.
//

import UIKit
import Kingfisher

final class BookCollectionViewCell: UICollectionViewCell {
    static let identifier = "BookCollectionViewCell"
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    override func prepareForReuse() {
        coverImageView.image = nil
        titleLabel.text = ""
        rankLabel.text = ""
    }
    
    public var size: CGFloat = 100 {
        didSet {
            backView.frame.size = CGSize(width: size, height: size)
        }
    }
    
    public func configureCell(from book: BookInfo) {
        setupLayout()
        let title = book.title ?? "책 이름"
        let rank = book.customerReviewRank ?? 0
        let imageUrl = book.cover ?? ""
        let url = URL(string: imageUrl)
        
        titleLabel.text = title
        rankLabel.text = "\(rank)/10"
        if url != nil {
            coverImageView.kf.setImage(with: url)
        } else {
            coverImageView.image = UIImage(named: ImageString.defaultBookCover)
        }
    }
    private func setupLayout() {
        backView.backgroundColor = UIColor.thinRandom()
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 10
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 10
        
    }

    
}
