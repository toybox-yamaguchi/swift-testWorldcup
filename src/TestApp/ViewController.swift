//
//  ViewController.swift
//  zr
//
//  Created by zecoo on 2014/06/21.
//  Copyright (c) 2014年 zecoo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController ,NSURLConnectionDelegate{
    let BASE_URL:String = "http://worldcup.sfg.io"
    var json:NSArray = []
    var selectedFifaCode:String = ""
    var selectedId:NSInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        connect()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func connect(){
        let URL = NSURL(string: BASE_URL+"/teams/results")
        let Req = NSURLRequest(URL: URL)
        
        let connection: NSURLConnection = NSURLConnection(request: Req, delegate: self, startImmediately: false)
        
        NSURLConnection.sendAsynchronousRequest(Req,
            queue: NSOperationQueue.mainQueue(),
            completionHandler: self.connectComplete)
    }
    
    func connectComplete(res: NSURLResponse!, data: NSData!, error: NSError!) {
        json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSArray
        
        self.tableView.reloadData()
        
        //中身
        /*
        for obj: NSDictionary! in json {
            println(obj.objectForKey("id"))
            println(obj.objectForKey("country"))
            println(obj.objectForKey("fifa_code"))
        }
        */
    }
    
    // tableview
    
    /*
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
    return 100
    }
    */
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 8
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        let index:NSNumber = (indexPath.section * 4 + indexPath.row) as NSNumber
        
        if(json.count == 0){
            cell.text = ""
            return cell
        }
        
        //cell.text = index.stringValue
        
        let data:NSDictionary = json[index.integerValue] as NSDictionary
        cell.text = data.objectForKey("country") as NSString
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)
        let index:NSNumber = (indexPath.section * 4 + indexPath.row) as NSNumber
        let data:NSDictionary = json[index.integerValue] as NSDictionary
        selectedFifaCode = data.objectForKey("fifa_code") as String
        selectedId = ((data.objectForKey("id") as NSInteger) - 1)
        
        self.performSegueWithIdentifier("toResult", sender: self)
    }
    
    //header
    
    override func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView! {
        let view:UIView = UIView()
        view.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.4, alpha: 1.0)
        
        var alp:String = ""
        
        switch section {
        case 0:
            alp = "A"
        case 1:
            alp = "B"
        case 2:
            alp = "C"
        case 3:
            alp = "D"
        case 4:
            alp = "E"
        case 5:
            alp = "F"
        case 6:
            alp = "G"
        case 7:
            alp = "H"
        default:
            alp = ""
        }
        
        let label:UILabel = UILabel(frame:CGRectMake(15,0,100,20))
        label.text = "Group " + alp
        label.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.font = UIFont.systemFontOfSize(12.0)
        
        view.addSubview(label)
        
        return view
    }
    
    // segue
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if(segue.identifier == "toResult"){
            let vc:ResultViewController = segue.destinationViewController as ResultViewController
            vc.resultJson = json
            vc.fifaCode = selectedFifaCode
            vc.selectedId = selectedId
        }
    }
    
    
}

