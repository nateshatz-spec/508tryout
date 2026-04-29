import SwiftUI

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isAuthenticating = false
    
    let bgColor = Color(red: 5/255, green: 8/255, blue: 17/255) // #050811
    let bgSecondaryColor = Color(red: 10/255, green: 15/255, blue: 28/255) // #0A0F1C
    let textPrimary = Color(red: 248/255, green: 250/255, blue: 252/255) // #F8FAFC
    let textSecondary = Color(red: 148/255, green: 163/255, blue: 184/255) // #94A3B8
    let accentColor = Color(red: 15/255, green: 150/255, blue: 216/255) // #0f96d8
    let accentHover = Color(red: 56/255, green: 189/255, blue: 248/255) // #38bdf8
    
    var body: some View {
        ZStack {
            // Background
            RadialGradient(
                gradient: Gradient(colors: [
                    Color(red: 15/255, green: 150/255, blue: 216/255).opacity(0.15),
                    bgColor
                ]),
                center: .center,
                startRadius: 0,
                endRadius: 400
            )
            .ignoresSafeArea()
            
            // Login Box
            VStack(spacing: 30) {
                
                // Logo
                HStack(spacing: 0) {
                    Text("508")
                        .font(.system(size: 32, weight: .heavy, design: .default))
                        .foregroundColor(textPrimary)
                    Text(".")
                        .font(.system(size: 32, weight: .heavy, design: .default))
                        .foregroundColor(accentColor)
                }
                .padding(.bottom, 10)
                
                // Titles
                VStack(spacing: 8) {
                    Text("Client Portal")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(textPrimary)
                    
                    Text("Sign in to view your campaign analytics.")
                        .font(.system(size: 15))
                        .foregroundColor(textSecondary)
                }
                .padding(.bottom, 10)
                
                // Form
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email Address")
                            .font(.system(size: 14))
                            .foregroundColor(textSecondary)
                        
                        TextField("client@company.com", text: $email)
                            .padding()
                            .background(Color.black.opacity(0.2))
                            .cornerRadius(12)
                            .foregroundColor(textPrimary)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
                            )
                            .preferredColorScheme(.dark)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.system(size: 14))
                            .foregroundColor(textSecondary)
                        
                        SecureField("••••••••", text: $password)
                            .padding()
                            .background(Color.black.opacity(0.2))
                            .cornerRadius(12)
                            .foregroundColor(textPrimary)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
                            )
                            .preferredColorScheme(.dark)
                    }
                }
                
                // Sign In Button
                Button(action: {
                    isAuthenticating = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        // Simulate auth success
                        isAuthenticating = false
                    }
                }) {
                    Text(isAuthenticating ? "Authenticating..." : "Sign In")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(bgColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(accentColor)
                        .clipShape(Capsule())
                        .shadow(color: accentColor.opacity(0.3), radius: 10, x: 0, y: 4)
                }
                .opacity(isAuthenticating ? 0.8 : 1.0)
                .disabled(isAuthenticating)
                .padding(.top, 10)
                
                // Back Link
                Button(action: {
                    // Navigate back placeholder
                }) {
                    Text("← Back to Home")
                        .font(.system(size: 14))
                        .foregroundColor(textSecondary)
                }
                .padding(.top, 10)
            }
            .padding(40)
            .background(Color.white.opacity(0.02))
            .background(.ultraThinMaterial)
            .cornerRadius(24)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.3), radius: 32, x: 0, y: 8)
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    ContentView()
}
