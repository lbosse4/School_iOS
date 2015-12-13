//
//  ViewTeamsDataSource.swift
//  US States
//
//  Created by John Hannan on 7/2/15.
//  Modified by Lauren Bosse
//  Copyright (c) 2015 John Hannan. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol ViewTeamsDataSourceCellConfigurer {
    func configureCell(cell:PlayerTableViewCell, withObject object:NSManagedObject) -> Void
    func cellIdentifierForObject(object: NSManagedObject) -> String
}

class ViewTeamsDataSource : NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    weak var tableView : UITableView? {
        didSet {
            fetchedResultsController.delegate = self
        }
    }
    let dataManager = DataManager.sharedInstance
    var delegate : ViewTeamsDataSourceCellConfigurer?
    
    let fetchRequest : NSFetchRequest
    
    var fetchedResultsController : NSFetchedResultsController
    
    
    init(entity:String, sortKeys:[String], predicate:NSPredicate?, sectionNameKeyPath:String?, delegate:DataManagerDelegate) {
        
        let dataManager = DataManager.sharedInstance
        dataManager.delegate = delegate
        
        var sortDescriptors : [NSSortDescriptor] = Array()
        for key in sortKeys {
            let descriptor = NSSortDescriptor(key: key, ascending: true)
            sortDescriptors.append(descriptor)
        }
        
        
        fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataManager.managedObjectContext!, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)
        
        
        var error: NSError? = nil
        do {
            try fetchedResultsController.performFetch()
        } catch let error1 as NSError {
            error = error1
            print("Unresolved error \(error), \(error!.userInfo)")
            //abort()
        }
    }
    
    func sortDescriptorsFromStrings(sortKeys:[String]) -> [NSSortDescriptor] {
        var sortDescriptors : [NSSortDescriptor] = Array()
        for key in sortKeys {
            let descriptor = NSSortDescriptor(key: key, ascending: true)
            sortDescriptors.append(descriptor)
        }
        return sortDescriptors
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let count = self.fetchedResultsController.sections?.count ?? 0
        return count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let managedObject = objectAtIndexPath(indexPath)
        let cellIdentifier = delegate!.cellIdentifierForObject(managedObject)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PlayerTableViewCell
        
        delegate?.configureCell(cell, withObject: managedObject)
        //self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = self.fetchedResultsController.sections![section]
        let name = sectionInfo.name
        return name
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return fetchedResultsController.sectionIndexTitles
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return fetchedResultsController.sectionForSectionIndexTitle(title, atIndex: index)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)
            
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //print("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
        
        /*
        if editingStyle == .Delete {
        deleteRowAtIndexPath(indexPath)
        update()
        dataManager.saveContext()
        
        if tableView.numberOfRowsInSection(indexPath.section) == 1 {  // deleted last row in section
        tableView.deleteSections(NSIndexSet(index:indexPath.section), withRowAnimation: .Fade)
        } else {
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        } */
    }
    
    /*
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
    let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
    cell.textLabel!.text = object.valueForKey("timeStamp")!.description
    }
    */
    
    /*
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController {
    if _fetchedResultsController != nil {
    return _fetchedResultsController!
    }
    
    let fetchRequest = NSFetchRequest()
    // Edit the entity name as appropriate.
    let entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: dataManager.managedObjectContext!)
    fetchRequest.entity = entity
    
    // Set the batch size to a suitable number.
    fetchRequest.fetchBatchSize = 20
    
    // Edit the sort key as appropriate.
    let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
    let sortDescriptors = [sortDescriptor]
    
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataManager.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
    aFetchedResultsController.delegate = self
    _fetchedResultsController = aFetchedResultsController
    
    var error: NSError? = nil
    if !_fetchedResultsController!.performFetch(&error) {
    // Replace this implementation with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //println("Unresolved error \(error), \(error.userInfo)")
    abort()
    }
    
    return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil
    */
    
    //MARK: Manage Updates from fetched results controller
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView!.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView!.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView!.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        
        //func controller(controller: NSFetchedResultsController, didChangeObject anObject: NSManagedObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        if let tableView = tableView{
            switch type {
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            case .Update:
                
                let object = objectAtIndexPath(indexPath!)
                if let cell = tableView.cellForRowAtIndexPath(indexPath!)! as? PlayerTableViewCell {
                    delegate?.configureCell(cell, withObject: object)
                }
                
            case .Move:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
                
            }
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView!.endUpdates()
    }
    
    /*
    // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
    // In the simplest, most efficient, case, reload the table view.
    self.tableView.reloadData()
    }
    */
    
    //MARK: Methods for table view controller
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> NSManagedObject {
        let obj = fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
        return obj
    }
    
    func indexPathForObject(object: NSManagedObject) -> NSIndexPath {
        let indexPath = fetchedResultsController.indexPathForObject(object)
        return indexPath!
    }
    
    func deleteRowAtIndexPath(indexPath: NSIndexPath) {
        let obj = objectAtIndexPath(indexPath)
        fetchedResultsController.managedObjectContext.deleteObject(obj)
    }
    
    func update() {
        var error: NSError? = nil
        do {
            try fetchedResultsController.performFetch()
        } catch let error1 as NSError {
            error = error1
            print("Unresolved error \(error), \(error!.userInfo)")
            //abort()
        }
    }
    
    func updateWithPredicate(predicate:NSPredicate) {
        fetchedResultsController.fetchRequest.predicate = predicate
        update()
    }
    
    func updateWithSortDescriptors(sortKeys:[String], keyPath:String) {
        fetchRequest.sortDescriptors = sortDescriptorsFromStrings(sortKeys)
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataManager.managedObjectContext!, sectionNameKeyPath: keyPath, cacheName: nil)
        update()
    }
    
    func fetchedObjects() -> [AnyObject]? {
        return fetchedResultsController.fetchedObjects
    }
    
}