import SwiftUI

struct AdminServicesView: View {
    @StateObject private var viewModel = AdminServicesViewModel()
    @State private var showingAddSheet = false
    @State private var serviceToEdit: Service?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.services) { service in
                    HStack {
                        Image(systemName: service.iconName)
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text(service.title).font(.headline)
                            Text("\(service.duration) dk • \(service.price, specifier: "%.2f") TL")
                                .font(.subheadline).foregroundColor(.gray)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        serviceToEdit = service
                    }
                }
                .onDelete(perform: viewModel.deleteService)
            }
            .navigationTitle("Hizmet Yönetimi")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                Task { await viewModel.loadServices() }
            }
            .sheet(isPresented: $showingAddSheet) {
                AdminServiceFormView(viewModel: viewModel)
            }
            .sheet(item: $serviceToEdit) { service in
                AdminServiceFormView(viewModel: viewModel, editingService: service)
            }
        }
    }
}
