//
//  GlobalSettings.swift
//  granular
//
//  Created by Dmitry Babenko on 2019-05-25.
//  Copyright © 2019 Decowareb. All rights reserved.
//

import Foundation

class GRNetworkGlobalSettings {
    static let shared = GRNetworkGlobalSettings()
    let apiConnectorConfiguration = APIConnectorConfiguration(scheme: "https",
                                                              baseURL: "granul.s3-us-west-2.amazonaws.com")
    
}
