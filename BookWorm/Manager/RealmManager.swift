//
//  RealmManager.swift
//  BookWorm
//
//  Created by 정준영 on 2023/09/04.
//

import Foundation
import RealmSwift

struct RealmManager {
    enum RealmPath: String {
        case favoritesBookList
        case memoBookList
        case visitedBookList
    }
    
    static func createRealm(path: RealmPath) -> Realm {
        var config = Realm.Configuration.defaultConfiguration
        config.fileURL!.deleteLastPathComponent()
        config.fileURL!.appendPathComponent(path.rawValue)
        config.fileURL!.appendPathExtension("realm")
        let realm = try! Realm(configuration: config)
        return realm
    }
    
}
