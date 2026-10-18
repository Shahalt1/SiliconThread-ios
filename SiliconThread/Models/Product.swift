import Foundation

struct Product: Codable, Identifiable {
    let id: String
    let testId: String?
    let category: String
    let brand: String
    let model: String
    let price: Double
    let short: String?
    let description: String?
    let rating: Double?
    let reviewCount: Int?
    let inStock: Bool?
    let image: String?
}

struct ProductBundle: Codable { let products: [Product] }

class ProductStore: ObservableObject {
    @Published var products: [Product] = []
    init() { load() }
    func load() {
        guard let url = Bundle.main.url(forResource: "products", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let bundle = try? JSONDecoder().decode(ProductBundle.self, from: data) else { return }
        products = bundle.products
    }
    func search(_ q: String) -> [Product] {
        guard !q.isEmpty else { return products }
        return products.filter { "\($0.brand) \($0.model) \($0.category)".localizedCaseInsensitiveContains(q) }
    }
}
