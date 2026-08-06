import SwiftUI
import Combine

struct BookingView: View {
    let service: Service
    let currentUser: User
    
    @StateObject private var viewModel = BookingViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header Card
                        VStack(alignment: .leading, spacing: 8) {
                            Text(service.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            HStack {
                                Label("\(service.duration) min", systemImage: "clock")
                                Spacer()
                                Text("$\(Int(service.price))")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.orange)
                            }
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(16)
                        
                        // Date Picker
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Select Date")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            DatePicker(
                                "",
                                selection: $viewModel.selectedDate,
                                in: Date()...,
                                displayedComponents: [.date]
                            )
                            .datePickerStyle(.graphical)
                            .colorScheme(.dark)
                            .onChange(of: viewModel.selectedDate) { _ in
                                viewModel.onDateChanged()
                            }
                        }
                        
                        // Time Slots
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Select Time")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            if viewModel.availableTimeSlots.isEmpty {
                                Text("No available time slots for this date.")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                                    .padding(.vertical, 8)
                            } else {
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 12) {
                                    ForEach(viewModel.availableTimeSlots, id: \.self) { slot in
                                        Button {
                                            viewModel.selectedTimeSlot = slot
                                        } label: {
                                            Text(slot)
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 12)
                                                .background(
                                                    viewModel.selectedTimeSlot == slot ? Color.orange : Color.white.opacity(0.1)
                                                )
                                                .foregroundColor(
                                                    viewModel.selectedTimeSlot == slot ? .black : .white
                                                )
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Error Message
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        
                        // Confirm Button
                        Button {
                            Task {
                                await viewModel.bookAppointment(service: service, user: currentUser)
                            }
                        } label: {
                            HStack {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .tint(.black)
                                } else {
                                    Text("Confirm Booking")
                                        .fontWeight(.bold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.selectedTimeSlot == nil ? Color.gray : Color.orange)
                            .foregroundColor(.black)
                            .cornerRadius(14)
                        }
                        .disabled(viewModel.selectedTimeSlot == nil || viewModel.isLoading)
                    }
                    .padding()
                }
            }
            .navigationTitle("Book Appointment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.orange)
                }
            }
            .alert("Success! 🎉", isPresented: $viewModel.isBookingSuccess) {
                Button("OK") {
                    viewModel.resetStatus()
                    dismiss()
                }
            } message: {
                Text("Your appointment for \(service.title) has been successfully created.")
            }
        }
    }
}
