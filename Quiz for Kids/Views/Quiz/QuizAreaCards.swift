//
//  QuizAreaCards.swift
//  Quiz for Kids
//
//  Created by Amru Hashim on 2/21/24.
//

import SwiftUI

struct QuizAreaCards: View {
    var cardHeight: CGFloat
    var quizAreaIMG = ["Animals", "Cartoons"] // List of quizes
    
    @State private var showModal = false // State to control modal presentation
    @State private var selected = "" // Selected quiz
    
    // Calculate grid columns dynamically based on screen width
    private var columns: [GridItem] {
        let numberOfItemsPerRow = 2
        let availableWidth = UIScreen.main.bounds.width - (45 * 2)
        let itemWidth = (availableWidth / CGFloat(numberOfItemsPerRow)) - 15
        return Array(repeating: .init(.flexible(minimum: itemWidth)), count: numberOfItemsPerRow)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(quizAreaIMG, id: \.self) { loc in
                    Button(action: {
                        self.showModal = true
                        self.selected = loc
                    }) {
                        VStack(alignment: .leading, spacing: 15) {
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .frame(height: 40)
                                Text(loc)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                            .padding()
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 10)
                        .frame(height: self.cardHeight)
                        .background(
                            Image(loc)
                                .resizable()
                                .scaledToFill()
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .shadow(color: Color.gray.opacity(0.5), radius: 5, x:0, y:2)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: self.$showModal) {
                        QuestionsView(quizArea: $selected, show: $showModal)
                    }
                }
            }
            .padding(.horizontal, 45)
            .padding(.top, 10)
        }
    }
}


