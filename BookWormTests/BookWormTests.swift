//
//  BookWormTests.swift
//  BookWormTests
//
//  Created by 정준영 on 2023/07/31.
//

import XCTest
@testable import BookWorm

final class BookWormTests: XCTestCase {
    
    var sut: AladinAPIService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = AladinAPIService.shared
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testSearchAladin() async throws {
        // given
        let searchTurm = "aladin"
        // when
        let data = await sut.fetchSearchData(searchTerm: searchTurm)
        switch data {
        case .success(let result):
            guard let result = result.item?.first?.title else {
                throw NetworkError.networkingError
            }
            let value = "All About IB Psychology Essay - IB Psychology Essay Guide for SL and HL Students"
            XCTAssertEqual(result, value)
        case .failure(_):
            break
        }
    }
    
    func testListAladin() async throws {
        // given
        
        // when
        let data = await sut.fetchListData()
        switch data {
        case .success(let results):
            guard let result = results.item?.first?.title else {
                throw NetworkError.networkingError
            }
            let value = "최애의 아이 11"
            
            XCTAssertEqual(result, value)
        case .failure(_):
            break
        }
    }
    
    
    
}
