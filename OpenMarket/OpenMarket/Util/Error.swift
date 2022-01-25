import Foundation

enum RequestError: Error {
    case responseReturnError
    case responseStatusError
    case emptyDataError
    case decodeError
}

extension RequestError: LocalizedError {
    var description: String? {
        switch self {
        case .responseReturnError:
            return "리퀘스트 실패"
        case .responseStatusError:
            return "상태코드가 200이 아님"
        case .emptyDataError:
            return "조회 결과 없음"
        case .decodeError:
            return "디코딩 불가"
        }
    }
}
