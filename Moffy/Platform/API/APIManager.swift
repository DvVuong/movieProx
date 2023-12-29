//
//  APIManager.swift
//  Moffy
//
//  Created by macbook on 15/12/2023.
//

import Foundation
import CryptoKit

class APIManager: NSObject {
  static let shared = APIManager()

    func getModel<T: Codable>(with object: T.Type, request: APIService = .generMovie) async throws -> T {
        guard let request = request.request() else {
            
        throw APIError.invalidRequest
      }
      let (data, response) = try await URLSession.shared.data(for: request)
      
      guard let httpResponse = response as? HTTPURLResponse else {
        throw APIError.invalidResponse
      }
      
      switch httpResponse.statusCode {
      case 200...299:
        break
      default:
        throw APIError.invalidResponse
      }
      
        let decodeData = try JSONDecoder().decode(object, from: data)
      return decodeData
    }
}
