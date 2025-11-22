import SwiftUI

@main
struct LocalEventFinderApp: App {
    @StateObject private var eventStore = EventStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(eventStore)
                .onAppear {
                    // Load sample data on first launch
                    if eventStore.events.isEmpty {
                        eventStore.loadSampleData()
                    }
                }
        }
    }
}
