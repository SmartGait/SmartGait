//
//  CoreDataManager.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 27/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreData
import Foundation
import LNRSimpleNotifications

class CoreDataManager {
  static let sharedInstance = CoreDataManager()
  let notificationManager = NotificationManager.sharedInstance

  // MARK: - Core Data stack
  lazy var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentContainer(name: "SmartGait")

    container.viewContext.automaticallyMergesChangesFromParent = true

    container.loadPersistentStores(completionHandler: { (_, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate.
        //You should not use this function in a shipping application, although it may be useful during development.

        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()

  // MARK: - Core Data Saving support
  func save (context: NSManagedObjectContext) {
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate.
        //You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }

  // MARK: - Core Data Context support
  lazy var viewContext: NSManagedObjectContext = {
    return self.persistentContainer.viewContext
  }()

  lazy var backgroundContext: NSManagedObjectContext = {
    return self.persistentContainer.newBackgroundContext()
  }()

  func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
    self.viewContext.perform {
      block(self.viewContext)
    }
  }

  func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
    self.persistentContainer.performBackgroundTask(block)
  }

  func saveToCoreData(task: Task) {
    performBackgroundTask { (context) in
      _ = task.getCoreDataObject(for: context)
      let notification = LNRNotification(
        title: NSLocalizedString("WillSaveTitle", comment: ""),
        body: String.localizedStringWithFormat(NSLocalizedString("WillSaveBody", comment: ""), task.identifier!)
      )
      self.notificationManager.show(notification: notification)

      do {
        try context.save()
        let notification = LNRNotification(
          title: NSLocalizedString("SuccessTitle", comment: ""),
          body: String.localizedStringWithFormat(NSLocalizedString("SuccessBody", comment: ""), task.identifier!)
        )
        self.notificationManager.show(notification: notification)
      } catch let error {
        let notification = LNRNotification(
          title: NSLocalizedString("ErrorTitle", comment: ""),
          body: String.localizedStringWithFormat(NSLocalizedString("ErrorBody", comment: ""), task.identifier!)
        )
        self.notificationManager.show(notification: notification)
        log.error(error)
      }
    }
  }

  private init() {

  }
}
