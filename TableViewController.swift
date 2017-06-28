//
//  TableViewController.swift
//  ProductHunt
//
//  Created by Эдгар on 28.06.2017.
//  Copyright © 2017 D-WIN. All rights reserved.
//

import UIKit
import SwiftyJSON
import BTNavigationDropdownMenu

class TableViewController: UITableViewController {

    var names = [String]()
    var images = [Data]()
    var tags = [String]()
    var count = 0
    var votes = [Int]()
    let categories = ["tech", "games", "books", "podcasts"]
    var currentCategory = "tech"
    var ids = [String]()
    
    var tag = String()
    var name = String()
    var getIt = String()
    var sc = Data()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isHidden = true
        
        let menuView = BTNavigationDropdownMenu(title: categories[0], items: categories as [AnyObject])
        navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
                self?.currentCategory = (self?.categories[indexPath])!
                self!.getData(category: (self!.categories[indexPath]))
        }
        getData(category: currentCategory)
        self.refreshControl?.addTarget(self, action: #selector(TableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {

        getData(category: currentCategory)
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        
        cell.nameLabel.text = names[indexPath.row]
        cell.thumbnail.image = UIImage(data: images[indexPath.row])
        cell.tagLabel.text = tags[indexPath.row]
        cell.votesLabel.text = String(votes[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onTap(id: ids[indexPath.row])
    }
    
    func getData(category: String) {
        clearAll()
        let url = URL(string: "https://api.producthunt.com/v1/categories/" + category + "/posts")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer 591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff", forHTTPHeaderField: "Authorization")
        request.addValue("api.producthunt.com", forHTTPHeaderField: "Host")
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            do {
                let json = JSON(data: data!)
                let posts = json["posts"].array!
                
                print("number of posts:" + String(posts.count))
                
                if (posts.count != 0)
                {
                    for i in 0...posts.count-1
                    {
                        let post = posts[i]
                        self.ids.append(post["id"].stringValue)
                        self.names.append((post["name"].stringValue))
                        print(self.names[i])
                        self.tags.append(post["tagline"].stringValue)
                        self.votes.append(post["votes_count"].int!)
                        let thumbnail = post["thumbnail"].dictionary
                        let dt = try Data(contentsOf: URL(string: (thumbnail!["image_url"]?.stringValue)!)!)
                        self.images.append(dt)
                    }
                }
                self.count = posts.count
                DispatchQueue.main.async {
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            }
            catch
            {
                
            }
        });
        task.resume()
    }

    func onTap(id: String)
    {        let url = URL(string: "https://api.producthunt.com/v1/posts/" + id)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer 591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff", forHTTPHeaderField: "Authorization")
        request.addValue("api.producthunt.com", forHTTPHeaderField: "Host")
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            do {
                let json = JSON(data: data!)
                let post = json["post"].dictionary
                let screenshots = post?["screenshot_url"]?.dictionary
                
                self.sc = try Data(contentsOf: URL(string: (screenshots!["300px"]!.stringValue))!)
                self.getIt = (post?["redirect_url"]?.stringValue)!
                print("getIt: ", self.getIt)
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "DetailedInformationViewController")
                (vc as! DetailedInformationViewController).setData(name: post!["name"]!.stringValue, tag: post!["tagline"]!.stringValue, sc: self.sc, getIt: self.getIt)
                self.present(vc, animated: false, completion: nil)
                
            }
            catch
            {
                
            }
        });
        task.resume()
        
    }
    
    func clearAll()
    {
        ids.removeAll()
        names.removeAll()
        images.removeAll()
        votes.removeAll()
        tags.removeAll()
        count = 0
    }
}
