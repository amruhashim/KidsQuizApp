//
//  SettingsView.swift
//  Quiz for Kids
//
//  Created by Amru Hashim on 2/21/24.
//

import SwiftUI


import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
           NavigationView {
               VStack(spacing: 20) {
                  
                   ZStack {
                       Circle()
                           .stroke(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 5)
                           .frame(width: 180, height: 180)
                           .shadow(color: .gray, radius: 10, x: 0, y: 4)

                       VStack {
                           // MARK: - Overall Points
                           Text("\(authViewModel.overallPoints)")
                               .font(.system(size: 56))
                               .fontWeight(.bold)
                               .foregroundColor(.primary)
                           Text("Overall Points")
                               .font(.title3)
                               .fontWeight(.medium)
                               .foregroundColor(.secondary)
                       }
                   }
                   .padding(.bottom, 20)

                   userInfoSection

                   actionButtonsSection
               }
               .padding()
               .navigationBarTitle("Settings", displayMode: .large)
           }
       }
    
    
    
    
    @ViewBuilder
    var userInfoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("User Email:")
                .font(.headline)
                .foregroundColor(.secondary)
            Text(authViewModel.email ?? "Not logged in")
                .font(.title2)
                .fontWeight(.bold)
            
           
            Text("Username:")
                .font(.headline)
                .foregroundColor(.secondary)
            Text(authViewModel.user?.userName ?? "Not available")
                .font(.title2)
                .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    
    
    
    @ViewBuilder
    var actionButtonsSection: some View {
        NavigationLink(destination: PrevAttemptsView(authViewModel: authViewModel)) {
            // MARK: - Previous Quiz Attempts button
            Label("Previous Quiz Attempts", systemImage: "list.bullet.rectangle")
                .labelStyle(.titleAndIcon)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
        }
        .padding(.bottom, 10)
        
      
        Button(action: logout) {
            // MARK: - Logout button
            Label("Logout", systemImage: "arrow.right.square")
                .labelStyle(.titleAndIcon)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .cornerRadius(10)
        }
    }

    
    
    
    func logout() {
        // Clear the authentication state
        authViewModel.isAuthenticated = false
        authViewModel.email = nil
        authViewModel.user = nil

        // Attempt to update the UI on the main thread
        DispatchQueue.main.async {
            // Get the app delegate
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

            // Reset the Core Data stack
            appDelegate.resetCoreDataStack()

            // After resetting the stack, get the new managed object context
            let managedObjectContext = appDelegate.persistentContainer.viewContext

            // Navigate to the login view
            if !self.authViewModel.isAuthenticated {
                UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: LoginView().environmentObject(self.authViewModel).environment(\.managedObjectContext, managedObjectContext))
            }
        }
    }
}




extension AppDelegate {
    static var preview: AppDelegate {
        let appDelegate = AppDelegate()
        // Setup Core Data stack for preview if necessary
        // This could be an in-memory store or a test database
        return appDelegate
    }
}




// Preview for SettingsView
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        // Initialize the AuthViewModel with mocked data
        let authViewModel = AuthViewModel()
        authViewModel.isAuthenticated = true
        authViewModel.email = "preview@example.com"
        return SettingsView().environmentObject(authViewModel)
    }
}
