import Foundation

struct Product: Decodable, Hashable {
    let id: Int
    let vendorId: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: Int
    let bargainPrice: Int
    let discountedPrice: Int
    let stock: Int
    let createdAt: Date
    let issuedAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case id, name, thumbnail, currency, price, stock
        case vendorId = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
