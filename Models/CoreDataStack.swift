import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EventDataModel")
        
        // Create the model programmatically
        let model = NSManagedObjectModel()
        
        // Create the EventEntity entity
        let eventEntity = NSEntityDescription()
        eventEntity.name = "EventEntity"
        eventEntity.managedObjectClassName = "EventEntity"
        
        // Create attributes
        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.attributeType = .UUIDAttributeType
        idAttribute.isOptional = false
        
        let titleAttribute = NSAttributeDescription()
        titleAttribute.name = "title"
        titleAttribute.attributeType = .stringAttributeType
        titleAttribute.isOptional = true
        
        let descriptionAttribute = NSAttributeDescription()
        descriptionAttribute.name = "eventDescription"
        descriptionAttribute.attributeType = .stringAttributeType
        descriptionAttribute.isOptional = true
        
        let dateAttribute = NSAttributeDescription()
        dateAttribute.name = "date"
        dateAttribute.attributeType = .dateAttributeType
        dateAttribute.isOptional = true
        
        let locationNameAttribute = NSAttributeDescription()
        locationNameAttribute.name = "locationName"
        locationNameAttribute.attributeType = .stringAttributeType
        locationNameAttribute.isOptional = true
        
        let latitudeAttribute = NSAttributeDescription()
        latitudeAttribute.name = "latitude"
        latitudeAttribute.attributeType = .doubleAttributeType
        latitudeAttribute.isOptional = false
        latitudeAttribute.defaultValue = 0.0
        
        let longitudeAttribute = NSAttributeDescription()
        longitudeAttribute.name = "longitude"
        longitudeAttribute.attributeType = .doubleAttributeType
        longitudeAttribute.isOptional = false
        longitudeAttribute.defaultValue = 0.0
        
        let categoryAttribute = NSAttributeDescription()
        categoryAttribute.name = "category"
        categoryAttribute.attributeType = .stringAttributeType
        categoryAttribute.isOptional = true
        
        let imageNameAttribute = NSAttributeDescription()
        imageNameAttribute.name = "imageName"
        imageNameAttribute.attributeType = .stringAttributeType
        imageNameAttribute.isOptional = true
        
        // Add attributes to entity
        eventEntity.properties = [
            idAttribute,
            titleAttribute,
            descriptionAttribute,
            dateAttribute,
            locationNameAttribute,
            latitudeAttribute,
            longitudeAttribute,
            categoryAttribute,
            imageNameAttribute
        ]
        
        // Create the model
        model.entities = [eventEntity]
        
        // Create the persistent container with our model
        let container = NSPersistentContainer(name: "EventDataModel", managedObjectModel: model)
        
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
