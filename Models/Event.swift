import Foundation
import CoreLocation

struct Event: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var description: String
    var date: Date
    var locationName: String
    var latitude: Double
    var longitude: Double
    var category: String
    var imageName: String
    var isSaved: Bool = false
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // For previews and testing
    static let sampleEvents: [Event] = [
        Event(id: UUID(), 
              title: "Tech Conference 2023", 
              description: "Annual technology conference with industry leaders.",
              date: Date().addingTimeInterval(86400 * 7), // 7 days from now
              locationName: "Convention Center",
              latitude: 37.3346, 
              longitude: -122.0090,
              category: "Technology",
              imageName: "event1"),
        Event(id: UUID(), 
              title: "Jazz Night", 
              description: "An evening of smooth jazz with local artists.",
              date: Date().addingTimeInterval(86400 * 3), // 3 days from now
              locationName: "Downtown Club",
              latitude: 37.3323, 
              longitude: -122.0112,
              category: "Music",
              imageName: "event2")
    ]
}
