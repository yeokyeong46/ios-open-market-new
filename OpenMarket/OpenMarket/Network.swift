import UIKit

struct NetworkConnector {
    static func checkHealth() {
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
            guard let data = data, let string = String(data: data, encoding: .utf8) else { return }
            print(string)
        }.resume()
        
    }
    
    static func requestGET<T: Decodable> (api: String, type: T.Type) {
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
            guard let data = data, let result = decodeData(type: type, from: data) else { return }
            print(result)
        }.resume()
    }
}
