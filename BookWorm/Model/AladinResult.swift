//
//  AladinSearchResult.swift
//  BookWorm
//
//  Created by 정준영 on 2023/07/31.
//

import Foundation

// MARK: - SearchResult
struct AladinResult: Codable {
    let totalResults: Int?
    /// 현재 페이지
    let startIndex: Int?
    let itemsPerPage: Int?
    let item: [BookInfo]?
}

// MARK: - Item
struct BookInfo: Codable {
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
}
