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
    
    private var viewModel: ItemsViewModel?
    weak var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ItemsViewModel(with: self)
        
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
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension ItemsViewController: UITableViewDelegate {
    
}

