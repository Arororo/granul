//
//  GRItemModel.swift
//  granular
//
//  Created by Dmitry Babenko on 2019-05-25.
//  Copyright © 2019 Decowareb. All rights reserved.
//

import UIKit

protocol GRItemPresentable {
    var name: String? { get }
    var url: String? { get }
}

struct GRItemNetworkModel: Codable, GRItemPresentable {
    var name: String?
    var url: String?
}
