//
//  ResultViewController.swift
//  TestApp
//
//  Created by zecoo on 2014/06/21.
//  Copyright (c) 2014年 zecoo. All rights reserved.
//

import Foundation
import UIKit

class ResultViewController : UITableViewController{
    let BASE_URL:String = "http://worldcup.sfg.io"
    var resultJson:NSArray = []
    var matchesCountryJson:NSArray = []
    var fifaCode:String = ""
    var selectedId:NSInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //println(BASE_URL+"/matches/country?fifa_code=" + fifaCode)
        
        connect()
    }
    
    func connect(){
        let URL = NSURL(string: BASE_URL+"/matches/country?fifa_code=" + fifaCode)
        //let URL = NSURL(string: BASE_URL+"/teams/results")
        let Req = NSURLRequest(URL: URL)
        
        let connection: NSURLConnection = NSURLConnection(request: Req, delegate: self, startImmediately: false)
        
        NSURLConnection.sendAsynchronousRequest(Req,
            queue: NSOperationQueue.mainQueue(),
            completionHandler: self.connectComplete)
    }
    
    func connectComplete(res: NSURLResponse!, data: NSData!, error: NSError!) {
        matchesCountryJson = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSArray
        
        //println(matchesCountryJson)
        
        self.tableView.reloadData()
    }

    
    //
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return matchesCountryJson.count + 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 9
        default:
            if(matchesCountryJson.count == 0){
                return 0
            }
            else{
                let data:NSDictionary = matchesCountryJson[section - 1] as NSDictionary
                let homeData:NSDictionary = data.objectForKey("home_team") as NSDictionary
                let awayData:NSDictionary = data.objectForKey("away_team") as NSDictionary
                let homeCode:String = homeData.objectForKey("code") as String
                let awayCode:String = awayData.objectForKey("code") as String
                var teamData:NSArray;
                if(fifaCode == homeCode){
                    teamData = data.objectForKey("home_team_events") as NSArray
                }
                else{
                    teamData = data.objectForKey("away_team_events") as NSArray
                }
                
                return 4 + teamData.count
            }
        }
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        switch indexPath.section{
        case 0:
            return 44
        default:
            switch indexPath.row{
            case 0,1,2,3:
                return 44
            default:
                return 130
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell
        
        switch indexPath.section{
        case 0:
            cell = setTotalResult(tableView, cellForRowAtIndexPath: indexPath)
        default:
            cell = setMatchResult(tableView, cellForRowAtIndexPath: indexPath)
        }
        
        return cell
    }
    
    func setTotalResult(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        if(resultJson.count == 0){
            cell.textLabel.text = ""
            cell.detailTextLabel.text = ""
            return cell
        }
        
        let data:NSDictionary! = resultJson[selectedId] as NSDictionary
        
        switch indexPath.row {
        case 0:
            cell.textLabel.text = "Country"
            let name:NSString = data.objectForKey("country") as NSString
            let code:NSString = data.objectForKey("fifa_code") as NSString
            cell.detailTextLabel.text = name + "(" + code + ")"
        case 1:
            cell.textLabel.text = "Group"
            cell.detailTextLabel.text = data.objectForKey("group_letter") as NSString
        case 2:
            cell.textLabel.text = "Wins"
            let num = data.objectForKey("wins") as NSNumber
            cell.detailTextLabel.text = num.stringValue
        case 3:
            cell.textLabel.text = "Draws"
            let num = data.objectForKey("draws") as NSNumber
            cell.detailTextLabel.text = num.stringValue
        case 4:
            cell.textLabel.text = "Losses"
            let num = data.objectForKey("losses") as NSNumber
            cell.detailTextLabel.text = num.stringValue
        case 5:
            cell.textLabel.text = "Points"
            let num = data.objectForKey("points") as NSNumber
            cell.detailTextLabel.text = num.stringValue
        case 6:
            cell.textLabel.text = "Goal For"
            let num = data.objectForKey("goals_for") as NSNumber
            cell.detailTextLabel.text = num.stringValue
        case 7:
            cell.textLabel.text = "Goals Against"
            let num = data.objectForKey("goals_against") as NSNumber
            cell.detailTextLabel.text = num.stringValue
        case 8:
            cell.textLabel.text = "Goal Difference"
            let num = data.objectForKey("goal_differential") as NSNumber
            cell.detailTextLabel.text = num.stringValue
        default:
            cell.textLabel.text = ""
            cell.detailTextLabel.text = ""
        }
        
        return cell
    }
    
    
    func setMatchResult(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        let data:NSDictionary = matchesCountryJson[indexPath.section - 1] as NSDictionary
        
        //println(data)
        
        switch indexPath.row {
        case 0:
            cell.textLabel.text = "Status"
            let label = data.objectForKey("status") as NSString
            cell.detailTextLabel.text = label
        case 1:
            let homeData:NSDictionary = data.objectForKey("home_team") as NSDictionary
            let awayData:NSDictionary = data.objectForKey("away_team") as NSDictionary
            
            let homeCode:String = homeData.objectForKey("code") as String
            let awayCode:String = awayData.objectForKey("code") as String
            
            var versus = "相手"
            var myScore:NSNumber = 0
            var versusScore:NSNumber = 0
            
            if(fifaCode == homeCode){
                versus = awayData.objectForKey("country") as String
                versusScore = awayData.objectForKey("goals") as NSNumber
                myScore = homeData.objectForKey("goals") as NSNumber
            }
            else{
                versus = homeData.objectForKey("country") as String
                versusScore = homeData.objectForKey("goals") as NSNumber
                myScore = awayData.objectForKey("goals") as NSNumber
            }
            
            cell.textLabel.text = "VS " + versus
            cell.detailTextLabel.text = myScore.stringValue + " - " + versusScore.stringValue
        case 2:
            cell.textLabel.text = "Date"
            let label = data.objectForKey("datetime") as NSString
            cell.detailTextLabel.text = label
        case 3:
            cell.textLabel.text = "Location"
            let label = data.objectForKey("location") as NSString
            cell.detailTextLabel.text = label
        default:
            
            let ccell:EventTableCell = self.tableView.dequeueReusableCellWithIdentifier("EventCell") as EventTableCell
            
            let data:NSDictionary = matchesCountryJson[indexPath.section - 1] as NSDictionary
            let homeData:NSDictionary = data.objectForKey("home_team") as NSDictionary
            let awayData:NSDictionary = data.objectForKey("away_team") as NSDictionary
            let homeCode:String = homeData.objectForKey("code") as String
            let awayCode:String = awayData.objectForKey("code") as String
            var teamData:NSArray;
            if(fifaCode == homeCode){
                teamData = data.objectForKey("home_team_events") as NSArray
            }
            else{
                teamData = data.objectForKey("away_team_events") as NSArray
            }
            
            var eventData:NSDictionary = teamData[indexPath.row - 4] as NSDictionary
            
            let type = eventData.objectForKey("type_of_event") as String
            let player = eventData.objectForKey("player") as String
            let time = eventData.objectForKey("time") as String
            
            ccell.typeLabel.text = type
            ccell.playerLabel.text = player
            ccell.timeLabel.text = time
            //
            println(type)
            
            return ccell
        }
        
        return cell
    }
    
    
    
    //header
    override func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView! {
        let view:UIView = UIView()
        view.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.4, alpha: 1.0)
        let label:UILabel = UILabel(frame:CGRectMake(15,0,100,20))
        label.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.font = UIFont.systemFontOfSize(12.0)
        
        view.addSubview(label)
        
        switch section{
        case 0:
            label.text = "Total Result"
        default:
            label.text = "Match" + String(section)
        }
        
        return view
    }

    
}