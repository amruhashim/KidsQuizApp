//
//  LaunchScreenView.swift
//  Quiz for Kids
//
//  Created by Amru Hashim on 2/21/24.
//

import SwiftUI

struct LaunchScreenView: View {
    var horizontalPadding: CGFloat = 50
    
    var body: some View {
        VStack {
            Spacer()
            Image("LaunchScreen")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, horizontalPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
            Spacer()
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
