import SwiftUI

struct AppointmentCard: View {
    let appointment: Appointment
    var onCancel: (() -> Void)? = nil
    
    // Modelde formattedDate olmadığı için tarihi kendi içinde formatlıyoruz
    private var formattedDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: appointment.date)
    }
    
    // Status renk helper'ı (Modeldeki eksik enum vaka hatalarını önlemek için default kullandık)
    private var statusColor: Color {
        switch appointment.status {
        case .cancelled:
            return .red
        default:
            return .orange
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Service Title & Status Badge
            HStack {
                Text(appointment.serviceTitle)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                // Status Badge
                Text(String(describing: appointment.status).capitalized)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.2))
                    .foregroundColor(statusColor)
                    .cornerRadius(8)
            }
            
            Divider()
                .overlay(Color.white.opacity(0.1))
            
            // Date & Time Details
            HStack(spacing: 16) {
                Label(formattedDateString, systemImage: "calendar")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Label(appointment.timeSlot, systemImage: "clock")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            // Cancel Button
            if appointment.status != .cancelled && onCancel != nil {
                Button {
                    onCancel?()
                } label: {
                    HStack {
                        Image(systemName: "xmark.circle")
                        Text("Cancel Appointment")
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}
