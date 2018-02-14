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
    var detailUserViewModel: SlackUsersDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDetailImageView.layer.cornerRadius = 4
        userDetailImageView.loadImageUsingCache(withUrl: detailUserViewModel.userImageUrlString)
        usernameLabel.text = detailUserViewModel.userNameText
        realNameLabel.text = detailUserViewModel.realNameText
        emailLabel.text = detailUserViewModel.emailText
        skypeLabel.text = detailUserViewModel.skypeText
        phoneLabel.text = detailUserViewModel.phoneText
        titleLabel.text = detailUserViewModel.titleText
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
