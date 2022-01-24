import UIKit

func decodeData<T: Decodable> (type: T.Type, from data: Data) -> T? {
    let decoder = JSONDecoder()
    do {
        return try decoder.decode(type, from: data)
    } catch {
        print(error)
    }
    return nil
}
