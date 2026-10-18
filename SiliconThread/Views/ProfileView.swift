import SwiftUI
import UniformTypeIdentifiers

struct ProfileView: View {
    var body: some View {
        NavigationView {
            List {
                Section { HStack { Image(systemName: "person.crop.circle.fill").font(.largeTitle).foregroundColor(Color(hex:"#22D3EE")); VStack(alignment:.leading){ Text("Guest Tester").bold().accessibilityIdentifier("profile-name"); Text("tester@siliconthread.dev").font(.caption).foregroundColor(.secondary).accessibilityIdentifier("profile-email"); Text("★ Threadbearer • Tier 3").font(.caption2).bold().foregroundColor(Color(hex:"#B6FF38")).accessibilityIdentifier("profile-tier") } }.listRowBackground(Color(hex:"#11162A")) }.accessibilityIdentifier("profile-card")
                Section(header: Text("ACCOUNT").font(.caption).foregroundColor(Color(hex:"#22D3EE"))) {
                    NavigationLink("Addresses", destination: AddressFormView()).accessibilityIdentifier("row-addresses")
                    Text("Payment Methods").foregroundColor(.secondary)
                    NavigationLink("Settings", destination: SettingsView())
                }
                Section(header: Text("DOCUMENTS").font(.caption).foregroundColor(Color(hex:"#22D3EE"))) {
                    DownloadRow(title: "Download User Guide (PDF)", icon: "doc.fill", asset: "docs/SiliconThread_User_Guide.pdf", fileName: "SiliconThread_User_Guide.pdf", mime: "application/pdf").accessibilityIdentifier("profile-download-pdf")
                    DownloadRow(title: "Download Overview Image", icon: "photo.fill", asset: "images/SiliconThread_Overview.png", fileName: "SiliconThread_Overview.png", mime: "image/png").accessibilityIdentifier("profile-download-image")
                }.accessibilityIdentifier("profile-docs")
                Section { Button("Sign Out") {}.disabled(true).accessibilityIdentifier("profile-signout") }
            }.navigationTitle("Profile").accessibilityIdentifier("profile-screen")
        }
    }
}

struct DownloadRow: View {
    let title, icon, asset, fileName, mime: String
    @State private var showShare = false
    @State private var url: URL?
    var body: some View {
        Button {
            if let src = Bundle.main.url(forResource: (asset as NSString).deletingPathExtension, withExtension: (asset as NSString).pathExtension) ?? Bundle.main.url(forResource: fileName, withExtension: nil) {
                let dst = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
                try? FileManager.default.removeItem(at: dst)
                try? FileManager.default.copyItem(at: src, to: dst)
                url = dst; showShare = true
            } else if let data = try? Data(contentsOf: Bundle.main.bundleURL.appendingPathComponent(asset)) {
                let dst = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
                try? data.write(to: dst); url = dst; showShare = true
            }
        } label: {
            HStack { Image(systemName: icon).foregroundColor(Color(hex:"#22D3EE")); Text(title).foregroundColor(.primary); Spacer(); Text("Download").font(.caption).bold().foregroundColor(Color(hex:"#22D3EE")); Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary) }
        }.sheet(isPresented: $showShare) { if let u=url { ShareSheet(urls: [u]) } }
    }
}
struct ShareSheet: UIViewControllerRepresentable {
    let urls: [URL]
    func makeUIViewController(context: Context) -> UIActivityViewController { UIActivityViewController(activityItems: urls, applicationActivities: nil) }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
