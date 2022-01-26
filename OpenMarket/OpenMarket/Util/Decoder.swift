import UIKit

struct Decoder {
    static let shared = Decoder()
    private init() {}
    
    func decode<T: Decodable> (type: T.Type, from data: Data) -> T? {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-DD'T'HH:mm:ss.SS"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        do {
            return try decoder.decode(type, from: data)
        } catch {
            print(error)
        }
        return nil
    }
}


