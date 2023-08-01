//
//  Bundle+Extension.swift
//  BookWorm
//
//  Created by 정준영 on 2023/08/01.
//

import Foundation

extension Bundle {
    
    // 생성한 .plist 파일 경로 불러오기
    var Aladin_Api_Key: String {
        guard let file = self.path(forResource: "Property List", ofType: "plist") else { return "" }
        
        // .plist를 딕셔너리로 받아오기
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        // 딕셔너리에서 값 찾기
        guard let key = resource["Aladin_Api_Key"] as? String else {
            fatalError("Aladin_Api_Key error")
        }
        return key
    }
}
