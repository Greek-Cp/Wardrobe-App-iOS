//
//  SplachScreenView.swift
//  WardrobeApp1
//
//  Created by MacBook on 17/05/25.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var animate = false
    
    var body: some View {
        if isActive {
            DashboardView(modelContext: /* ganti dengan konteks yang kamu pakai */)
        } else {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack {
                    Image("MyWardrobe_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .opacity(animate ? 1 : 0)
                        .scaleEffect(animate ? 1 : 0.8)
                        .animation(.easeInOut(duration: 1.2), value: animate)
                    
                    Text("MyWardrobe")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 146/255, green: 198/255, blue: 164/255))
                        .opacity(animate ? 1 : 0)
                        .animation(.easeInOut(duration: 1.2).delay(0.3), value: animate)
                }
            }
            .onAppear {
                animate = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

