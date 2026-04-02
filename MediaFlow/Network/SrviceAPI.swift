//
//  SrviceAPI.swift
//  MediaFlow
//
//  Created by Arpana Rani on 01/04/26.
//

import Foundation
import Combine

struct SrviceAPI: ServiceAPIProtocol {
    
    private let session = URLSession(configuration: NetworkConfigurations.apiConfiguration)

    func fetchRequest <T :Decodable>(_ urlRequest: URLRequest) async throws -> T {
        
        
        let (data, response) = try await session.data(for: urlRequest) 
        
        if let httpResponse = response as? HTTPURLResponse , !(200..<300).contains(httpResponse.statusCode){
            
            throw NetworkError.invalidResponse
        }
        
        do{
            return try JSONDecoder().decode(T.self, from: data)
        }catch {
            throw NetworkError.unableToDecodeData
        }
    }
    
}

