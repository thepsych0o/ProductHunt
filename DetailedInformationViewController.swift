//
//  DetailedInformationViewController.swift
//  ProductHunt
//
//  Created by Эдгар on 28.06.2017.
//  Copyright © 2017 D-WIN. All rights reserved.
//

import UIKit
import SwiftyJSON

class DetailedInformationViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var screenshot: UIImageView!
    
    var getIt = String()
    var name = ""
    var tag = ""
    var sc = Data()
    var vc = TableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async
        {
            self.nameLabel.text = self.name
            self.tagLabel.text = self.tag
            self.screenshot.image = UIImage(data: self.sc)
            self.screenshot.layer.borderWidth = 1
            self.screenshot.layer.borderColor = UIColor.black.cgColor
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(name: String, tag: String, sc: Data, getIt: String) {
        self.name = name
        self.tag = tag
        self.getIt = getIt
        self.sc = sc
    }

    
    @IBAction func get(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: getIt)!, options: [:], completionHandler: nil)
    }
    
}
