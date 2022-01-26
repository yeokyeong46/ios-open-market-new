import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    
//    func test_api_health() throws {
//        NetworkConnector.checkHealth() {
//            output in
//            XCTAssertTrue(output)
//        }
//    }
//
//    // 이게 지금 의미있는 테스트인가?
//    func test_api_get_productList() throws {
//        NetworkConnector.requestGET(api: "api/products?page_no=1&items_per_page=10", type: ProductList.self) {
//            output in
//            XCTAssertNotNil(output)
//            XCTAssertEqual(output.pageNo, 1)
//            XCTAssertEqual(output.itemsPerPage, 10)
//        }
//    }
//
//    func test_api_get_productDetail() throws {
//        NetworkConnector.requestGET(api: "api/products/522", type: ProductDetail.self) {
//            output in
//            XCTAssertNotNil(output)
//            XCTAssertEqual(output.id, 522)
//        }
//    }
    
    func test_healthcheck_request_success() {
        let mockSession = MockURLSession()
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
