//
//  LoginView.swift
//  Quiz for Kids
//
//  Created by Amru Hashim on 2/21/24.
//


import SwiftUI
import CoreData
import Combine


// MARK: - Authentication View Model to manage user login session and overallPoints

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var user: User?
    @Published var email: String?
    private var cancellables = Set<AnyCancellable>()

    private var viewContext: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    @Published var overallPoints: Int = 0

    init() {
        setupObservers()
        updateOverallPoints()
    }

    private func setupObservers() {
        NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave, object: viewContext)
            .sink { [weak self] _ in
                self?.updateOverallPoints()
            }
            .store(in: &cancellables)
    }

    public func updateOverallPoints() {
        let fetchRequest: NSFetchRequest<UserScores> = UserScores.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userREL.email == %@", user?.email ?? "")

        do {
            let userScores = try viewContext.fetch(fetchRequest)
            self.overallPoints = Int(userScores.reduce(0) { $0 + ($1.qPoints) })
        } catch {
            print("Error fetching user scores: \(error)")
            self.overallPoints = 0
        }
    }
}






// MARK: -  LoginView

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var isSignInView = true
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var shouldNavigateToContentView = false
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = "Try Again!"


    var body: some View {
        NavigationView {
            VStack {
                Image("HeaderLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .padding(.top, 10)
                    .padding(.bottom, 50)
                
                Text(isSignInView ? "Sign In" : "Sign Up")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.bottom, 20)
                
                if !isSignInView {
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                }

                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)

                if isSignInView {
                    signInButton
                } else {
                    signUpButton
                }
                
                Button(action: toggleView) {
                    Text(isSignInView ? "Need an account? Sign Up" : "Already have an account? Sign In")
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .padding()
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
        .alert(isPresented: $showAlert) {
                        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }

        .onReceive(authViewModel.$isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                self.shouldNavigateToContentView = true
            }
        }
        .fullScreenCover(isPresented: $shouldNavigateToContentView) {
            ContentView()
        }
    }
    
    
    
    
    var signInButton: some View {
        Button(action: signIn) {
            Text("Sign In")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 220, height: 60)
                .background(Color.blue)
                .cornerRadius(15.0)
        }
    }

    
    
    
    var signUpButton: some View {
        Button(action: signUp) {
            Text("Sign Up")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 220, height: 60)
                .background(Color.blue)
                .cornerRadius(15.0)
        }
    }
    
    
    
    
    func toggleView() {
        isSignInView.toggle()
    }
    
    
   
    
    func signIn() {
        let fetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)

        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            // MARK: - Signin failed Alert
            if results.isEmpty {
                alertTitle = "Incorrect Username or Password"
                showAlert = true
            } else {
                print("Sign in successful")
                // Update the authentication state
                authViewModel.isAuthenticated = true
                // Fetch the user data
                if let user = results.first {
                    // Update the email property
                    authViewModel.email = user.email
                    // Update the user property
                    authViewModel.user = user
                    // Example of calling updateOverallPoints on authViewModel from a different class
                    authViewModel.updateOverallPoints()

                }
            }
        } catch {
            print("Error signing in: \(error)")
        }
    }

    func signUp() {
        let fetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)

        do {
            let existingUsers = try managedObjectContext.fetch(fetchRequest)

            if existingUsers.isEmpty {
                let newUser = User(context: managedObjectContext)
                newUser.email = email
                newUser.password = password
                newUser.userName = username
                authViewModel.updateOverallPoints()

                do {
                    try managedObjectContext.save()
                    print("Sign up successful. Email: \(email), Username: \(username), Password: \(password)")
                    // Update the authentication state
                    authViewModel.isAuthenticated = true
                    // Update the email property
                    authViewModel.email = email
                    // Fetch the user data
                    authViewModel.user = newUser
                } catch {
                    print("Error saving user: \(error)")
                }
            } else {
                // MARK: - Signup failed Alert
                alertTitle = "A user with this email already exists."
                showAlert = true
            }
        } catch {
            print("Error fetching users: \(error)")
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let authViewModel = AuthViewModel()

        return LoginView()
            .environment(\.managedObjectContext, context)
            .environmentObject(authViewModel)
    }
}
