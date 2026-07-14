import SwiftUI

struct BookingView: View {
    @Environment(\.dismiss) private var dismiss
    
    // 1. Inject ViewModels
    @StateObject private var viewModel = BookingViewModel()
    
    let currentUser: User
    let selectedService: Service
    
    @State private var selectedDate = Date()
    @State private var selectedTime: String? = nil
    
    let timeSlots = [
        "09:00", "10:00", "11:00",
        "13:00", "14:00", "15:00",
        "16:00", "17:00", "18:00"
    ]
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Custom Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.appAccent)
                    }
                    Spacer()
                    Text("Select Date & Time")
                        .font(.title3.bold())
                        .foregroundColor(.appTextPrimary)
                    Spacer()
                    Spacer().frame(width: 24)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Date Picker
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Choose Date")
                                .font(.headline)
                                .foregroundColor(.appTextSecondary)
                            
                            DatePicker("Date", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                                .datePickerStyle(.graphical)
                                .accentColor(.appAccent)
                                .padding()
                                .background(Color.appCardBackground)
                                .cornerRadius(16)
                                .preferredColorScheme(.dark)
                        }
                        .padding(.horizontal)
                        
                        // Time Slots
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Choose Time")
                                .font(.headline)
                                .foregroundColor(.appTextSecondary)
                            
                            TimeSlotGrid(
                                slots: viewModel.getAvailableSlots(for: selectedDate),
                                selectedSlot: $selectedTime
                            )
                        }
                        .padding(.horizontal)
                        
                        // Show ViewModel Business Logic Error (e.g., closed on Sundays)
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .bold()
                                .padding()
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                
                // Confirm Button with loading action
                Button(action: {
                    if let selectedTime = selectedTime {
                        Task {
                            await viewModel.bookAppointment(
                                user: currentUser,
                                service: selectedService,
                                date: selectedDate,
                                timeSlot: selectedTime
                            )
                        }
                    }
                }) {
                    ZStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.appBackground)
                        } else {
                            Text("Confirm Appointment")
                                .font(.headline)
                                .foregroundColor(.appBackground)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(selectedTime != nil ? Color.appAccent : Color.appTextSecondary.opacity(0.3))
                    .cornerRadius(12)
                }
                .disabled(selectedTime == nil || viewModel.isLoading)
                .padding(.horizontal)
                .padding(.bottom, 15)
            }
        }
        .navigationBarBackButtonHidden(true)
        // Handle Success alert via ViewModel binding
        .alert("Success! 🎉", isPresented: $viewModel.isSuccess) {
            Button("Back to Home") {
                viewModel.resetStatus()
                dismiss()
            }
        } message: {
            Text("Your appointment for \(selectedService.title) has been successfully created!")
        }
    }
}

#Preview {
    BookingView(
        currentUser: User(id: "1", fullName: "Emirhan Sky", email: "test@gmail.com", phoneNumber: "123", role: .customer),
        selectedService: Service(id: "1", title: "Haircut", price: 300, duration: 30, iconName: "scissors")
    )
}
