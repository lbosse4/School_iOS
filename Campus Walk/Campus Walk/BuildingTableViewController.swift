//
//  BuildingTableViewController.swift
//  Campus Walk
//
//  Created by Lauren Bosse on 10/21/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

protocol buildingTableDelegateProtocol : class {
    func plotBuilding(building:Building)
}

class BuildingTableViewController : UITableViewController {
    let model = Model.sharedInstance
    let sectionLabelHeight : CGFloat = 40.0
    let sectionLabelFontSize : CGFloat = 20.0
    let sectionLabelFont : String = "Palatino"
    let darkBlueColor = UIColor(red: 0.01, green: 0.02, blue: 0.78, alpha: 1.0)
    let scroller = UILocalizedIndexedCollation.currentCollation()
    
    var isModifyingFavorites : Bool = false
    weak var delegate: buildingTableDelegateProtocol?
    
    @IBOutlet weak var addFavoritesButton: UIButton!
    
    
    override func viewDidLoad() {
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return model.numberOfTableSections()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfBuildingsInSection(section)
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return model.indexTitles()
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BuildingTableViewCell", forIndexPath: indexPath) as! BuildingTableViewCell
        
        cell.buildingTitleLabel.text = model.buildingAtIndexPath(indexPath).title

        if model.isFavoriteBuildingAtIndexPath(indexPath) {
            cell.favioriteStarImageView.image = UIImage(named: "filledStar.png")
        } else {
            cell.favioriteStarImageView.image = UIImage(named: "emptyStar.png")
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: sectionLabelHeight))
        label.text = model.letterForSection(section)
        label.textAlignment = NSTextAlignment.Center
        label.backgroundColor = UIColor.whiteColor()
        label.textColor = darkBlueColor
        label.font = UIFont(name: sectionLabelFont, size: sectionLabelFontSize)
        return label
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let building = (self.model.buildingAtIndexPath(indexPath))
        if isModifyingFavorites {
            if building.isFavorite {
                model.removeFavorite(building)
            } else {
                model.addFavorite(building)

            }
            model.toggleIsFavoriteBuildingAtIndexPath(indexPath)
            tableView.reloadData()
        } else {
            delegate!.plotBuilding(building)
        }
        
    }

    @IBAction func addFavoritesButtonPressed(sender: UIButton) {
        isModifyingFavorites = !isModifyingFavorites
        if addFavoritesButton.titleForState(.Normal) == "Add/Remove Favorites"{
            addFavoritesButton.setTitle("Done", forState: .Normal)
        } else {
            addFavoritesButton.setTitle("Add/Remove Favorites", forState: .Normal)
        }
       
    }
    
//    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
//        switch identifier {
//        case "showSelectedPinSegue":
//            if isModifyingFavorites {
//                return false
//            } else {
//                return true
//            }
//        default:
//            return false
//        }
//    }
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        switch segue.identifier! {
//        case "showSelectedPinSegue":
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                let selectedBuilding = model.buildingAtIndexPath(indexPath)
//                let controller = segue.destinationViewController as! ViewController
//                
//                controller.plotBuilding(selectedBuilding)
//            }
//        default:
//            assert(false, "Unhandled Segue in ViewController")
//        }
//    }    

    
}
