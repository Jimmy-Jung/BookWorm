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

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    typealias NetworkResult = Result<AladinResult, NetworkError>
    typealias AS = AladinApi.Search
    typealias AL = AladinApi.List
    
    public func fetchSearchData(
        searchTerm: String,
        resultPerPage max: Int = 50,
        page: Int = 1
    ) async -> NetworkResult {
        var urlString = "\(AS.searchRequestURL)"
        urlString += "Query=\(searchTerm)"
        urlString += "&\(AS.Keyword)"
        urlString += "&\(AladinApi.resultPerPage(max))"
        urlString += "&\(AladinApi.Page(page))"
        urlString += "&\(AladinApi.version)"
        urlString += "&\(AladinApi.apiKey)"
        urlString += "&\(AladinApi.outPut(.json))"
        return await performRequest(with: urlString)
    }
    
    public func fetchListData(
        kindOfList kind: AL.KindOfList,
        resultPerPage max: Int = 50,
        page: Int = 1
    ) async -> NetworkResult {
        var urlString = "\(AS.searchRequestURL)"
        urlString += kind.rawValue
        urlString += "&\(AS.Keyword)"
        urlString += "&\(AladinApi.resultPerPage(max))"
        urlString += "&\(AladinApi.Page(page))"
        urlString += "&\(AladinApi.version)"
        urlString += "&\(AladinApi.apiKey)"
        urlString += "&\(AladinApi.outPut(.json))"
        return await performRequest(with: urlString)
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


