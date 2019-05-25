//
//  GRItemTableViewCell.swift
//  granular
//
//  Created by Dmitry Babenko on 2019-05-25.
//  Copyright © 2019 Decowareb. All rights reserved.
//

import UIKit

class GRItemTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView?.backgroundColor = .gray
        self.imageView?.contentMode = .scaleAspectFit
        self.imageView?.image = nil
    }
    
    func configure(with item: GRItemModel) {
        self.textLabel?.text = item.name
        if let imgPath = item.url {
            let imageUrl = GRNetworkManager.shared.iconUrlString(for: imgPath)
            self.imageView?.loadImageUsingCache(withUrl: imageUrl, completion: { isSuccess in
                DispatchQueue.main.async { [weak self] in
                    self?.contentView.setNeedsLayout()
                }
            })
        }
    }
    
}
