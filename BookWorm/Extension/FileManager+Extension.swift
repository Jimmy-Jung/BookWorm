//
//  FileManager+Extension.swift
//  PhotoGramRealm
//
//  Created by 정준영 on 2023/09/05.
//

import UIKit

extension UIViewController {
    var fileName_BookWorm: String {
        return "BookWorm"
    }
    /// 도큐먼트 폴더에서 이미지를 가져오는 메서드
    func removeImageFromDocument(fileName: String) {
        // 1. 도큐먼트 경로 찾기
        guard let documentDirectory = FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first
        else { return }
        
        // 2. 삭제할 경로 설정(세부 경로, 이미지가 저장되어 있는 위치)
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error {
            print("file remove error: ", error)
        }
    }
    
    /// 도큐먼트 폴더에서 이미지를 가져오는 메서드
    func loadImageFromDocument(fileName: String) -> UIImage {
        // 1. 도큐먼트 경로 찾기
        guard let documentDirectory = FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first
        else { return UIImage(systemName: "questionmark")!}
        
        // 2. 저장할 경로 설정(세부 경로, 이미지가 저장되어 있는 위치)
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)!
        } else {
            return UIImage(systemName: "questionmark")!
        }
    }
    
    /// 도큐먼트 폴더에 이미지를 저장하는 메서드
    func saveImageToDocument(fileName: String, image: UIImage) {
        // 1. 도큐먼트 경로 찾기
        guard let documentDirectory = FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first
        else { return }
        
        // 2. 저장할 경로 설정(세부 경로, 이미지를 저장할 위치)
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        // 3. 이미지 변환
        // jpg는 압축률 정할 수 있음
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        // 4. 이미지 저장
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("file save error: ", error)
        }
    }
}
