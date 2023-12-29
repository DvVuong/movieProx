//
//  APIError.swift
//  Moffy
//
//  Created by macbook on 15/12/2023.
//

import Foundation

enum APIError: Error {
  case invalidRequest
  case invalidResponse
  case jsonEncodingError
  case jsonDecodingError
  case notInternet
}
