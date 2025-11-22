import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                MapHomeView()
            }
            .tabItem {
                Label("Map", systemImage: "map")
            }
            .tag(0)
            
            NavigationStack {
                EventListView()
            }
            .tabItem {
                Label("Events", systemImage: "list.bullet")
            }
            .tag(1)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(EventStore())
}
