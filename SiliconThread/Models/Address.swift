import Foundation

struct Address: Codable {
    var fullName = ""
    var phone = ""
    var email = ""
    var alternatePhone = ""
    var company = ""
    var streetLine1 = ""
    var streetLine2 = ""
    var building = ""
    var landmark = ""
    var city = ""
    var district = ""
    var state = ""
    var zip = ""
    var country = "USA"
    var nickname = ""
    var addressType = "Home"
    var tags = ""
    var priority = 50
    var preferredSlot: String { priority < 33 ? "Morning" : priority < 66 ? "Afternoon" : "Evening" }
    var instructions = ""
    var taxId = ""
    var isDefault = true
    var smsOptIn = false
    var attachmentName: String? = nil
    var attachmentSize: Int64? = nil
    var attachmentMime: String? = nil

    var isValid: Bool { !fullName.trimmingCharacters(in: .whitespaces).isEmpty && !phone.trimmingCharacters(in: .whitespaces).isEmpty && !streetLine1.trimmingCharacters(in: .whitespaces).isEmpty }
}

class AddressStore: ObservableObject {
    @Published var address = Address()
    private let key = "st_address"
    init() { load() }
    func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let a = try? JSONDecoder().decode(Address.self, from: data) else { return }
        address = a
    }
    func save() {
        if let data = try? JSONEncoder().encode(address) { UserDefaults.standard.set(data, forKey: key) }
    }
}
