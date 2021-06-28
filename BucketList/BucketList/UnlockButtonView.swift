//
//  UnlockButtonView.swift
//  BucketList
//
//  Created by Tim Musil on 28.06.21.
//

import SwiftUI
import LocalAuthentication

struct UnlockButtonView: View {
    @Binding var isUnlocked: Bool
    @State private var showingAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        Button("Unlock Places") {
            self.authenticate()
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(Capsule())
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("Authentification Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        })
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        isUnlocked = true
                    } else {
                        self.errorMessage = authenticationError?.localizedDescription ?? "Unknown error"
                        self.showingAlert = true
                    }
                }
            }
        } else {
            // no biometrics
        }
    }
}

struct UnlockButtonView_Previews: PreviewProvider {
    static var previews: some View {
        UnlockButtonView(isUnlocked: .constant(true))
    }
}
