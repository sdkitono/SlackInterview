//
//  ViewController.swift
//  SlackInterview
//
//  Created by Samuel Kitono on 6/2/18.
//  Copyright © 2018 Samuel Kitono. All rights reserved.
//

import UIKit
import CoreData

class SlackUsersViewController: UITableViewController {

    lazy var fetchedResultsController: NSFetchedResultsController<User> = SlackUsersFetchControllerFactory.slackUsersFetchedResultsController()
    
    lazy var slackUsersService:SlackUsersService = SlackUsersService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        self.fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        slackUsersService.fetchAllUsers {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SlackUserDetailPushSegue" , let userDetailViewController = segue.destination as? SlackUserDetailViewController {
            userDetailViewController.detailUser = fetchedResultsController.object(at: tableView.indexPathForSelectedRow!)
        }
    }
    
    //MARK: Internal
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        slackUsersService.fetchAllUsers {
            refreshControl.endRefreshing()
        }
    }
    
    func configure(cell: UITableViewCell, for indexPath: IndexPath) {
        
        guard let cell = cell as? SlackUserTableViewCell else {
            return
        }
        
        let user = fetchedResultsController.object(at: indexPath)
        
        cell.userNameLabel.text = user.name
        cell.realNameLabel.text = user.realName
        cell.userImageView.layer.cornerRadius = 4
        cell.userImageView.loadImageUsingCache(withUrl: user.image48!)
    }
    
    //MARK: Table View Datasource and Delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SlackUserCell", for: indexPath) as! SlackUserTableViewCell
        configure(cell: cell, for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SlackUsersViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            let cell = tableView.cellForRow(at: indexPath!) as! SlackUserTableViewCell
            configure(cell: cell, for: indexPath!)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

