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
    
    var localizedDescription: String {
        switch self {
        case .networkingError:
            return ErrorString.networkingError
        case .dataError:
            return ErrorString.dataError
        case .parseError:
            return ErrorString.parseError
        }
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
}


