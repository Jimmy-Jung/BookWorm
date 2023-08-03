//
//  BrowseCollectionViewCell.swift
//  BookWorm
//
//  Created by 정준영 on 2023/08/02.
//

import UIKit
import Kingfisher

final class BrowseCollectionViewCell: UICollectionViewCell {
    static let identifier = "BrowseCollectionViewCell"

    @IBOutlet weak var coverImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = UIImage(named: ImageString.defaultBookCover)
    }

    var bookInfo: BookInfo? {
        didSet { configImage() }
    }
    
    private func configImage() {
        guard let imageUrl = bookInfo?.cover,
        let url = URL(string: imageUrl) else { return }
        coverImageView.kf.setImage(with: url)
    }
}
