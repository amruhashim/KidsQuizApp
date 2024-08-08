//
//  InstructiontView.swift
//  Quiz for Kids
//
//  Created by Amru Hashim on 2/21/24.
//

import SwiftUI

struct InstructionView: View {
    @State private var expandedRuleID: UUID?
    @Binding var selection: Int

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Button container
                HStack {
                    Button(action: {
                        self.selection = 0
                    }) {
                        HStack {
                            Image(systemName: "gamecontroller.fill")
                                .font(.title)
                            Text("Press to do quizzes, yay!")
                                .fontWeight(.bold)
                                .font(.system(size: 20))
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(15)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
               
                ScrollView {
                    VStack {
                       
                        Spacer().frame(height: 20)
                        
                        LazyVStack(alignment: .leading, spacing: 20) {
                            ForEach(rulesData, id: \.id) { rule in // Ensure rulesData elements are identifiable
                                InstructionCard(rule: rule, isExpanded: rule.id == expandedRuleID)
                                    .onTapGesture {
                                        withAnimation {
                                            if expandedRuleID == rule.id {
                                                expandedRuleID = nil
                                            } else {
                                                expandedRuleID = rule.id
                                            }
                                        }
                                    }
                            }
                        }
                        .padding([.horizontal, .bottom])
                    }
                }

            }
            .navigationBarTitle("Instructions", displayMode: .large)
        }
    }
}


struct InstructionCard: View {
    var rule: Rule
    var isExpanded: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(rule.question)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                Spacer()
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.blue)
                    .font(.headline)
            }

            if isExpanded {
                Text(rule.details)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal)
        
    }
    
}

struct Rule: Identifiable {
    var id = UUID()
    var question: String
    var details: String
}

// MARK: - Instructions
let rulesData = [
    Rule(question: "How to choose an Answer?", details: "Select your answer by tapping on the corresponding image cards for each question."),
    Rule(question: "Point Rewarding System", details: "Your score is calculated based on the number of correct and incorrect answers: 3 points for each correct answer and -1 point for each incorrect answer."),
    Rule(question: "Number of Questions", details: "Each quiz attempt consists of 4 randomly selected questions from the quiz area."),
    Rule( question: "Quiz Navigation",
          details: "- **First Question:** You cannot go back to the previous question because there is no previous question.\n- **Second to Fourth Question:** You can navigate back to previous questions. This allows for review and changes before final submission.\n- **Fourth Question:** The navigation button will change to a \"Finish Attempt\" button instead of a \"Next\" button. This is to submit the quiz."),
    Rule(question: "Exiting a Quiz",
         details: "Any Time Before Completion: You can exit a quiz by pressing the close button located at the top of the quiz sheet. If the quiz is not finished, no data will be saved. This allows for exit without consequence if you cannot complete the quiz."),
    Rule(question: "Check Previos Quiz Attempts", details: "Simply navigate to Settings Tab and press the \"Previos Quiz Attempts\" button.")
]



#if DEBUG
struct InstructionView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionView(selection: .constant(0))
    }
}
#endif
