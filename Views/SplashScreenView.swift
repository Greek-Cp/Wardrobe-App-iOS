import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var logoOffset: CGFloat = 0
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        if isActive {
            DashboardView(modelContext: modelContext)
        } else {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()

                    Image("LOGOLAGI")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                        .offset(y: logoOffset)
                        .onAppear {
                            // Animasi naik sedikit
                            withAnimation(.easeInOut(duration: 0.8)) {
                                logoOffset = -20
                            }

                            // Setelah 2 detik, masuk ke halaman utama
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation {
                                    isActive = true
                                }
                            }
                        }

                    Spacer()
                }
            }
        }
    }
}
