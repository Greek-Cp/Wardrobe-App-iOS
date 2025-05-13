import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        // Panggil DashboardView dari struktur MVC kita
        DashboardView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: WardrobeItem.self, inMemory: true)
}
