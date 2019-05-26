//
//  GRItemTableViewCell.swift
//  granular
//
//  Created by Dmitry Babenko on 2019-05-25.
//  Copyright © 2019 Decowareb. All rights reserved.
//

import UIKit

class GRItemTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var itemIcon: UIImageView!
    @IBOutlet weak var iconActivityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.itemIcon.image = UIImage(named: "question")
        self.nameLabel.text = nil
    }
    
    func configure(with item: GRItemPresentable) {
        self.nameLabel.text = item.name
        if let imgPath = item.url {
            let imageUrl = GRNetworkManager.shared.iconUrlString(for: imgPath)
            self.iconActivityIndicator.startAnimating()
            self.itemIcon.loadImageUsingCache(withUrl: imageUrl, completion: { isSuccess in
                DispatchQueue.main.async { [weak self] in
                    self?.iconActivityIndicator.stopAnimating()
                    if !isSuccess {
                        self?.itemIcon.image = UIImage(named: "question")
                    }
                }
            })
        }
    }
    
}
