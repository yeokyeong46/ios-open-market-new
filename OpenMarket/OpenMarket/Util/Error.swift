import Foundation

enum RequestError: Error {
    case transportError
    case serverError
    case emptyDataError
    case decodeError
}

extension RequestError: LocalizedError {
    var description: String? {
        switch self {
        case .transportError:
            return "리퀘스트 실패"
        case .serverError:
            return "상태코드가 에러"
        case .emptyDataError:
            return "조회 결과 없음"
        case .decodeError:
            return "디코딩 불가"
        }
    }
}
