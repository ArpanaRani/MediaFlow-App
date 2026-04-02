//
//  ServiceAPIProtocol.swift
//  MediaFlow
//
//  Created by Arpana Rani on 01/04/26.
//

import Foundation

protocol ServiceAPIProtocol {
    
    func fetchRequest <T :Decodable>(_ urlRequest: URLRequest) async throws -> T
}
