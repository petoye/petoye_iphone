//
//  TableViewController.swift
//  PetOye
//
//  Created by Ameya Vichare on 30/07/16.
//  Copyright © 2016 Ameya Vichare. All rights reserved.
//

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var feedTable: UITableView!
    
    var post_user_id = [String]()
    var username = [String]()
    var message = [String]()
    var like_count = [String]()
    var comment_count = [String]()
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        feedTable.delegate = self
        feedTable.dataSource = self
        
        //Get request for geting feeds
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://api.petoye.com/feeds/3/nearbyfeeds")!)
        request.HTTPMethod = "GET"
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print(error!)
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 201 {           // check for http errors
                print("statusCode should be 201, but is \(httpStatus.statusCode)")
                print(response!)
            }
            
            var responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            print(responseString)
            
            let json = JSON(data: data!)
            
            for item in json["feeds"].arrayValue {
                
                //print(item["id"].stringValue)
                //print(item["username"].stringValue)
                
                for innerItem in item["feeds"].arrayValue {
                    //print(item["id"].stringValue)
                    //print(item["username"].stringValue)
                    //print(innerItem["message"])
                    //print(innerItem["like_count"])
                    //print(innerItem["comment_count"])
                    self.username.append(item["username"].stringValue)
                    self.message.append(innerItem["message"].stringValue)
                    self.like_count.append(innerItem["like_count"].stringValue)
                    self.comment_count.append(innerItem["comment_count"].stringValue)
                    
                    self.post_user_id.append(item["id"].stringValue)
                    self.feedTable.reloadData()
                    
                }
                
            }
            print(self.username)
            print(self.message)
            print(self.like_count)
            print(self.comment_count)
            print(self.post_user_id)

            
            //for now doing nearby feeds
        }
        task.resume()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return username.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->
        UITableViewCell{
            let cell = tableView.dequeueReusableCellWithIdentifier("feed", forIndexPath: indexPath) as! feed
            //cell.textLabel?.text = "TEST"
            
            //cell.postedImage.image = UIImage(named: "PetOyeGreen60pt@2x.png")
            cell.username.text = username[indexPath.row]
            cell.message.text = message[indexPath.row]
            cell.likecount.text = like_count[indexPath.row]
            cell.commentcount.text = comment_count[indexPath.row]
            
            return cell
            
    }
}