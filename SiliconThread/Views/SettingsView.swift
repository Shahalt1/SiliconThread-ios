import SwiftUI

struct SettingsView: View {
    @AppStorage("theme") var theme = "neon"
    var body: some View {
        List {
            Section(header: Text("PREFERENCES").font(.caption).foregroundColor(Color(hex:"#22D3EE"))) {
                HStack{ Text("Theme & Display"); Spacer(); Text(themeLabel).foregroundColor(.secondary).accessibilityIdentifier("settings-row-theme"); Button("Change"){ theme = next(theme) }.accessibilityIdentifier("settings-row-theme") }
                Toggle("Notifications", isOn: .constant(true)).accessibilityIdentifier("settings-row-notifications")
                HStack{ Text("Currency"); Spacer(); Text("USD").bold().foregroundColor(Color(hex:"#B6FF38")) }.accessibilityIdentifier("settings-row-currency")
            }.accessibilityIdentifier("settings-group-preferences")
            Section(header: Text("ACCOUNT & DATA").font(.caption).foregroundColor(Color(hex:"#22D3EE"))) {
                Text("Addresses").accessibilityIdentifier("settings-row-addresses")
                Text("Payment Methods").accessibilityIdentifier("settings-row-payments")
                Button("Clear Cache"){} .accessibilityIdentifier("settings-clear-cache")
                Button("Clear Cart"){} .accessibilityIdentifier("settings-clear-cart")
                Button("Clear Wishlist"){} .accessibilityIdentifier("settings-clear-wishlist")
            }.accessibilityIdentifier("settings-group-account")
            Section(header: Text("SUPPORT").font(.caption).foregroundColor(Color(hex:"#22D3EE"))) {
                Text("Help & Support").accessibilityIdentifier("settings-row-help")
                HStack{ Text("About SiliconThread"); Spacer(); Text("Version 1.0.0").font(.caption).foregroundColor(.secondary) }.accessibilityIdentifier("settings-row-about")
            }.accessibilityIdentifier("settings-group-support")
        }.navigationTitle("Settings").accessibilityIdentifier("settings-screen")
    }
    var themeLabel: String { theme=="light" ? "Light" : theme=="dark" ? "Dark" : "Neon Dark" }
    func next(_ c: String)->String { c=="neon" ? "dark" : c=="dark" ? "light" : "neon" }
}
