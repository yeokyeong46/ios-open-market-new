import UIKit

enum RequestError: Error {
    case responseReturnError
    case responseStatusError
    case EmptyDataError
}

struct NetworkConnector {
    static func checkHealth(completionHandler: @escaping (Bool)->Void) {
        guard let targetURL = URL(string: "https://market-training.yagom-academy.kr/healthChecker") else { return }
        let URLRequest = URLRequest(url: targetURL)
        
        URLSession.shared.dataTask(with: URLRequest) { data, response, error in
            if let error = error {
                print(error)
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                print((response as! HTTPURLResponse).statusCode)
                return
            }
            DispatchQueue.main.async {
                if httpResponse.statusCode == 200 {
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
        }.resume()
    }
    
    static func requestGET<T: Decodable> (api: String, type: T.Type, completionHandler: @escaping (T)->Void) {
        guard let targetURL = URL(string: "https://market-training.yagom-academy.kr/\(api)") else { return }
        let URLRequest = URLRequest(url: targetURL)

        URLSession.shared.dataTask(with: URLRequest) { data, response, error in
            if let error = error {
                print(error)
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                print((response as! HTTPURLResponse).statusCode)
                return
            }
            guard let data = data else { return }
            guard let result = Decoder.shared.decode(type: type, from: data) else { return }
            DispatchQueue.main.async {
                completionHandler(result)
            }
        }.resume()
    }
}
