//
//  UICollectionViewFlowLayout+Extension.swift
//  BookWorm
//
//  Created by 정준영 on 2023/09/06.
//

import UIKit.UICollectionViewFlowLayout

extension UICollectionViewFlowLayout {
    /// 이 메서드는 컬렉션 뷰에서 사용할 수 있는 Flow Layout을 커스터마이징합니다.
    /// - Parameters:
    ///   - numberOfRows: 행의 수
    ///   - itemRatio: height / width
    ///   - spacing: 간격
    ///   - inset: 테두리 인셋
    ///   - scrollDirection: 스크롤 방향
    /// - Returns: UICollectionViewFlowLayout
    convenience init(
        numberOfRows: CGFloat,
        itemRatio: CGFloat,
        spacing: CGFloat,
        inset: UIEdgeInsets,
        scrollDirection: UICollectionView.ScrollDirection
    ) {
        self.init()
        let screenWidth = UIScreen.main.bounds.width
        let length = screenWidth - (spacing * (numberOfRows - 1)) - (inset.left + inset.right)
        self.itemSize = CGSize(
            width: length/numberOfRows,
            height: (length/numberOfRows) * itemRatio
        )
        self.sectionInset = inset
        self.minimumInteritemSpacing = spacing
        self.minimumLineSpacing = spacing
        self.scrollDirection = scrollDirection
        
    }
}
