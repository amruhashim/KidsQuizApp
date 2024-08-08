//
//  SceneDelegate.swift
//  Quiz for Kids
//
//  Created by Amru Hashim on 2/21/24.
//

import UIKit
import SwiftUI
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let authViewModel = AuthViewModel() // Instantiate AuthViewModel

    func isUserAuthenticated() -> Bool {
        // Directly return the authentication state
        // For demonstration, we keep using UserDefaults here
        return UserDefaults.standard.bool(forKey: "isUserAuthenticated")
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext

        let launchScreenView = LaunchScreenView(horizontalPadding: 90)
        let window = UIWindow(windowScene: windowScene)
        
        // Pass the managedObjectContext instance to the UIHostingController instances
        let loginView = UIHostingController(rootView: LoginView().environment(\.managedObjectContext, managedObjectContext).environmentObject(self.authViewModel))
        let contentView = UIHostingController(rootView: ContentView().environment(\.managedObjectContext,managedObjectContext).environmentObject(self.authViewModel))

        window.rootViewController = loginView
        self.window = window
        window.makeKeyAndVisible()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Update AuthViewModel based on UserDefaults check
            self.authViewModel.isAuthenticated = self.isUserAuthenticated()

            // Fetch user data if authenticated
            if self.authViewModel.isAuthenticated {
                    let fetchRequest = NSFetchRequest<User>(entityName: "User")
                    // It's important to unwrap the email safely or provide a default value
                    fetchRequest.predicate = NSPredicate(format: "email == %@", self.authViewModel.email ?? "")

                    do {
                        let fetchedUsers = try managedObjectContext.fetch(fetchRequest)
                        if let user = fetchedUsers.first {
                            DispatchQueue.main.async {
                                // Update AuthViewModel with fetched user data
                                self.authViewModel.user = user
                                let userEmail = user.email
                            }
                        }
                    } catch {
                        print("Failed to fetch user: \(error)")
                    }
                }

            // Determine the initial view based on authentication status
            let initialView: AnyView
            if self.authViewModel.isAuthenticated {
                // User is authenticated, show ContentView
                initialView = AnyView(ContentView().environment(\.managedObjectContext, managedObjectContext).environmentObject(self.authViewModel))
            } else {
                // User is not authenticated, show LoginView
                initialView = AnyView(LoginView().environment(\.managedObjectContext, managedObjectContext).environmentObject(self.authViewModel))
            }

            self.window?.rootViewController = UIHostingController(rootView: initialView)
        }
    }




    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

