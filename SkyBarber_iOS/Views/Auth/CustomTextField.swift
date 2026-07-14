import SwiftUI

// Fully English custom text field with modern styling
struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.appAccent)
                .frame(width: 20)
            
            TextField(placeholder, text: $text)
                .foregroundColor(.appTextPrimary)
                .tint(.appAccent)
        }
        .padding()
        .background(Color.appCardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.appTextSecondary.opacity(0.1), lineWidth: 1)
        )
    }
}

// Fully English secure text field for passwords
struct CustomSecureField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.appAccent)
                .frame(width: 20)
            
            SecureField(placeholder, text: $text)
                .foregroundColor(.appTextPrimary)
                .tint(.appAccent)
        }
        .padding()
        .background(Color.appCardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.appTextSecondary.opacity(0.1), lineWidth: 1)
        )
    }
}
