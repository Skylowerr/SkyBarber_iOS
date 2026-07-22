import SwiftUI
import Combine
struct ProfileView: View {
    let currentUser: User
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Header / User Info
                    VStack(spacing: 8) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.orange)
                        
                        Text(currentUser.fullName)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(currentUser.email)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top)
                    
                    // Custom Tab Bar
                    HStack(spacing: 0) {
                        Button {
                            withAnimation {
                                viewModel.selectedTab = .upcoming
                            }
                        } label: {
                            VStack(spacing: 8) {
                                Text("Upcoming")
                                    .fontWeight(.semibold)
                                    .foregroundColor(viewModel.selectedTab == .upcoming ? .orange : .gray)
                                
                                Rectangle()
                                    .fill(viewModel.selectedTab == .upcoming ? Color.orange : Color.clear)
                                    .frame(height: 2)
                            }
                        }
                        
                        Button {
                            withAnimation {
                                viewModel.selectedTab = .past
                            }
                        } label: {
                            VStack(spacing: 8) {
                                Text("History")
                                    .fontWeight(.semibold)
                                    .foregroundColor(viewModel.selectedTab == .past ? .orange : .gray)
                                
                                Rectangle()
                                    .fill(viewModel.selectedTab == .past ? Color.orange : Color.clear)
                                    .frame(height: 2)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // List Section
                    if viewModel.isLoading {
                        Spacer()
                        ProgressView()
                            .tint(.orange)
                        Spacer()
                    } else {
                        let listToShow = viewModel.selectedTab == .upcoming ? viewModel.upcomingAppointments : viewModel.pastAppointments
                        
                        if listToShow.isEmpty {
                            Spacer()
                            VStack(spacing: 12) {
                                Image(systemName: "calendar.badge.clock")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray.opacity(0.5))
                                Text("No appointments found.")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        } else {
                            ScrollView {
                                VStack(spacing: 16) {
                                    ForEach(listToShow) { appointment in
                                        AppointmentCard(
                                            appointment: appointment,
                                            onCancel: {
                                                Task {
                                                    await viewModel.cancelAppointment(id: appointment.id, userId: currentUser.id)
                                                }
                                            }
                                        )
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.loadAppointments(userId: currentUser.id)
            }
        }
    }
}


