//
//  ViewController.swift
//  granular
//
//  Created by Dmitry Babenko on 2019-05-25.
//  Copyright © 2019 Decowareb. All rights reserved.
//

import UIKit
import Combine

class ItemsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoBahherHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoLabel: UILabel!
    weak var refreshControl: UIRefreshControl?
    
    private var viewModel: ItemsViewModel?
    private var defaultInfoBannerHeight: CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.defaultInfoBannerHeight = self.infoBahherHeightConstraint.constant
        self.viewModel = GRItemsViewModel(with: self)
        self.modelUpdated(self.viewModel!)
        
        self.setupTableView()
        self.viewModel?.load()
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        GRItemTableViewCell.registerNib(tableView: self.tableView)
        
        //Add Refresh Control
        self.tableView.refreshControl = UIRefreshControl()
        self.refreshControl = self.tableView.refreshControl
        self.refreshControl?.addTarget(self, action: #selector(updateItems), for: .valueChanged)
    }
    
    @objc private func updateItems() {
        self.viewModel?.load()
    }
    
    @IBAction func onRefresh(_ sender: UIBarButtonItem) {
        tableView.reloadData()
    }
}


//MARK: - ItemsViewModelDelegate
extension ItemsViewController: ItemsViewModelDelegate{
    
    func modelUpdated(_ model: ItemsViewModel) {
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
        switch model.status {
        case .error:
            let alert = UIAlertController(title: "Error!!!", message: model.alertMessage(), preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        default:
            if let infoMessage = model.infoMessage() {
                self.infoLabel.text = infoMessage
                self.infoBahherHeightConstraint.constant = self.defaultInfoBannerHeight
            } else {
                self.infoLabel.text = nil
                self.infoBahherHeightConstraint.constant = 0
            }
        }
    }
    
}

//MARK: - UITableViewDataSource
extension ItemsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.itemsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GRItemTableViewCell.defaultIdentifier(), for: indexPath) as? GRItemTableViewCell,
        let item = self.viewModel?.item(for: indexPath) else {
            return UITableViewCell()
        }
        cell.configure(with: item)
        
        //check if the next page needed
        if let viewModel = self.viewModel {
            if viewModel.itemsCount == (indexPath.row + 1) && viewModel.moreAvailable && viewModel.status != .loading {
                self.viewModel?.loadNextPage()
            }
        }
        
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension ItemsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        let animation = AnimationFactory.makeSlideMoveWithBounce(span: cell.frame.height, duration: 0.5, delayFactor: 0.05)
//        let animator = Animator(animation: animation)
//        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction (style: .destructive, title: "Delete") { _,_,_ in }
        action.backgroundColor = .green
        let config = UISwipeActionsConfiguration(actions: [action])
        return config
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

