//
//  AuthView.swift
//  SkyBarber_iOS
//
//  Created by Emirhan Gökçe on 14.07.2026.
//

//
//  AuthView.swift
//  SkyBarber_iOS
//
//  Created by Emirhan Gökçe on 14.07.2026.
//

import SwiftUI

struct AuthView: View {
    // Arayüz durumunu tutan değişkenler (İleride ViewModel'e bağlayacağız)
    @State private var isLoginMode = true
    @State private var email = ""
    @State private var password = ""
    @State private var fullName = ""
    @State private var phoneNumber = ""
    
    var body: some View {
        ZStack {
            // Arka Plan
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Spacer()
                
                // Logo & Başlık (Web'deki SkyBarber havası)
                VStack(spacing: 10) {
                    Image(systemName: "scissors")
                        .font(.system(size: 60))
                        .foregroundColor(.appAccent)
                        .rotationEffect(.degrees(-90)) // Makas janti dursun
                    
                    Text("SKYBARBER")
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                        .foregroundColor(.appTextPrimary)
                    
                    Text(isLoginMode ? "Giriş yapın ve randevunuzu alın." : "Yeni hesap oluşturun.")
                        .font(.subheadline)
                        .foregroundColor(.appTextSecondary)
                }
                .padding(.bottom, 20)
                
                // Giriş / Kayıt Form Alanları
                VStack(spacing: 16) {
                    if !isLoginMode {
                        // Sadece Kayıt Modunda gözükecek Ad Soyad alanı
                        CustomTextField(placeholder: "Ad Soyad", text: $fullName, icon: "person")
                        CustomTextField(placeholder: "Telefon Numarası", text: $phoneNumber, icon: "phone")
                    }
                    
                    CustomTextField(placeholder: "E-posta Adresi", text: $email, icon: "envelope")
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    CustomSecureField(placeholder: "Şifre", text: $password, icon: "lock")
                }
                .padding(.horizontal, 24)
                
                // Aksiyon Butonu (Giriş Yap / Kayıt Ol)
                Button(action: {
                    // İleride burası ViewModel'i tetikleyecek
                    print("Butona basıldı: \(isLoginMode ? "Giriş" : "Kayıt")")
                }) {
                    Text(isLoginMode ? "Giriş Yap" : "Kayıt Ol")
                        .font(.headline)
                        .foregroundColor(.appBackground)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.appAccent)
                        .cornerRadius(12)
                        .shadow(color: Color.appAccent.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
                
                // Mod Değiştirme Linki (Web'deki toggle-auth butonu)
                Button(action: {
                    withAnimation(.spring()) {
                        isLoginMode.toggle()
                    }
                }) {
                    HStack {
                        Text(isLoginMode ? "Hesabınız yok mu?" : "Zaten üye misiniz?")
                            .foregroundColor(.appTextSecondary)
                        Text(isLoginMode ? "Yeni Hesap Oluştur" : "Giriş Yap")
                            .foregroundColor(.appAccent)
                            .bold()
                    }
                    .font(.footnote)
                }
                
                Spacer()
            }
        }
    }
}

// MARK: - Şık ve Özelleştirilmiş Input Alanları (SOLID - Single Responsibility)

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
                // Placeholder rengini gri yapmak için iOS 17+ desteği
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

// Xcode'da önizleme yapmak için
struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
