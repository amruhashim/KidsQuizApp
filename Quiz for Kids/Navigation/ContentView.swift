//
//  ContentView.swift
//  Quiz for Kids
//
//  Created by Amru Hashim on 2/21/24.
//

import SwiftUI

struct ContentView: View {
   
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var selection: Int = 0
    
    var body: some View {
        // MARK: - Tab bar items
        TabView(selection: $selection) {
            QuizOptionsView()
                .environmentObject(authViewModel)
                .tag(0)
            
            InstructionView(selection: $selection) 
                           .tag(1)
            
            SettingsView()
                .tag(2)
        }
        .overlay(
            Color.white
                .edgesIgnoringSafeArea(.vertical)
                .frame(height: 70)
                .overlay(HStack(spacing: 0) {
                    Button(action: {
                        self.selection = 0
                    }) {
                        VStack {
                            Image(systemName: "gamecontroller.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 34, height: 25)
                                .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                                .opacity(selection == 0 ? 1 : 0.4)
                            Text("Quiz") // Text label
                                .font(.caption)
                                .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                                .opacity(selection == 0 ? 1 : 0.4)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                   
                    Button(action: {
                        self.selection = 1
                    }) {
                        VStack {
                            Image(systemName: "book.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                                .opacity(selection == 1 ? 1 : 0.4)
                            Text("Instructions") // Text label
                                .font(.caption)
                                .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                                .opacity(selection == 1 ? 1 : 0.4)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                  
                    Button(action: {
                        self.selection = 2
                    }) {
                        VStack {
                            Image(systemName: "gear")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                                .opacity(selection == 2 ? 1 : 0.4)
                            Text("Settings") // Text label
                                .font(.caption)
                                .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                                .opacity(selection == 2 ? 1 : 0.4)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }), alignment: .bottom
        )
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
            
    }
}
