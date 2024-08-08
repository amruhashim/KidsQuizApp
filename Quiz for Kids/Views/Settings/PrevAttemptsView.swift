//
//  PrevAttemptsView.swift
//  Quiz for Kids
//
//  Created by Amru Hashim on 2/22/24.
//

import SwiftUI
import CoreData


struct PrevAttemptsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @FetchRequest var userScores: FetchedResults<UserScores>
    

    init(authViewModel: AuthViewModel) {
        let fetchRequest: NSFetchRequest<UserScores> = UserScores.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userREL.email == %@", authViewModel.user?.email ?? "")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \UserScores.qDate, ascending: false)]

        _userScores = FetchRequest(fetchRequest: fetchRequest)
    }

    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("Overall Points: \(authViewModel.overallPoints)")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                    .padding(.horizontal, 120)
            }
            .padding(.bottom, 4)
            .background(Color.white)
            .frame(maxWidth: .infinity)
            
            // MARK: - List of Prev Attempts with Details
            // List for the user scores
            List {
                if userScores.isEmpty {
                    Text("No quiz results found.")
                        .font(.title3)
                        .padding()
                        .listRowBackground(Color.clear)
                } else {
                    ForEach(userScores, id: \.self) { userScore in
                        VStack(alignment: .leading) {
                            Text("\(userScore.qArea ?? "N/A")")
                                .font(.headline)
                            Text("Attempt started on \(formatDate(userScore.qDate)) at \(userScore.qTime ?? "N/A")")
                                .font(.subheadline)
                            Text("Points earned: \(userScore.qPoints)")
                                .font(.subheadline)
                        }
                        .padding(.vertical, 8)
                        .listRowBackground(Color.clear)
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationBarTitle("Previous Attempts", displayMode: .inline)
    }
    



    func formatDate(_ date: Date?) -> String {
        guard let date = date else {
            return "N/A"
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date)
    }
}



struct PrevAttemptsView_Previews: PreviewProvider {
    static var previews: some View {
        let authViewModel = AuthViewModel()
        PrevAttemptsView(authViewModel: authViewModel).environmentObject(authViewModel)
    }
}

