//
//  AladinSearchResult.swift
//  BookWorm
//
//  Created by 정준영 on 2023/07/31.
//

import Foundation
import UIKit.UIColor

// MARK: - SearchResult
struct AladinResult: Codable {
    let totalResults: Int?
    /// 현재 페이지
    let startIndex: Int?
    let itemsPerPage: Int?
    let item: [BookInfo]?
}

// MARK: - Item
struct BookInfo: Codable, Hashable {
    let title: String?
    let link: String?
    let author: String?
    let description: String?
    let priceSales: Int?
    let priceStandard: Int?
    let cover: String?
    let categoryName: String?
    let publisher: String?
    let customerReviewRank: Int?
    let itemId: Int?
    var backgroundColor: RGB?
    var favorite: Bool? = false
    var visited: Bool? = false
    var memo: String?
    
    static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.itemId == rhs.itemId
        }
    
    func getRGB() -> UIColor {
        guard let BG = backgroundColor else {return UIColor.black}
        
        return UIColor(red: BG.red, green: BG.green, blue: BG.blue, alpha: 1)
    }
    mutating func setColor() { backgroundColor = .init() }
    
    struct RGB: Codable, Hashable {
        let red: CGFloat
        let green: CGFloat
        let blue: CGFloat
        init() {
            self.red = CGFloat.random(in: 0.5...0.9)
            self.green = CGFloat.random(in: 0.5...0.9)
            self.blue = CGFloat.random(in: 0.5...0.9)
        }
    }
}


extension BookInfo {
    init(from realm: RealmBookInfo) {
        title = realm.title
        link = realm.link
        author = realm.author
        description = realm.description
        priceSales = realm.priceSales
        priceStandard = realm.priceStandard
        cover = realm.cover
        categoryName = realm.categoryName
        publisher = realm.publisher
        customerReviewRank = realm.customerReviewRank
        itemId = realm.itemId
        backgroundColor = RGB()
        visited = realm.visited
        favorite = realm.favorite
        memo = realm.memo
    }
    
    func convertToRealm() -> RealmBookInfo {
        return RealmBookInfo(
            title: title,
            link: link,
            author: author,
            description_: description,
            priceSales: priceSales,
            priceStandard: priceStandard,
            cover: cover,
            categoryName: categoryName,
            publisher: publisher,
            customerReviewRank: customerReviewRank,
            itemId: itemId,
            favorite: favorite,
            visited: visited,
            memo: memo
        )
    }
}
