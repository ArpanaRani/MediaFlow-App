//
//  NetworkConfiguration.swift
//  MediaFlow
//
//  Created by Arpana Rani on 01/04/26.
//

import Foundation
struct NetworkConfigurations {
    
    //this for api call for sime data
    static let apiConfiguration: URLSessionConfiguration = {
        var configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.waitsForConnectivity = true
        return configuration
    }()
}
extension NetworkConfigurations {

    //this is for downloading images
    static let downloadConfiguration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 60
        return configuration
    }()
}

extension NetworkConfigurations {

    //this is to activate background task
    static let backgroundConfiguration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.mediaflow.download")
        configuration.waitsForConnectivity = true
        configuration.sessionSendsLaunchEvents = true
        return configuration
    }()
}



