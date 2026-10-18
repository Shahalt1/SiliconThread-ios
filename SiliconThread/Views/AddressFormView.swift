import SwiftUI

struct AddressFormView: View {
    @StateObject var store = AddressStore()
    @State private var showTags = false
    @State private var tagSel: Set<String> = []
    @State private var attachmentURL: URL?
    @State private var attachmentName: String?
    @State private var showImporter = false
    @State private var confirm = false
    let tags = ["Lift available","Parking","Security gate","Pet friendly","Gated community","24x7 access"]
    let cities = ["Neon City","New York","Los Angeles","Chicago","Bengaluru","Mumbai","Delhi","London","Tokyo"]
    let states = ["Select State","Karnataka","Maharashtra","Tamil Nadu","Delhi","California","Texas","New York"]
    let countries = ["USA","India","Canada","United Kingdom","Australia","Germany","Japan"]
    var body: some View {
        Form {
            // required note
            HStack { Text("*").foregroundColor(.red).bold().accessibilityIdentifier("address-required-star"); Text("Required fields — 3 mandatory").font(.caption).foregroundColor(.secondary) }.accessibilityIdentifier("address-required-note")
            DisclosureGroup("CONTACT") {
                HStack{Text("Full Name"); Text("*").foregroundColor(.red).bold().accessibilityIdentifier("asterisk-fullName")}; TextField("Enter full name", text: $store.address.fullName).accessibilityIdentifier("address-field-fullName")
                HStack{Text("Phone Number"); Text("*").foregroundColor(.red).bold().accessibilityIdentifier("asterisk-phone")}; TextField("Enter phone", text: $store.address.phone).keyboardType(.phonePad).accessibilityIdentifier("address-field-phone")
                TextField("Email", text: $store.address.email).keyboardType(.emailAddress).accessibilityIdentifier("address-field-email")
                TextField("Alternate Phone", text: $store.address.alternatePhone).keyboardType(.phonePad).accessibilityIdentifier("address-field-alternatePhone")
                TextField("Company", text: $store.address.company).accessibilityIdentifier("address-field-company")
            }.accessibilityIdentifier("header-contact")
            DisclosureGroup("ADDRESS") {
                HStack{Text("Street Address Line 1"); Text("*").foregroundColor(.red).bold().accessibilityIdentifier("asterisk-street1")}; TextField("House no., street", text: $store.address.streetLine1).accessibilityIdentifier("address-field-street1")
                TextField("Street Line 2", text: $store.address.streetLine2).accessibilityIdentifier("address-field-street2")
                TextField("Building / Apartment", text: $store.address.building).accessibilityIdentifier("address-field-building")
                TextField("Landmark", text: $store.address.landmark).accessibilityIdentifier("address-field-landmark")
                // search-select City
                Picker("City", selection: $store.address.city) { ForEach(cities, id:\.self){ Text($0) } }.accessibilityIdentifier("address-field-city")
                TextField("District", text: $store.address.district).accessibilityIdentifier("address-field-district")
                Picker("State / Province", selection: $store.address.state) { ForEach(states, id:\.self){ Text($0) } }.accessibilityIdentifier("address-field-state")
                TextField("Pincode / ZIP", text: $store.address.zip).keyboardType(.numberPad).accessibilityIdentifier("address-field-zip")
                Picker("Country", selection: $store.address.country) { ForEach(countries, id:\.self){ Text($0) } }.accessibilityIdentifier("address-field-country")
            }.accessibilityIdentifier("header-address")
            DisclosureGroup("PREFERENCES") {
                TextField("Address Nickname", text: $store.address.nickname).accessibilityIdentifier("address-field-nickname")
                Picker("Address Type", selection: $store.address.addressType) { Text("Home").tag("Home"); Text("Work").tag("Work"); Text("Other").tag("Other") }.pickerStyle(.segmented).accessibilityIdentifier("address-field-addressType")
                // multiselect
                VStack(alignment:.leading){ Text("Building Features (multiselect)").font(.caption); Text(tagSel.isEmpty ? "No tags selected" : tagSel.joined(separator:", ")).font(.caption).foregroundColor(.secondary).accessibilityIdentifier("address-field-tags-display"); Button("Select Tags"){ showTags = true }.accessibilityIdentifier("address-field-tags-pick") }.sheet(isPresented: $showTags){ NavigationView{ List(tags, id:\.self){ t in MultipleSelectionRow(title: t, isSelected: tagSel.contains(t)){ if tagSel.contains(t){ tagSel.remove(t)} else { tagSel.insert(t)}; store.address.tags = tagSel.joined(separator:", ") } } .navigationTitle("Select Features") } }
                VStack{ HStack{ Text("Priority"); Spacer(); Text("\(store.address.priority)%").bold().foregroundColor(Color(hex:"#22D3EE")).accessibilityIdentifier("address-field-priority-value") }; Slider(value: Binding(get:{Double(store.address.priority)}, set:{store.address.priority = Int($0)}), in: 0...100).accessibilityIdentifier("address-field-priority-slider"); Text("Priority: low → high").font(.caption2).foregroundColor(.secondary) }
                TextField("Delivery Instructions", text: $store.address.instructions, axis: .vertical).lineLimit(2...4).accessibilityIdentifier("address-field-instructions")
            }.accessibilityIdentifier("header-prefs")
            DisclosureGroup("BUSINESS (OPTIONAL)") {
                TextField("GSTIN / Tax ID", text: $store.address.taxId).accessibilityIdentifier("address-field-taxId")
                Toggle("Set as default", isOn: $store.address.isDefault).accessibilityIdentifier("address-field-isDefault")
                Toggle("SMS updates", isOn: $store.address.smsOptIn).accessibilityIdentifier("address-field-smsSwitch")
                Toggle("I confirm address accuracy *", isOn: $confirm).accessibilityIdentifier("address-checkbox-confirm")
                Toggle("Receive offers & updates", isOn: .constant(false)).accessibilityIdentifier("address-checkbox-offers")
            }.accessibilityIdentifier("header-business")
            DisclosureGroup("ATTACHMENT") {
                Text("Attachment (any file <5 MB)").font(.caption)
                if let n = attachmentName { Text(n).font(.caption).foregroundColor(.secondary).accessibilityIdentifier("address-field-attachment-name"); if let u = attachmentURL, let data = try? Data(contentsOf: u), u.pathExtension.lowercased()=="png" || u.pathExtension.lowercased()=="jpg" { Image(uiImage: UIImage(data: data) ?? UIImage()).resizable().scaledToFit().frame(height: 120).accessibilityIdentifier("address-field-attachment-preview") } } else { Text("No file selected").font(.caption).foregroundColor(.secondary).accessibilityIdentifier("address-field-attachment-name") }
                Button("Choose File"){ showImporter = true }.accessibilityIdentifier("address-field-attachment-pick")
                if attachmentName != nil { Button("Remove", role: .destructive){ attachmentURL=nil; attachmentName=nil }.accessibilityIdentifier("address-field-attachment-remove") }
            }.accessibilityIdentifier("header-attachment").fileImporter(isPresented: $showImporter, allowedContentTypes: [.data, .pdf, .png, .jpeg, .plainText, .zip], allowsMultipleSelection: false){ res in
                if case .success(let urls) = res, let u = urls.first {
                    let ok = u.startAccessingSecurityScopedResource(); defer { if ok { u.stopAccessingSecurityScopedResource() } }
                    if let sz = (try? u.resourceValues(forKeys: [.fileSizeKey]))?.fileSize, sz > 5*1024*1024 { return }
                    let dst = FileManager.default.temporaryDirectory.appendingPathComponent(u.lastPathComponent)
                    try? FileManager.default.removeItem(at: dst)
                    try? FileManager.default.copyItem(at: u, to: dst)
                    attachmentURL = dst; attachmentName = u.lastPathComponent
                }
            }
        }.navigationTitle("Delivery Address").accessibilityIdentifier("address-screen")
        .toolbar{ ToolbarItem(placement:.confirmationAction){ Button("Save"){ store.address.isValid ? store.save() : () }.accessibilityIdentifier("address-save") } ToolbarItem(placement:.cancellationAction){ Button("Cancel"){} .accessibilityIdentifier("address-cancel") } }
    }
}
struct MultipleSelectionRow: View { let title: String; let isSelected: Bool; let action: ()->Void; var body: some View { Button(action: action){ HStack{ Text(title); Spacer(); if isSelected{ Image(systemName:"checkmark").foregroundColor(.blue)} } } } }
