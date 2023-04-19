//
//  Home.swift
//  Drive Logger
//
//  Created by Zach Veenstra on 11/20/22.
//

/** This code is not used in the project, and was only used to design the look of the launch screen.
 The actual launch screen is just a screenshot of this view that is loaded into the assets of this project.**/

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        HStack {
            Image(systemName: "list.bullet.clipboard.fill")
                .foregroundColor(Color("AccentColor"))
                .font(.largeTitle)
            
            Text("Drive Logger")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(Color("AccentColor"))
                .italic()
        }

    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
