//
//  SlackUserDetailViewController.swift
//  SlackInterview
//
//  Created by Samuel Kitono on 8/2/18.
//  Copyright © 2018 Samuel Kitono. All rights reserved.
//

import UIKit

class SlackUserDetailViewController: UITableViewController {
    @IBOutlet weak var userDetailImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var realNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var skypeLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var detailUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDetailImageView.layer.cornerRadius = 4
        userDetailImageView.loadImageUsingCache(withUrl: detailUser!.image192!)
        usernameLabel.text = detailUser!.name
        realNameLabel.text = detailUser!.realName
        emailLabel.text = detailUser!.email
        skypeLabel.text = detailUser!.skype
        phoneLabel.text = detailUser!.phone
        titleLabel.text = detailUser!.title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
