//
//  UserDefault.swift
//  BookWorm
//
//  Created by 정준영 on 2023/08/01.
//

import Foundation

@propertyWrapper
/// 유저 디퐅트 커스텀 타입
struct UserDefaultCustomType<T: Codable> {
    private let key: String
    private let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            if let savedData = UserDefaults
                .standard
                .object(forKey: key) as? Data {
                if let loadedObject = try? PropertyListDecoder()
                    .decode(T.self, from: savedData) {
                    return loadedObject
                }
            }
            return defaultValue
        }
        set {
            if let encoded = try? PropertyListEncoder()
                .encode(newValue) {
                UserDefaults.standard.setValue(encoded, forKey: key)
            }
        }
    }
}

struct BookDefaultManager {
    @UserDefaultCustomType(
        key: KeyEnum.favoritesBookList.rawValue,
        defaultValue: []
    )
    static var favoritesBookList: Set<BookInfo>
    
    @UserDefaultCustomType(
        key: KeyEnum.memoBookList.rawValue,
        defaultValue: []
    )
    static var memoBookList: Set<BookInfo>
    
    @UserDefaultCustomType(
        key: KeyEnum.visitedBookList.rawValue,
        defaultValue: []
    )
    static var visitedBookList: [BookInfo]
    
    enum KeyEnum: String {
        case favoritesBookList
        case memoBookList
        case visitedBookList
    }
}


