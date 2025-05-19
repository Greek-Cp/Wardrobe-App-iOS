//
//  CustomNavigationBar.swift
//  WardrobeApp1
//
//  Created by MacBook on 19/05/25.
//

import SwiftUI

struct CustomNavigationBar: View {
    var title: String
    var backAction: () -> Void
    var backButtonColor: Color = Color(red: 146/255, green: 198/255, blue: 164/255)

    var body: some View {
        HStack {
            Button(action: backAction) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(backButtonColor)
                Text("Back")
                    .foregroundColor(backButtonColor)
            }
            Spacer()
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
            Spacer().frame(width: 60)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

