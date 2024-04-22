//
//  CoreDataManager.swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 21.04.2024.
//

import Foundation
import CoreData

final class CoreDataManager {
	
	// MARK: - Properties
	
	static let shared = CoreDataManager()
	
	var messages: [NSManagedObject] = []
	
	// MARK: - Core Data
	
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "Messages")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	// MARK: - Fetch Core Data
	
	func fetchData() -> [NSManagedObject] {
		let context = persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MessageEntity")
		
		do {
			messages = try context.fetch(fetchRequest)
			print("FetchCoreData successfully")
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
		return messages
	}
	
	// MARK: - Core Data Saving Methods
	
	func saveData(message: MessageViewModel) {
		let context = persistentContainer.viewContext
		let entity = NSEntityDescription.entity(forEntityName: "MessageEntity", in: context)!
		let messageEntity = NSManagedObject(entity: entity, insertInto: context)
		messageEntity.setValue(message.id, forKeyPath: "id")
		messageEntity.setValue(message.message, forKeyPath: "message")
		messageEntity.setValue(message.image, forKeyPath: "avatarUrl")
		messageEntity.setValue(message.date, forKeyPath: "date")
		
		do {
			try context.save()
			print("Data successfully saved.")
		} catch let error as NSError {
			print("Could not save. \(error), \(error.userInfo)")
		}
	}
	
	// MARK: - Core Data Delete Methods
	
	func deleteEntity(message: MessageViewModel) {
		let context = persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MessageEntity")
		fetchRequest.predicate = NSPredicate(format: "\("message") CONTAINS[cd] %@", message.message)
		
		do {
			let objects = try context.fetch(fetchRequest)
			for object in objects {
				context.delete(object)
			}
			try context.save()
			print("Delete successfully")
		}
		catch {
			print("error with delete coreData entity: \(error.localizedDescription)")
		}
	}
	
}

