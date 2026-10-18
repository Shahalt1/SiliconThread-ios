import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView().tabItem { Label("Home", systemImage: "house") }
            CatalogView().tabItem { Label("Browse", systemImage: "square.grid.2x2") }
            SearchView().tabItem { Label("Search", systemImage: "magnifyingglass") }
            WishlistView().tabItem { Label("Wishlist", systemImage: "heart") }
            CartView().tabItem { Label("Cart", systemImage: "cart") }
            ProfileView().tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }.tint(Color(hex: "#22D3EE"))
    }
}

struct HomeView: View {
    @StateObject var store = ProductStore()
    var body: some View {
        NavigationView {
            List(store.products.prefix(20), id: \.id) { p in
                VStack(alignment: .leading) {
                    Text("\(p.brand) \(p.model)").font(.headline)
                    Text(p.short ?? "").font(.caption).foregroundColor(.secondary)
                    Text("$\(p.price, specifier: "%.0f")").bold().foregroundColor(Color(hex: "#22D3EE"))
                }.accessibilityIdentifier(p.testId ?? p.id)
            }.navigationTitle("SiliconThread")
        }
    }
}
struct CatalogView: View { @StateObject var s=ProductStore(); var body: some View { HomeView() } }
struct SearchView: View {
    @StateObject var s=ProductStore(); @State var q=""
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search GPUs, CPUs, AI accelerators…", text: $q).textFieldStyle(.roundedBorder).padding().accessibilityIdentifier("search-field")
                List(s.search(q), id:\.id){ p in Text("\(p.brand) \(p.model)").accessibilityIdentifier(p.testId ?? p.id) }
            }.navigationTitle("Search")
        }
    }
}
struct WishlistView: View { var body: some View { Text("Wishlist empty").foregroundColor(.secondary) } }
struct CartView: View { var body: some View { NavigationLink("Checkout → Address", destination: AddressFormView()).padding() } }
