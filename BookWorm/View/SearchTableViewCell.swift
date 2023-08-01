//
//  SearchTableViewCell.swift
//  BookWorm
//
//  Created by 정준영 on 2023/08/01.
//

import UIKit

final class SearchTableViewCell: UITableViewCell {
    static let identifier = "SearchTableViewCell"
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet var starCollection: [UIImageView]!
    @IBOutlet weak var customerReviewRankLabel: UILabel!
    @IBOutlet weak var priceStandard: UILabel!
    @IBOutlet weak var priceSales: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
