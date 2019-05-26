//
//  ViewController.swift
//  granular
//
//  Created by Dmitry Babenko on 2019-05-25.
//  Copyright © 2019 Decowareb. All rights reserved.
//

import UIKit

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
        self.viewModel = ItemsViewModel(with: self)
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
    
}

