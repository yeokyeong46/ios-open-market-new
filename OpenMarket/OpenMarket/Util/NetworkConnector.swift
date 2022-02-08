import UIKit

class NetworkConnector {
    
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func checkHealth(completionHandler: @escaping (Result<Bool,RequestError>)->Void) {
        guard let targetURL = URL(string: "https://market-training.yagom-academy.kr/healthChecker") else { return }
        let URLRequest = URLRequest(url: targetURL)
        
        self.session.dataTask(with: URLRequest) { data, response, error in
            if let error = error {
                completionHandler(.failure(.transportError))
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                print((response as! HTTPURLResponse).statusCode)
                    completionHandler(.failure(.serverError))
                return
            }
            guard let data = data, let string = String(data: data, encoding: .utf8) else { return }
            print(string)
            DispatchQueue.main.async {
                if httpResponse.statusCode == 200 && string == "\"OK\""{
                    completionHandler(.success(true))
                } else {
                    completionHandler(.success(false))
                }
            }
        }.resume()
    }
    
    func requestGET<T: Decodable> (path: String, type: T.Type, completionHandler: @escaping (Result<T,RequestError>)->Void) {
        guard let targetURL = URL(string: "https://market-training.yagom-academy.kr/\(path)") else { return }
        let URLRequest = URLRequest(url: targetURL)

        self.session.dataTask(with: URLRequest) { data, response, error in
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
    
    
    func requestPost (completionHandler: @escaping (Bool)->Void) {
        let sampleImage = UIImage(named: "xcode")
        guard let sampleImageData = sampleImage?.pngData() else { return }
        let sampleImages = [sampleImageData, sampleImageData]
        
        let boundary = "Boundary-\(UUID().uuidString)"
        guard let boundaryPrefix = "--\(boundary)\r\n".data(using: .utf8) else { return }
        guard let boundaryPostfix = "--\(boundary)--\r\n".data(using: .utf8) else { return }
        guard let enter = "\r\n".data(using: .utf8) else { return }
        
        var bodydata = Data()
        bodydata.append(boundaryPrefix)
        var paramsbody = ""
        paramsbody += "Content-Disposition: form-data; name=\"params\"\r\n\r\n"
        paramsbody += "{ \"name\" : \"asdasdaaaaaaaa\", \"descriptions\" : \"asdasdasdaaaaaaaa\", \"price\" : 1234, \"currency\" : \"KRW\", \"secret\": \"n@5r!GMqkHtcnr\" }\r\n"
        
        guard let paramsbody = paramsbody.data(using: .utf8) else {
            print("param error")
            return
        }
        bodydata.append(paramsbody)

        for image in sampleImages {
            bodydata.append(boundaryPrefix)
            var imagesbody = ""
            imagesbody += "Content-Disposition: form-data; name=\"images\"; filename=\"xcode.png\"\r\n"
            imagesbody += "Content-Type: image/png\r\n\r\n"
            guard let imagesbody = imagesbody.data(using: .utf8) else {
                print("image error")
                return
            }
            bodydata.append(imagesbody)
//            bodydata.append(Data())
            bodydata.append(image)
            bodydata.append(enter)
        }
        
        bodydata.append(boundaryPostfix)
        print(bodydata)
        print(String(data: bodydata, encoding: .utf8))
        
        var request = URLRequest(url: URL(string: "https://market-training.yagom-academy.kr/api/products")!)
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("792a43fb-7217-11ec-abfa-071266dca86c", forHTTPHeaderField: "identifier")

        request.httpBody = bodydata

//        self.session.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print(error)
//                completionHandler(false)
//            }
//            guard let httpResponse = response as? HTTPURLResponse,
//                (200...299).contains(httpResponse.statusCode) else {
//                    print("response error \(response)")
//                    completionHandler(false)
//                    return
//            }
//            guard let data = data else {
//                print("no data")
//                completionHandler(false)
//                return
//            }
//            guard let result = Decoder.shared.decode(type: ProductDetail.self, from: data) else {
//                print("no result")
//                completionHandler(false)
//                return
//            }
//            DispatchQueue.main.async {
//                completionHandler(true)
//            }
//        }.resume()

    }
}



