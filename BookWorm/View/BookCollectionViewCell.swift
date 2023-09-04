//
//  BookCollectionViewCell.swift
//  BookWorm
//
//  Created by 정준영 on 2023/07/31.
//

import UIKit
import Kingfisher
import RealmSwift

final class BookCollectionViewCell: UICollectionViewCell {
    static let identifier = "BookCollectionViewCell"
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var storeButton: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
        titleLabel.text = "데이터 불러오기 실패"
        rankLabel.text = ""
        coverImageView.image = UIImage(named: ImageString.defaultBookCover)
    }
    
    var size: CGFloat = 100 {
        didSet { backView.frame.size = CGSize(width: size, height: size) }
    }
    
    var bookInfo: BookInfo? {
        didSet {
            configureCell()
            setupLayout()
            configImage()
            compareWithUserDefaults()
        }
    }
    
    private func configureCell() {
        let title = bookInfo?.title ?? "책 이름"
        let rank = bookInfo?.customerReviewRank ?? 0
        titleLabel.text = title
        rankLabel.text = "\(rank)/10"
    }
    
    private func setupLayout() {
        backView.backgroundColor = bookInfo?.getRGB()
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 10
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 10
    }
    
    private func compareWithUserDefaults() {
        let realm = try! Realm()
        let task = realm.objects(AladinBook.self)
        guard let bookInfo else {return}
        let isStored = BookDefaultManager.favoritesBookList.contains(bookInfo)
        let image = isStored ?
        UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        storeButton.setImage(image, for: .normal)
    }
    
    private func configImage() {
        guard let imageUrl = bookInfo?.cover,
        let url = URL(string: imageUrl) else { return }
        coverImageView.kf.setImage(with: url)
    }
}
