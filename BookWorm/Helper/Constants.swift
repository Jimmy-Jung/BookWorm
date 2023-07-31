//
//  Constants.swift
//  BookWorm
//
//  Created by 정준영 on 2023/07/31.
//

import Foundation

public enum ErrorString {
    static let networkingError = "네트워킹에 문제가 있습니다."
    static let dataError = "데이터를 불러오는데 문제가 발생했습니다."
    static let parseError = "데이터를 분석하는데 문제가 발생했습니다."
    static let urlError = "url주소가 잘못됐습니다."
    static let serverResponseError = "서버에서 데이터를 받아오는데 문제가 발생했습니다."
}

public enum AladinApi {
    // Sample URL: http://www.aladin.co.kr/ttb/api/ItemList.aspx?ttbkey=[TTBKey]&QueryType=ItemNewAll&MaxResults=10&start=1&SearchTarget=Book&output=xml&Version=20131101
    
    enum Form {
        case xml
        case json
    }
    
    enum Search {
        /// Search
        static let searchRequestURL = "http://www.aladin.co.kr/ttb/api/ItemSearch.aspx?"
        /// 검색키워드: 종류+저자
        static let Keyword = "QueryType=Keyword"
    }
    
    enum List {
        /// List
        static let listRequestURL = "http://www.aladin.co.kr/ttb/api/ItemList.aspx?"
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
    /// apiKey
    static let apiKey = "ttbjoony30001924001"
    /// 표시할 페이지
    /// - Parameter num: 1000 / resultPerPage 만큼 가능
    static func Page(_ num: Int) -> String { return "start=\(num)" }
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
