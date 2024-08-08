//
//  ImageButton.swift
//  Quiz for Kids
//
//  Created by Amru Hashim on 2/21/24.
//

import SwiftUI
struct ImageButton: View {
    let imageName: String
    @Binding var isSelected: Bool

    var body: some View {
        Button(action: {
            isSelected.toggle()
        }) {
            ZStack(alignment: .bottomTrailing) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 200)
                    .cornerRadius(10)
                    .clipped()

                if isSelected {
                    Rectangle()
                        .fill(Color.blue.opacity(0.5))
                        .frame(width: 150, height: 200)
                        .cornerRadius(10)
                        .blendMode(.multiply)

                    Rectangle()
                        .strokeBorder(Color.blue, lineWidth: 4)
                        .frame(width: 150, height: 200)
                        .cornerRadius(10)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding(8)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

