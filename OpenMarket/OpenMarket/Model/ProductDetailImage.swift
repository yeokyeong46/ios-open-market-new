import Foundation

struct ProductDetailImage: Decodable {
    let id: Int
    let url: String
    let thumbnailUrl: String
    let uploadResult: Bool
    let issuedAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case id, url
        case thumbnailUrl = "thumbnail_url"
        case uploadResult = "succeed"
        case issuedAt = "issued_at"
    }
}
