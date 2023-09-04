//
//  RealmData.swift
//  BookWorm
//
//  Created by 정준영 on 2023/09/04.
//

import Foundation
import RealmSwift

class RealmBookInfo: Object {
    
    @Persisted var title: String?
    @Persisted var link: String?
    @Persisted var author: String?
    @Persisted var description_: String?
    @Persisted var priceSales: Int?
    @Persisted var priceStandard: Int?
    @Persisted var cover: String?
    @Persisted var categoryName: String?
    @Persisted var publisher: String?
    @Persisted var customerReviewRank: Int?
    @Persisted var memo: String?
    
    convenience init(title: String? = nil, link: String? = nil, author: String? = nil, description_: String? = nil, priceSales: Int? = nil, priceStandard: Int? = nil, cover: String? = nil, categoryName: String? = nil, publisher: String? = nil, customerReviewRank: Int? = nil, memo: String? = nil) {
        self.init()
        self.title = title
        self.link = link
        self.author = author
        self.description_ = description_
        self.priceSales = priceSales
        self.priceStandard = priceStandard
        self.cover = cover
        self.categoryName = categoryName
        self.publisher = publisher
        self.customerReviewRank = customerReviewRank
        self.memo = memo
    }
}

