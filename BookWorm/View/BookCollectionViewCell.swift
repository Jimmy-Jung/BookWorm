//
//  BookCollectionViewCell.swift
//  BookWorm
//
//  Created by 정준영 on 2023/07/31.
//

import UIKit

final class BookCollectionViewCell: UICollectionViewCell {
    static let identifier = "BookCollectionViewCell"
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backView.layer.cornerRadius = 10
        backView.clipsToBounds = true
        
        coverImageView.layer.cornerRadius = 5
        coverImageView.clipsToBounds = true
    }

    
}
