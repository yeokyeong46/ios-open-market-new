import UIKit



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
                completionHandler(false)
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
    
    static func requestGET<T: Decodable> (apiPath: String, type: T.Type, completionHandler: @escaping (RequestError?, T?)->Void) {
        guard let targetURL = URL(string: "https://market-training.yagom-academy.kr/\(apiPath)") else { return }
        let URLRequest = URLRequest(url: targetURL)

        URLSession.shared.dataTask(with: URLRequest) { data, response, error in
            if let _ = error {
                completionHandler(RequestError.responseReturnError, nil)
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    completionHandler(RequestError.responseStatusError, nil)
                    return
            }
            guard let data = data else {
                completionHandler(RequestError.emptyDataError, nil)
                return
            }
            guard let result = Decoder.shared.decode(type: type, from: data) else {
                completionHandler(RequestError.decodeError, nil)
                return
            }
            DispatchQueue.main.async {
                completionHandler(nil, result)
            }
        }.resume()
    }
}
