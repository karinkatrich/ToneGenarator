//
//  Service.swift
//  Quantum Frequency
//
//  Created by Karina on 08.08.16.
//  Copyright © 2016 Karina. All rights reserved.
//

import UIKit
import CoreData

class Service {
    
    static let shared = Service()
    let toneEntity: String = "ToneEntity"
    var managedObjectContext: NSManagedObjectContext
   

    init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = Bundle.main.url(forResource: "Sequences", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = psc
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex-1]
        
        /* The directory the application uses to store the Core Data store file.
         This code uses a file named "DataModel.sqlite" in the application's documents directory.
         */
        let storeURL = docURL.appendingPathComponent("Sequences.sqlite")
        do {
            
            var storageType = NSSQLiteStoreType
            
            

            try psc.addPersistentStore(ofType: storageType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    }
    
    
    class func createInManagedObjectContext(_ moc: NSManagedObjectContext, toneFrequency: NSNumber, toneLength: NSNumber, toneColor: String) -> ToneEntity {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "ToneEntity", into: moc) as! ToneEntity
        newItem.toneFrequecy = toneFrequency
        newItem.toneLength = toneLength
        newItem.toneColor = toneColor
        
        return newItem
    }
 
    
    //===========================================================================================
    
    
    func sequencesWithName(_ name: String) -> [SequenceEntity] {
        let predicate: NSPredicate = NSPredicate(format: "name == \"\(name)\"")
        return self.executeFetchRequest("SequenceEntity", predicate: predicate) as! [SequenceEntity]
    }
        
    
    //===========================================================================================
    

    func executeFetchRequest(_ entityName: String, predicate: NSPredicate?) -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        
        if(predicate != nil) {
            request.predicate = predicate
        }
        
        do {
            return try (self.managedObjectContext.fetch(request) as? [NSManagedObject])!
        } catch {
            return []
        }
    }
        
    
    //===========================================================================================
    
    
     func newToneEntity() -> ToneEntity {
        return NSEntityDescription.insertNewObject(forEntityName: "ToneEntity", into: self.managedObjectContext) as! ToneEntity
    }
 
    
    //===========================================================================================
    
    
    func newSequenceEntity() -> SequenceEntity {
        return NSEntityDescription.insertNewObject(forEntityName: "SequenceEntity", into: self.managedObjectContext) as! SequenceEntity
    }
        
    
    //===========================================================================================
    
    
    func saveContext() {
        if(self.managedObjectContext.hasChanges) {
            do {
                try self.managedObjectContext.save()
            } catch {
                
                print("error")
            }
        }
    }
        
    
    //===========================================================================================
    
    
    // Gets by id
   func getById(_ id: NSManagedObjectID) -> ToneEntity? {
        return managedObjectContext.object(with: id) as? ToneEntity
    }
    
    // Gets all with an specified predicate.

    
    //===========================================================================================
    
    
    // Updates a tone
    func update(_ updatedTone: ToneEntity){
        if let tone = getById(updatedTone.objectID){
            tone.toneColor = updatedTone.toneColor
            tone.toneFrequecy = updatedTone.toneFrequecy
            tone.toneLength = updatedTone.toneLength
        }
    }
        
    
    //===========================================================================================
    

    // Saves all changes
    func saveChanges(){
        do{
            try self.managedObjectContext.save()
        } catch let error as NSError {
            // failure
            print(error)
        }
    }
        
    
    //===========================================================================================
    
    
    // Delete 
    func delete(_ objects: [NSManagedObject]) {
        for obj: NSManagedObject in objects {
            self.managedObjectContext.delete(obj)
        }
        
        do {
            try self.managedObjectContext.save()
        }
        catch let error as NSError {
            print("Deletion failed: \(error.localizedDescription)")
        }
    }
        
    
    //===========================================================================================
    
    
    func deleteSequenceByTitle(_ title: String) {
        let sequencesToDelete = self.sequencesByTitle(title)
        
        self.delete(sequencesToDelete)
    }
     
    
    //===========================================================================================
    
    
    func allSequences() -> [SequenceEntity] {
        
        return self.executeFetchRequest("SequenceEntity", predicate: nil) as! [SequenceEntity]
    }
    
    func allTones() -> [ToneEntity] {
        
        return self.executeFetchRequest("ToneEntity", predicate: nil) as! [ToneEntity]
    }
        
    
    //===========================================================================================
    
    
    func customTones() -> [ToneEntity] {
        
        return self.executeFetchRequest("ToneEntity", predicate: NSPredicate(format: "sequenceEntity == nil")) as! [ToneEntity]
    }
        
    
    //===========================================================================================
    
    
    func sequencesByTitle(_ title: String) -> [SequenceEntity] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SequenceEntity")
        
        request.predicate = NSPredicate(format: "name = %@", title);
        
        var sequences:[SequenceEntity] = []
        
        do {
            sequences = try self.managedObjectContext.fetch(request) as! [SequenceEntity]
            
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        return sequences
    }
    
    
    //===========================================================================================
    
    
    func deleteToneEntityByTone(_ tone: Tone) {
        self.delete(self.toneEntityByTone(tone))
    }
    
 
    func toneEntityByTone(_ tone: Tone) -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ToneEntity")
        
        request.predicate = NSPredicate(format: "toneColor = %@ AND toneFrequecy = %@", tone.color.toHexString(), NSNumber.init(value: tone.frequency as Int));
    
        var tones:[NSManagedObject] = []
        
        do {
            tones = try self.managedObjectContext.fetch(request) as! [NSManagedObject]
            
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        return tones
    }
    
    
    //===========================================================================================
    
    
    //store data
    
    func save(_ name:String)
    {
        let managedContext = self.managedObjectContext
        //Data is in this case the name of the entity
        let entity = NSEntityDescription.entity(forEntityName: "ToneEntity",
                                                       in: managedContext)
        let options = NSManagedObject(entity: entity!,
                                      insertInto:managedContext)
        
        options.setValue(name, forKey: "name")
        
        do {
            try managedContext.save()
        } catch
        {
            print("error")
        }
    }
            
    
    //===========================================================================================
    
    
    //read data
    
    func read()
    {
        do {
            
            let managedContext = self.managedObjectContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToneEntity")
            
            let fetchedResults = try managedContext.fetch(fetchRequest)
            
            for i in 0...fetchedResults.count
            {
                let single_result = fetchedResults[i]
                let out = (single_result as AnyObject).value(forKey: "name") as! String
                print(out)
            }
            
        }
        catch
        {
            print("error")
        }
        
    }
        
    
    //===========================================================================================
    

    //clear data

    func deleteEntity(_ entityToDelete:NSManagedObject) {
        managedObjectContext.delete(entityToDelete)
        saveContext()
    }
    
    
    //===========================================================================================
    
    
    func clearData()
    {
        do
        {
            let managedContext = self.managedObjectContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToneEntity")
            let fetchedResults = try managedContext.fetch(fetchRequest)
            for i in 0...fetchedResults.count
            {
                let value = fetchedResults[i]
                managedContext.delete(value as! NSManagedObject)
                try managedContext.save()
            }
        }
        catch
        {
            print("error")
        }
    }
}
