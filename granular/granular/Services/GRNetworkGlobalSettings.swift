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
                                                              baseURL: "raw.githubusercontent.com/granularag/granular_mobile_mock_response/master")
    
}
