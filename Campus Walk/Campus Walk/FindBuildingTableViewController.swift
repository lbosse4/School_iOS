//
//  FindBuildingTableViewController.swift
//  Campus Walk
//
//  Created by Lauren Bosse on 10/26/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

protocol FindBuildingsProtocol {
    func findBuildingViewControllerDismissed(chosenBuilding : Building)
}

class FindBuildingTableViewController : UITableViewController {
    let model = Model.sharedInstance
    let sectionLabelHeight : CGFloat = 40.0
    let sectionLabelFontSize : CGFloat = 20.0
    let sectionLabelFont : String = "Palatino"
    let darkBlueColor = UIColor(red: 0.01, green: 0.02, blue: 0.78, alpha: 1.0)
    var delegate : FindBuildingsProtocol?
    
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
        let cell = tableView.dequeueReusableCellWithIdentifier("FindBuildingTableViewCell", forIndexPath: indexPath) as! FindBuildingTableViewCell
        
        cell.buildingTitleLabel.text = model.buildingAtIndexPath(indexPath).title

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
        let building = model.buildingAtIndexPath(indexPath)
        delegate?.findBuildingViewControllerDismissed(building)
    }
}


