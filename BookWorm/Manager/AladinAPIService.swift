//
//  NetworkManager.swift
//  BookWorm
//
//  Created by 정준영 on 2023/07/31.
//

import Foundation

enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
    case urlError
    case serverResponseError
    
    var localizedDescription: String {
        switch self {
        case .networkingError:
            return ErrorString.networkingError
        case .dataError:
            return ErrorString.dataError
        case .parseError:
            return ErrorString.parseError
        case .urlError:
            return ErrorString.urlError
        case .serverResponseError:
            return ErrorString.serverResponseError
        }
    }
}

final class AladinAPIService {
    static let shared = AladinAPIService()
    private init() {}
    
    typealias NetworkResult = Result<AladinResult, NetworkError>
    typealias AS = AladinApi.Search
    typealias AL = AladinApi.List
    
    /// 검색하기
    /// - Parameters:
    ///   - searchTerm: 검색어
    ///   - max: 페이지 당 갯수(디폴트값: 20개)
    ///   - page: 현재 페이지(디폴트값: 1)
    ///   - coverSize: 이미지 사이즈(중간 크기(기본값) : 너비 85px)
    /// - Returns: Result<AladinResult, NetworkError>
    func fetchSearchData(
        searchTerm: String,
        resultPerPage max: Int = 20,
        page: Int = 1,
        coverSize: AladinApi.CoverSize = .midBig
    ) async -> NetworkResult {
        var urlString = "\(AS.searchRequestURL)"
        urlString += "&Query=\(searchTerm)"
        urlString += "&\(AS.Keyword)"
        urlString += "&\(AladinApi.resultPerPage(max))"
        urlString += "&\(AladinApi.page(page))"
        urlString += "&\(AladinApi.version)"
        urlString += "&\(coverSize.rawValue)"
        urlString += "&\(AladinApi.apiKey)"
        guard let encodedUrlString = urlString
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else { return .failure(.urlError) }
        return await performRequest(with: encodedUrlString)
    }
    
    /// 리스트 가져오기
    /// - Parameters:
    ///   - kind: 리스트 종류(디폴트값 : 베스트셀러)
    ///   - max: 페이지 당 갯수(디폴트값: 50개)
    ///   - page: 현재 페이지(디폴트값: 1)
    ///   - coverSize: 이미지 사이즈(중간 크기(기본값) : 너비 85px)
    /// - Returns: Result<AladinResult, NetworkError>
    func fetchListData(
        kindOfList kind: AL.KindOfList = .Bestseller,
        resultPerPage max: Int = 50,
        page: Int = 1,
        coverSize: AladinApi.CoverSize = .midBig
    ) async -> NetworkResult {
        var urlString = "\(AL.listRequestURL)"
        urlString += "&\(kind.rawValue)"
        urlString += "&\(AladinApi.resultPerPage(max))"
        urlString += "&\(AladinApi.page(page))"
        urlString += "&\(AladinApi.version)"
        urlString += "&\(coverSize.rawValue)"
        urlString += "&\(AladinApi.apiKey)"
        urlString += "&\(AladinApi.outPut(.json))"
        guard let encodedUrlString = urlString
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else { return .failure(.urlError) }
        return await performRequest(with: encodedUrlString)
    }
    
    private func performRequest(with urlString: String) async -> NetworkResult {
        do {
            guard let url = URL(string: urlString) else {return .failure(.urlError)}
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                return .failure(.serverResponseError)
            }
            return parseJSON(data)
        } catch {
            return .failure(.dataError)
        }
    }
    
    private func parseJSON(_ aladinData: Data) -> NetworkResult {
        do {
            let aladinData = try JSONDecoder().decode(AladinResult.self, from: aladinData)
            return .success(aladinData)
        } catch {
            return .failure(.parseError)
        }
    }
    
    
    
    
    
}


