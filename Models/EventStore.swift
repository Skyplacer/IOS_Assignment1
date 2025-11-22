import Foundation
import CoreData
import CoreLocation

class EventStore: ObservableObject {
    @Published var events: [Event] = []
    
    // MARK: - Core Data Stack
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "EventDataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        context = container.viewContext
        
        // Load events from Core Data on init
        loadEvents()
    }
    
    // MARK: - Event Management
    
    func loadEvents() {
        let request = NSFetchRequest<EventEntity>(entityName: "EventEntity")
        
        do {
            let eventEntities = try context.fetch(request)
            self.events = eventEntities.map { eventEntity in
                Event(
                    id: eventEntity.id ?? UUID(),
                    title: eventEntity.title ?? "",
                    description: eventEntity.eventDescription ?? "",
                    date: eventEntity.date ?? Date(),
                    locationName: eventEntity.locationName ?? "",
                    latitude: eventEntity.latitude,
                    longitude: eventEntity.longitude,
                    category: eventEntity.category ?? "",
                    imageName: eventEntity.imageName ?? "",
                    isSaved: true
                )
            }
        } catch {
            print("Error fetching events: \(error)")
        }
    }
    
    func saveEvent(_ event: Event) {
        // Check if event already exists
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index].isSaved = true
            updateEventInCoreData(event)
        } else {
            var newEvent = event
            newEvent.isSaved = true
            events.append(newEvent)
            saveToCoreData(newEvent)
        }
    }
    
    func removeEvent(_ event: Event) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index].isSaved = false
            deleteFromCoreData(eventId: event.id)
        }
    }
    
    // MARK: - Sample Data
    
    func loadSampleData() {
        // Only load sample data if we don't have any events
        guard events.isEmpty else { return }
        
        let sampleEvents = Event.sampleEvents
        for event in sampleEvents {
            saveToCoreData(event)
        }
        loadEvents()
    }
    
    // MARK: - Core Data Operations
    
    private func saveToCoreData(_ event: Event) {
        let eventEntity = EventEntity(context: context)
        updateEventEntity(eventEntity, with: event)
        saveContext()
    }
    
    private func updateEventInCoreData(_ event: Event) {
        let request = NSFetchRequest<EventEntity>(entityName: "EventEntity")
        request.predicate = NSPredicate(format: "id == %@", event.id as CVarArg)
        
        do {
            if let eventEntity = try context.fetch(request).first {
                updateEventEntity(eventEntity, with: event)
                saveContext()
            }
        } catch {
            print("Error updating event: \(error)")
        }
    }
    
    private func deleteFromCoreData(eventId: UUID) {
        let request = NSFetchRequest<EventEntity>(entityName: "EventEntity")
        request.predicate = NSPredicate(format: "id == %@", eventId as CVarArg)
        
        do {
            if let eventEntity = try context.fetch(request).first {
                context.delete(eventEntity)
                saveContext()
            }
        } catch {
            print("Error deleting event: \(error)")
        }
    }
    
    private func updateEventEntity(_ eventEntity: EventEntity, with event: Event) {
        eventEntity.id = event.id
        eventEntity.title = event.title
        eventEntity.eventDescription = event.description
        eventEntity.date = event.date
        eventEntity.locationName = event.locationName
        eventEntity.latitude = event.latitude
        eventEntity.longitude = event.longitude
        eventEntity.category = event.category
        eventEntity.imageName = event.imageName
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}

// MARK: - Core Data Model
class EventEntity: NSManagedObject {
    @NSManaged var id: UUID?
    @NSManaged var title: String?
    @NSManaged var eventDescription: String?
    @NSManaged var date: Date?
    @NSManaged var locationName: String?
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var category: String?
    @NSManaged var imageName: String?
}

extension EventEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventEntity> {
        return NSFetchRequest<EventEntity>(entityName: "EventEntity")
    }
}
