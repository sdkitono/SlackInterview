//
//  ViewController.swift
//  SlackInterview
//
//  Created by Samuel Kitono on 6/2/18.
//  Copyright © 2018 Samuel Kitono. All rights reserved.
//

import UIKit

class SlackUsersViewController: UITableViewController {

    
    lazy var viewModel: SlackUsersViewModel = {
        let coreDataManager = CoreDataManager()
        let slackUsersService = SlackUsersService(coreDataManager:coreDataManager)
        return SlackUsersViewModel(coreDataManager: coreDataManager,slackUsersService: slackUsersService)
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add refresh control
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        initViewModel()
        viewModel.fetchUsers(completion: nil)
    }
    
    func initViewModel() {
        
        viewModel.slackUsersChanged = {
            (slackUserEventChanged) in
            
            DispatchQueue.main.async {
                switch slackUserEventChanged {
                case .beginUpdate:
                    self.tableView.beginUpdates()
                case .endUpdate:
                    self.tableView.endUpdates()
                case .insert(let indexPath):
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                case .delete(let indexPath):
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                case .move(let indexPath,let newIndexPath):
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                case .update(let indexPath):
                    let cell = self.tableView.cellForRow(at: indexPath) as! SlackUserTableViewCell
                    self.configure(cell: cell, for: indexPath)
                }
            }
        }
        
        viewModel.updateLoadingStatus = {
            if self.viewModel.isLoading {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            } else {
                self.refreshControl?.endRefreshing()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SlackUserDetailPushSegue" , let userDetailViewController = segue.destination as? SlackUserDetailViewController {
            userDetailViewController.detailUserViewModel = viewModel.getUserDetailViewModelForIndexPath(indexPath: tableView.indexPathForSelectedRow!)
        }
    }
    
    //MARK: Internal
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        viewModel.fetchUsers(completion: nil)
    }
    
    func configure(cell: UITableViewCell, for indexPath: IndexPath) {
        
        guard let cell = cell as? SlackUserTableViewCell else {
            return
        }
        
        cell.userImageView.layer.cornerRadius = 4
        
        let slackUserCellViewModel = viewModel.getSlackUserCellViewModelForIndex(indexPath: indexPath)
        cell.userNameLabel.text = slackUserCellViewModel.userNameText
        cell.realNameLabel.text = slackUserCellViewModel.realNameText
        cell.userImageView.loadImageUsingCache(withUrl: slackUserCellViewModel.userImageUrlString)
        
    }
    
    //MARK: Table View Datasource and Delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
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

