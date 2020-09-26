//
//  APITest.swift
//  DeezerSampleTests
//
//  Created by Yusuf Özgül on 26.09.2020.
//

import XCTest
@testable import DeezerSample

class APITest: XCTestCase {
    
    func test_ParseData_Success_shouldCheckResult() {
        guard let fileData = loadFile(fileName: "genreList") else {
            XCTFail("File not load")
            return
        }
        let result = ParseFromData<ApiResponseWithInData<[GenreResponse]>>.parse(data: fileData)
        XCTAssertNotNil(result)
        
        switch result {
        case .success(let genreList):
            XCTAssertEqual(genreList.data.count, 23)
            XCTAssertEqual(genreList.data.first?.id, 0)
            XCTAssertEqual(genreList.data.last?.name, "Yeniler")
        case .failure(let error):
            XCTFail("This test is success test: \(error)")
        }
    }
    
    func test_ParseData_ErroredResponse_shouldCheckErrorResult() {
        guard let fileData = loadFile(fileName: "ErroredResponse") else {
            XCTFail("File not load")
            return
        }
        
        let result = ParseFromData<ApiResponseErrorType>.parse(data: fileData)
        XCTAssertNotNil(result)

        switch result {
        case .success(let data):
            XCTFail("This test is error test: \(data)")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, "Unknown path components : /genred")

        }
    }
}

extension APITest {
    func loadFile(fileName: String) -> Data? {
        let bundle = Bundle(for: APITest.self)
        let url = bundle.url(forResource: fileName, withExtension: "json")
        guard let fileUrl = url else {
            return nil
        }
        return try? Data(contentsOf: fileUrl)
    }
}
