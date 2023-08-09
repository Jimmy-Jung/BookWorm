//
//  AladinApi.swift
//  BookWorm
//
//  Created by 정준영 on 2023/08/01.
//

import Foundation

enum AladinApi {
    // Sample URL: http://www.aladin.co.kr/ttb/api/ItemList.aspx?ttbkey=[TTBKey]&QueryType=ItemNewAll&MaxResults=10&start=1&SearchTarget=Book&output=xml&Version=20131101
    
    enum Form {
        case xml
        case json
    }
    
    enum Search {
        /// Search
        static let searchRequestURL = "https://www.aladin.co.kr/ttb/api/ItemSearch.aspx?"
        /// 검색키워드: 종류+저자
        static let Keyword = "QueryType=Keyword"
    }
    
    enum List {
        /// List
        static let listRequestURL = "https://www.aladin.co.kr/ttb/api/ItemList.aspx?SearchTarget=Book"
        enum KindOfList: String {
            /// 신간 전체 리스트
            case ItemNewAll = "QueryType=ItemNewAll"
            /// 주목할 만한 신간 리스트
            case ItemNewSpecial = "QueryType=ItemNewSpecial"
            /// 편집자 추천 리스트
            case ItemEditorChoice = "QueryType=ItemEditorChoice"
            /// 베스트셀러 QueryType=Bestseller
            case Bestseller = "QueryType=Bestseller"
            /// 블로거 베스트셀러 (국내도서만 조회 가능)
            case BlogBest = "QueryType=BlogBest"
        }
    }
    /// 썸네일 사이즈
    enum CoverSize: String {
        /// 큰 크기 : 너비 200px
        case big = "Cover=Big"
        /// 중간 큰 크기 : 너비 150px
        case midBig  = "Cover=MidBig"
        /// 중간 크기(기본값) : 너비 85px
        case mid = "Cover=Mid"
        /// 작은 크기 : 너비 75px
        case small = "Cover=Small"
        /// 매우 작은 크기 : 너비 65px
        case mini = "Cover=Mini"
        /// 커버 없음
        case none = "Cover=None"
    }
    /// apiKey
    static let apiKey = Bundle.main.Aladin_Api_Key
    /// 표시할 페이지
    /// - Parameter num: 1000 / resultPerPage 만큼 가능
    static func page(_ num: Int) -> String { return "start=\(num)" }
    /// 검색결과 한 페이지당 갯수 최대 출력 개수 총 1000개 결과값
    /// - Parameter num: 1~50
    static func resultPerPage(_ num: Int) -> String { return "maxResults=\(num)" }
    /// 출력 형식
    /// - Parameter form: xml or json
    /// - Returns: "output=형식"
    static func outPut(_ form: Form) -> String {
        switch form {
        case .xml: return "output=xml"
        case .json: return "output=js"
        }
    }
    /// 검색 Api 버전(기본값: 20070901)
    static let version = "Version=20131101"

}
