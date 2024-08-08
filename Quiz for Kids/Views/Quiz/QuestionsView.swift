//
//  QuestionsView.swift
//  Quiz for Kids
//
//  Created by Amru Hashim on 2/21/24.
//

import SwiftUI
import CoreData


struct Details: Identifiable {
    var id = UUID()
    var question: String
    var correctAns: Int
    var option1ImageName: String
    var option2ImageName: String
    var option3ImageName: String
    var option4ImageName: String
}



let columns = [
    GridItem(.flexible()),
    GridItem(.flexible())
]



enum ActiveAlert: Identifiable {
    case noAnswerSelected, quizFinished
    var id: Self { self }
}




struct QuestionsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var show: Bool
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswers: [Int: Int] = [:]
    @State private var selectedQuestions: [Details] = []
    @State private var correctAnswers = 0
    @State private var incorrectAnswers = 0
    @State private var activeAlert: ActiveAlert?
    @State private var resultsMessage = ""
    @State private var currentPoints = 0
    @Binding var quizArea: String
    @State private var quizStartDate: Date?
    @State private var quizStartTimeString: String?

    init(quizArea: Binding<String>, show: Binding<Bool>) {
        self._quizArea = quizArea
        self._show = show
    }

    var body: some View {
        if selectedQuestions.isEmpty {
            Text("No questions available")
                .onAppear {
                    selectedQuestions = loadRandomQuestions(for: quizArea)
                    let now = Date()
                     quizStartDate = now // Store the start date
                     quizStartTimeString = formatTime(from: now)
                }
        } else {
            VStack {
                Button(action: {
                    currentQuestionIndex = 0
                    selectedQuestions = loadRandomQuestions(for: quizArea)
                    selectedAnswers.removeAll()
                    withAnimation(.spring()){
                        show.toggle()
                    }
                }) {
                    Text("Close")
                        .fontWeight(.bold)
                        .font(.system(size: 13))
                }
                .foregroundColor(.red)
                .padding(.bottom, 5)

             
                
                // MARK: - Question number
                Text("Question \(currentQuestionIndex + 1)/\(selectedQuestions.count)")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                        .padding(.top, 5)
                        .padding(.bottom, 8)
       
                // MARK: - Question
                let currentDetails = selectedQuestions[currentQuestionIndex]
                Text(currentDetails.question)
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                    .font(.system(size: 20))
                    .padding(.horizontal, 32)
                
                Spacer().frame(height: 10)
                
                // MARK: - Choices
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(1...4, id: \.self) { index in
                            let optionImageName = self.getOptionImageName(for: index)
                            ImageButton(imageName: optionImageName, isSelected: Binding(
                                get: {
                                    selectedAnswers[currentQuestionIndex] == index
                                },
                                set: { newValue in
                                    selectedAnswers[currentQuestionIndex] = newValue ? index : nil
                                }
                            ))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                Spacer()
                
                HStack {
                   
                    if currentQuestionIndex > 0 {
                        Button(action: {
                            previousQuestion()
                        }) {
                            Text("Previous")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .clipShape(RoundedRectangle(cornerRadius: 40))
                        }
                    } else {
                    
                        Spacer()
                            .frame(maxWidth: .infinity)
                            .hidden()
                    }

                    Spacer()

                    // Next or Finish Button
                    if currentQuestionIndex < selectedQuestions.count - 1 {
                        Button(action: {
                            nextQuestion()
                        }) {
                            Text("Next")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .clipShape(RoundedRectangle(cornerRadius: 40))
                        }
                    } else {
                        Button(action: {
                            finishQuizAttempt()
                            authViewModel.updateOverallPoints()
                        }) {
                            Text("Finish Attempt")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.yellow]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .clipShape(RoundedRectangle(cornerRadius: 40))
                        }
                    }
                }
                .padding(.horizontal, 20)
                           }
            
            .alert(item: $activeAlert) { activeAlert in
                switch activeAlert {
                case .noAnswerSelected:
                    return Alert(
                        title: Text("No Answer Selected"),
                        message: Text("Please select an answer before proceeding."),
                        dismissButton: .default(Text("OK"))
                    )
                case .quizFinished:
                    return Alert(
                        title: Text("Overall Points: \(authViewModel.overallPoints)"),
                        message: Text(resultsMessage),
                        dismissButton: .default(Text("OK")) {
                            // Actions to perform when the "OK" button is pressed
                            show = false // Dismiss the current quiz view
                            // Reset the quiz state if necessary
                            currentQuestionIndex = 0
                            selectedQuestions = loadRandomQuestions(for: quizArea)
                            selectedAnswers.removeAll()
                        }
                    )
                }
            }

            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            .background(
                Group {
                    if quizArea == "Animals" {
                        Image("AnimalsBG")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                    } else if quizArea == "Cartoons" {
                        Image("CartoonsBG")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                    } else {
                        Image("DefaultBG")// for testing only
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                    }
                }
            )
            .navigationBarHidden(true)
        }
    }

    
    private func nextQuestion() {
        guard selectedAnswers[currentQuestionIndex] != nil else {
            activeAlert = .noAnswerSelected
            return
        }

        if currentQuestionIndex < selectedQuestions.count - 1 {
            currentQuestionIndex += 1
        }
    }
    
    
    

    private func previousQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
        }
    }

    
    
    // MARK: - Finish Quiz Attempt function
    private func finishQuizAttempt() {
        guard selectedAnswers[currentQuestionIndex] != nil else {
            activeAlert = .noAnswerSelected
            return
        }

        // Calculate correct and incorrect answers
        correctAnswers = 0
        incorrectAnswers = 0
        for (index, details) in selectedQuestions.enumerated() {
            if let selectedAnswer = selectedAnswers[index], selectedAnswer == details.correctAns {
                correctAnswers += 1
            } else {
                incorrectAnswers += 1
            }
        }

        // Calculate current points
        currentPoints = (correctAnswers * 3) - (incorrectAnswers * 1)

        // Prepare the results message
        resultsMessage = "You have finished the “\(quizArea)” quiz with \(correctAnswers) correct and \(incorrectAnswers) incorrect answers or \(currentPoints) points for this attempt."
        
        saveQuizResultsToCoreData()
        // Trigger the results alert
        activeAlert = .quizFinished
    }

    
    
    
    private func formatTime(from date: Date) -> String {
        let formatter = DateFormatter()
        // Set the desired format for hours and minutes without seconds
        formatter.dateFormat = "HH:mm" // 24-hour format with hour and minute
        return formatter.string(from: date)
    }

    

    func getOptionImageName(for index: Int) -> String {
        let quizDetails = selectedQuestions[currentQuestionIndex]
        switch index {
        case 1: return quizDetails.option1ImageName
        case 2: return quizDetails.option2ImageName
        case 3: return quizDetails.option3ImageName
        case 4: return quizDetails.option4ImageName
        default: return ""
        }
    }
    
    
    
    
    private func loadRandomQuestions(for area: String) -> [Details] {
        guard let areaQuestions = questionBank[area] else { return [] }
        return areaQuestions.shuffled().prefix(4).map { $0 }
    }
    
    
    
    // MARK: - Saving Quiz data to coredata
    private func saveQuizResultsToCoreData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Fetch the existing user instead of creating a new one
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "email == %@", authViewModel.user?.email ?? "")
        
        do {
            let users = try context.fetch(fetchRequest)
            
            if let user = users.first {
                // User found, add scores to this user
                let userScores = UserScores(context: context)
                userScores.qArea = quizArea
                userScores.qDate = quizStartDate
                userScores.qTime = quizStartTimeString
                userScores.qPoints = Int16(currentPoints)
                user.addToScoresREL(userScores)
                
                try context.save()
               
            } else {
                print("User not found")
            }
        } catch {
            print("Failed to fetch user or save quiz results to Core Data: \(error)")
        }
    }
}




