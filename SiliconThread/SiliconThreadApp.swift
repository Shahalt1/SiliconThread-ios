import SwiftUI

@main
struct SiliconThreadApp: App {
    @AppStorage("theme") private var theme: String = "neon"
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(theme == "light" ? .light : .dark)
                .tint(Color(hex: "#22D3EE"))
        }
    }
}

extension Color {
    init(hex: String) {
        let h = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var v: UInt64 = 0
        Scanner(string: h).scanHexInt64(&v)
        let a = h.count == 8 ? Double((v >> 24) & 0xFF)/255 : 1
        let r = Double((v >> (h.count==8 ? 16 : 16)) & 0xFF)/255
        let g = Double((v >> (h.count==8 ? 8 : 8)) & 0xFF)/255
        let b = Double(v & 0xFF)/255
        self = Color(.sRGB, red: r, green: g, blue: b, opacity: h.count==8 ? b : a)
        if h.count == 6 { self = Color(.sRGB, red: Double((v>>16)&0xFF)/255, green: Double((v>>8)&0xFF)/255, blue: Double(v&0xFF)/255, opacity: 1) }
    }
}
