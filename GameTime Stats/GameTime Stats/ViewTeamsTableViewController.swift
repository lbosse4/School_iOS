//
//  ViewTeamsTableViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/18/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit
import CoreData

class ViewTeamsTableViewController: UITableViewController, ViewTeamsDataSourceCellConfigurer{
    let model = Model.sharedInstance
    let formatter = NSNumberFormatter()
    let buttonWidth : CGFloat = 140.0
    let trashCanButtonWidth : CGFloat = 30.0
    let trashCanButtonHeight : CGFloat = 35.0
    let colorWheelButtonRadius : CGFloat = 30.0
    let buttonHeight : CGFloat = 35.0
    let scrollPadding : CGFloat = 45.0
    let buttonPadding : CGFloat = 10.0
    let sectionHeight : CGFloat = 50.0
    //let blueColor = UIColor(red:0.00, green:0.00, blue:0.86, alpha:1.0)
    let titleFont = UIFont(name: "Orbitron-Medium", size: 18.0)
    let buttonFont = UIFont(name: "Orbitron-Light", size: 18.0)
    
    lazy var dataSource : ViewTeamsDataSource = ViewTeamsDataSource(entity: "Player", sortKeys: ["team.name", "jerseyNumber"], predicate: nil, sectionNameKeyPath: "team.name", delegate: self.model)
    
    var cancelBlock : (() -> Void)?
    
    override func viewDidLoad() {
        formatter.minimumIntegerDigits = 2
        
        dataSource.delegate = self
        dataSource.tableView = tableView // fetchresultscontroller delegate needs to know this!
        tableView.dataSource = dataSource
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
    }
    
    //MARK: Actions
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        cancelBlock?()
    }
    
    func trashCanButtonPressed(sender: UIButton){
        let sectionTitle = dataSource.tableView(self.tableView, titleForHeaderInSection: sender.tag)!
        let team = model.teamWithName(sectionTitle)
        
        model.deleteTeam(team)
        self.tableView.reloadData()
    }
    
    func colorWheelButtonPressed(sender: UIButton) {
        //Allow the user to change the team colors
        let sectionTitle = dataSource.tableView(self.tableView, titleForHeaderInSection:  sender.tag)!
        let team = model.teamWithName(sectionTitle)
        let changeTeamColorViewController = storyboard!.instantiateViewControllerWithIdentifier("ChangeTeamColorViewController") as! ChangeTeamColorViewController
        changeTeamColorViewController.team = team
        changeTeamColorViewController.cancelBlock = {() in
            self.dismissViewControllerAnimated(true, completion: nil)
            self.tableView.reloadData()
        }
        changeTeamColorViewController.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        self.presentViewController(changeTeamColorViewController, animated: true, completion: nil)
    }
    
    func addPlayerButtonPressed(sender: UIButton){
        
        let sectionTitle = dataSource.tableView(self.tableView, titleForHeaderInSection: sender.tag)!
        let team = model.teamWithName(sectionTitle)
        
        let addPlayerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddPlayerViewController") as! AddPlayerViewController
        
        addPlayerViewController.team = team
        addPlayerViewController.modalPresentationStyle = UIModalPresentationStyle.FormSheet

        addPlayerViewController.cancelBlock = {() in
            self.dismissViewControllerAnimated(true, completion: nil)
            self.tableView.reloadData()
        }
        
        self.presentViewController(addPlayerViewController, animated: true, completion: nil)
    }
    
    //MARK: Data Source Cell Configurer
    func cellIdentifierForObject(object: NSManagedObject) -> String {
        return "playerCell"
    }
    
    func configureCell(let cell: PlayerTableViewCell, withObject object: NSManagedObject) {
        let player = object as? Player
        let playerName = player!.name
        cell.playerNameLabel.text = playerName
        
        let position = player?.position
        cell.positionLabel.text = position
        
        let jerseyNumber = player?.jerseyNumber
        let jerseyNumberString = formatter.stringFromNumber(jerseyNumber!)
        cell.jerseyNumberLabel.text = jerseyNumberString
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionViewFrame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: sectionHeight)
        let sectionView = UIView(frame: sectionViewFrame)
        sectionView.backgroundColor = UIColor.blackColor()
        
        //clickable to allow collapsable sections
        let teamNameButtonFrame = CGRect(x: buttonPadding*2 + colorWheelButtonRadius, y: 0.0, width: view.frame.width - colorWheelButtonRadius - trashCanButtonWidth - buttonWidth - scrollPadding - buttonPadding*4, height: sectionHeight)
        let teamNameButton = UIButton(frame: teamNameButtonFrame)
        let teamName = dataSource.tableView(tableView, titleForHeaderInSection: section)
        teamNameButton.setTitle(teamName, forState: .Normal)
        teamNameButton.titleLabel!.font = titleFont
        teamNameButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        teamNameButton.tag = section
        
        //Button to delete team
        //let trashCanButtonFrame = CGRect(x:view.frame.width - trashCanButtonWidth - buttonWidth - scrollPadding - buttonPadding, y: (sectionHeight - trashCanButtonHeight)/2, width: trashCanButtonWidth, height: trashCanButtonHeight)
        let trashCanButtonFrame = CGRect(x: buttonPadding, y: (sectionHeight - trashCanButtonHeight)/2, width: trashCanButtonWidth, height: trashCanButtonHeight)
        let trashCanButton = UIButton(frame: trashCanButtonFrame)
        let trashCanImage = UIImage(named: "TrashCanImage.png")
        trashCanButton.setBackgroundImage(trashCanImage, forState: .Normal)
        trashCanButton.addTarget(self, action: "trashCanButtonPressed:", forControlEvents: .TouchUpInside)
        trashCanButton.tag = section
        
        //Button to update team colors
        let colorWheelButtonFrame = CGRect(x: view.frame.width - colorWheelButtonRadius - buttonWidth - scrollPadding - buttonPadding, y: (sectionHeight - colorWheelButtonRadius)/2, width: colorWheelButtonRadius, height: colorWheelButtonRadius)
        //let colorWheelButtonFrame = CGRect(x: buttonPadding, y: (sectionHeight - colorWheelButtonRadius)/2, width: colorWheelButtonRadius, height: colorWheelButtonRadius)
        let colorWheelButton = UIButton(frame: colorWheelButtonFrame)
        let colorWheelImage = UIImage(named: "ColorPickerImage.png")
        colorWheelButton.setImage(colorWheelImage, forState: .Normal)
        colorWheelButton.addTarget(self, action: "colorWheelButtonPressed:", forControlEvents: .TouchUpInside)
        colorWheelButton.tag = section
        
        //add a player to a specific team
        let addPlayerButtonFrame = CGRect(x: view.frame.width - buttonWidth - scrollPadding, y: (sectionHeight - buttonHeight)/2, width: buttonWidth, height: buttonHeight)
        let addPlayerButton = UIButton(frame: addPlayerButtonFrame)
        addPlayerButton.addTarget(self, action: "addPlayerButtonPressed:", forControlEvents: .TouchUpInside)
        addPlayerButton.setTitle("Add Player", forState: .Normal)
        addPlayerButton.titleLabel!.font = buttonFont
        let team = model.teamAtIndex(section)
        addPlayerButton.backgroundColor = model.majorColorForTeam(team)
        addPlayerButton.setTitleColor(model.minorColorForTeam(team), forState: .Normal)
        addPlayerButton.tag = section
        
        sectionView.addSubview(colorWheelButton)
        sectionView.addSubview(teamNameButton)
        sectionView.addSubview(trashCanButton)
        sectionView.addSubview(addPlayerButton)

        return sectionView
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
}