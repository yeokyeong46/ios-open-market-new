import UIKit

struct NetworkConnector {
    static func checkHealth(completionHandler: @escaping (Result<Bool,RequestError>)->Void) {
        guard let targetURL = URL(string: "https://market-training.yagom-academy.kr/healthChecker") else { return }
        let URLRequest = URLRequest(url: targetURL)
        
        URLSession.shared.dataTask(with: URLRequest) { data, response, error in
            if let error = error {
                completionHandler(.failure(.transportError))
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                print((response as! HTTPURLResponse).statusCode)
                    completionHandler(.failure(.serverError))
                return
            }
            DispatchQueue.main.async {
                if httpResponse.statusCode == 200 {
                    completionHandler(.success(true))
                } else {
                    completionHandler(.success(false))
                }
            }
        }.resume()
    }
    
    static func requestGET<T: Decodable> (path: String, type: T.Type, completionHandler: @escaping (Result<T,RequestError>)->Void) {
        guard let targetURL = URL(string: "https://market-training.yagom-academy.kr/\(path)") else { return }
        let URLRequest = URLRequest(url: targetURL)

        URLSession.shared.dataTask(with: URLRequest) { data, response, error in
            if let _ = error {
                completionHandler(.failure(.transportError))
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    completionHandler(.failure(.serverError))
                    return
            }
            guard let data = data else {
                completionHandler(.failure(.emptyDataError))
                return
            }
            guard let result = Decoder.shared.decode(type: type, from: data) else {
                completionHandler(.failure(.decodeError))
                return
            }
            DispatchQueue.main.async {
                completionHandler(.success(result))
            }
        }.resume()
    }
}
