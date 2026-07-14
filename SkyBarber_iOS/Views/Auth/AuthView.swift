import SwiftUI

struct AuthView: View {
    // 1. ViewModel injection
    @StateObject private var viewModel = AuthViewModel()
    
    @State private var isLoginMode = true
    @State private var email = ""
    @State private var password = ""
    @State private var fullName = ""
    @State private var phoneNumber = ""
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Spacer()
                
                // Logo & Header
                VStack(spacing: 10) {
                    Image(systemName: "scissors")
                        .font(.system(size: 60))
                        .foregroundColor(.appAccent)
                        .rotationEffect(.degrees(-90))
                    
                    Text("SKYBARBER")
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                        .foregroundColor(.appTextPrimary)
                    
                    Text(isLoginMode ? "Sign in to book your appointment." : "Create a new account.")
                        .font(.subheadline)
                        .foregroundColor(.appTextSecondary)
                }
                .padding(.bottom, 20)
                
                // Form Fields
                VStack(spacing: 16) {
                    if !isLoginMode {
                        CustomTextField(placeholder: "Full Name", text: $fullName, icon: "person")
                        CustomTextField(placeholder: "Phone Number", text: $phoneNumber, icon: "phone")
                    }
                    
                    CustomTextField(placeholder: "Email Address", text: $email, icon: "envelope")
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    CustomSecureField(placeholder: "Password", text: $password, icon: "lock")
                }
                .padding(.horizontal, 24)
                
                // Error Message Display
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.horizontal, 24)
                        .multilineTextAlignment(.center)
                }
                
                // Action Button (Login / Register) with Loading indicator
                Button(action: {
                    Task {
                        if isLoginMode {
                            await viewModel.login(email: email, password: password)
                        } else {
                            await viewModel.register(email: email, password: password, fullName: fullName, phoneNumber: phoneNumber)
                        }
                    }
                }) {
                    ZStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .appBackground))
                        } else {
                            Text(isLoginMode ? "Login" : "Register")
                                .font(.headline)
                                .foregroundColor(.appBackground)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.appAccent)
                    .cornerRadius(12)
                    .shadow(color: Color.appAccent.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .disabled(viewModel.isLoading)
                .padding(.horizontal, 24)
                .padding(.top, 10)
                
                // Toggle Button
                Button(action: {
                    withAnimation(.spring()) {
                        isLoginMode.toggle()
                        viewModel.errorMessage = nil // Clear error on switch
                    }
                }) {
                    HStack {
                        Text(isLoginMode ? "Don't have an account?" : "Already registered?")
                            .foregroundColor(.appTextSecondary)
                        Text(isLoginMode ? "Create Account" : "Login")
                            .foregroundColor(.appAccent)
                            .bold()
                    }
                    .font(.footnote)
                }
                .disabled(viewModel.isLoading)
                
                Spacer()
            }
        }
        // If login successful, transition will be handled by App router
    }
}

#Preview {
    AuthView()
}
