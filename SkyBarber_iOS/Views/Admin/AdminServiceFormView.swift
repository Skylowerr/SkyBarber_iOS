import SwiftUI

struct AdminServiceFormView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AdminServicesViewModel
    
    var editingService: Service?
    
    @State private var title: String = ""
    @State private var price: String = ""
    @State private var duration: String = ""
    @State private var iconName: String = "scissors"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Hizmet Detayları")) {
                    TextField("Hizmet Adı (örn: Saç Kesimi)", text: $title)
                        .accessibilityIdentifier("serviceTitleTextField")
                    TextField("Fiyat (TL)", text: $price)
                        .keyboardType(.decimalPad)
                        .accessibilityIdentifier("servicePriceTextField")
                    TextField("Süre (Dakika)", text: $duration)
                        .keyboardType(.numberPad)
                        .accessibilityIdentifier("serviceDurationTextField")
                    TextField("İkon Adı (SF Symbols)", text: $iconName)
                        .autocapitalization(.none)
                        .accessibilityIdentifier("serviceIconTextField")
                }
                
                if let error = viewModel.errorMessage {
                    Text(error).foregroundColor(.red).font(.caption)
                }
            }
            .navigationTitle(editingService == nil ? "Yeni Hizmet" : "Hizmeti Düzenle")
            .navigationBarItems(
                leading: Button("İptal") { dismiss() }
                    .accessibilityIdentifier("cancelServiceButton"),
                trailing: Button("Kaydet") {
                    Task { await save() }
                }
                    .accessibilityIdentifier("saveServiceButton")
            )
            .onAppear {
                if let service = editingService {
                    title = service.title
                    price = String(service.price)
                    duration = String(service.duration)
                    iconName = service.iconName
                }
            }
        }
    }
    
    private func save() async {
        guard let p = Double(price), let d = Int(duration), !title.isEmpty else { return }
        
        let success = await viewModel.saveService(
            id: editingService?.id,
            title: title,
            price: p,
            duration: d,
            iconName: iconName
        )
        
        if success {
            dismiss()
        }
    }
}
