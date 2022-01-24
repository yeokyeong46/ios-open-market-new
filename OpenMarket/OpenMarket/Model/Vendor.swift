import Foundation

struct Vendor: Decodable {
    let name: String
    let id: Int
    let createdAt: Date
    let issuedAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case name
        case id
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
