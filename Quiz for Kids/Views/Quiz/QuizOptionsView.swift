//
//  QuizOptionsView.swift
//  Quiz for Kids
//
//  Created by Amru Hashim on 2/21/24.
//

import SwiftUI

// Model to  represent each  Quiz
struct Category: Identifiable {
    var id = UUID()
    var title: String
    var size: CGFloat
    var gridItem: [GridItem]
    var cardHeight: CGFloat
}


let category = [
    Category(title: "Quiz Areas", size: 25, gridItem: Array(repeating: GridItem(.fixed(230), spacing: 7), count: 2), cardHeight: 210)
]


struct QuizOptionsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    
    
    var quizCategory: [Category] {
        category.filter { $0.title.lowercased() == "quiz areas" }
    }
    
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                // Header logo
                Image("HeaderLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .padding(.top, 10)
                
                Spacer(minLength: 50)

                // Welcome message for the user
                if authViewModel.isAuthenticated {
                    Text("Welcome, \(authViewModel.user?.userName ?? "User")!")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(.bottom, 10)
                        .padding(.horizontal)
                    
                    Text("Overall Points: \(authViewModel.overallPoints)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(
                            Rectangle()
                                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(10)
                        )
                        .padding(.horizontal)
                }

                ForEach(quizCategory) { categoryItem in
                    VStack(spacing: 10) {
                        HStack {
                            Text(categoryItem.title)
                                .font(.custom("Helvetica Neue", size: categoryItem.size))
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 25)
                        }
                        QuizAreaCards(cardHeight: categoryItem.cardHeight)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, -20)
                    }
                    .padding(.top, 10)
                }
            }
            .padding(.bottom, 20)
        }
    }
}

