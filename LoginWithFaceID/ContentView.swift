//
//  ContentView.swift
//  LoginWithFaceID
//
//  Created by Enrique Sotomayor on 9/22/21.
//

import SwiftUI
import LocalAuthentication

struct ContentView: View {
    @AppStorage("status") var loggedIn = false

    var body: some View {
 
        
        NavigationView {
            if (loggedIn) {
                VStack {
                    Text("User LoggedIn...")
                    
                    Button {
                        loggedIn = false
                    } label: {
                        Text("Log Out")
                    }
                }
                .navigationTitle("Home")
                .navigationBarHidden(false)
                    
            } else {
                Home()
                    .navigationBarHidden(true)
            }
        }
       
    }
}


struct Home: View {
    
    @State var username = ""
    @State var password = ""
    // on first login -> store username in app storage
    @AppStorage("stored_username") var user = "e"
    @AppStorage("status") var loggedIn = false
    
    var body: some View {
        VStack {
            
            Spacer(minLength: 0)
            
            // Eco Logo
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80)
                .padding(.vertical)
            
            // Login Text
            HStack {
                VStack(alignment: .leading, spacing: 12, content: {
                    Text("Login")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Please sign in to continue")
                        .foregroundColor(Color.white.opacity(0.5))
                })
                
                Spacer(minLength: 0)
            }
            .padding()
            .padding(.leading, 15)
            
            
            // Login Form
            // Username
            HStack {
                Image(systemName: "envelope")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 35)
                
                TextField("EMAIL", text: $username)
                    .foregroundColor(.white)
                    .autocapitalization(.none)
            }
            .padding()
            .background(Color.white.opacity(username == "" ? 0.05 : 0.12))
            .cornerRadius(15)
            .padding(.horizontal)
            
            // Password
            HStack {
                Image(systemName: "lock")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 35)
                
                SecureField("Password", text: $password)
                    .foregroundColor(.white)
                    .autocapitalization(.none)

            }
            .padding()
            .background(Color.white.opacity(password == "" ? 0.05 : 0.12))
            .cornerRadius(15)
            .padding(.horizontal)
            .padding(.top)
            
            // Button
            HStack(spacing: 15) {
                Button {
                    
                } label: {
                    Text("Login")
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 150)
                        .background(Color("green"))
                        .clipShape(Capsule())
                }
                .padding(.top)
                .opacity(username != "" && password != "" ? 1 : 0.5)
                .disabled(username != "" && password != "" ? false : true)
                
                // Biometrics
                if getBiometricsStatus() {
                    Button {
                        authenticateUser()
                    } label: {
                        // get biometrics type
                        Image(systemName: LAContext().biometryType == .faceID ? "faceid" : "touchid")
                            .font(.title)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color("green"))
                            .clipShape(Circle())
                        
                    }
                    .padding(.top)
                }
            }
            .padding(.top)

            // Forgot
            Button {
                
            } label: {
                Text("Forgot Password?")
                    .foregroundColor(Color("green"))
            }
            .padding(.top, 8)
       
            
            // Signup
            Spacer(minLength: 0)
            HStack(spacing: 5) {
                Text("Don't Have an Account? ")
                    .foregroundColor(Color.white.opacity(0.6))
                
                Button {
                    
                } label: {
                    Text("Sign Up")
                        .fontWeight(.heavy)
                        .foregroundColor(Color("green"))
                }
            }
            .padding(.vertical)
            
        }
        .background(Color("bg").ignoresSafeArea(.all, edges: .all))
        .animation(.easeOut)
    }
    
    // Biometrics
    func getBiometricsStatus() -> Bool {
        let scanner = LAContext()
        return username == user && scanner.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none)
    }
    
    // Authenticate via Biometrics
    func authenticateUser() {
        let scanner = LAContext()
        scanner.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To Unlock \(username)") { (status, err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            // set loggedIn to true
            withAnimation(.easeOut){
                loggedIn = true
            }
        }
    }
    
}














// Emulator
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
