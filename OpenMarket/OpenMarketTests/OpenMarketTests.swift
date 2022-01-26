import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    
//    func test_api_health() throws {
//        NetworkConnector.checkHealth() {
//            output in
//            XCTAssertTrue(output)
//        }
//    }

    func test_api_get_productList() throws {
        let NC = NetworkConnector()
        NC.requestGET(path: "api/products?page_no=1&items_per_page=10", type: ProductList.self) {
            result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
                XCTAssertEqual(data.pageNo, 1)
                XCTAssertEqual(data.itemsPerPage, 10)
            case .failure(let error):
                XCTFail("fail health check")
            }
            
        }
    }

    func test_api_get_productDetail() throws {
        let NC = NetworkConnector()
        NC.requestGET(path: "api/products/522", type: ProductDetail.self) {
            result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
                XCTAssertEqual(data.id, 522)
            case .failure(let error):
                XCTFail("fail health check")
            }
            
        }
    }
    
    // mock test
    
    func test_healthcheck_request_success() {
        let mockSession = MockURLSession()
        let NC = NetworkConnector(session: mockSession)
        
        NC.checkHealth() {
            result in
            switch result {
            case .success(let data):
                XCTAssertTrue(data, "\(data)")
            case .failure(let error):
                XCTFail("fail health check")
            }
        }
    }
    
    func test_healthcheck_request_fail() {
        let mockSession = MockURLSession(isRequestSuccess: false)
        let NC = NetworkConnector(session: mockSession)
        
        NC.checkHealth() {
            result in
            switch result {
            case .success(let data):
                XCTAssertTrue(data)
            case .failure(let error):
                XCTFail("fail health check")
            }
        }
    }
}
