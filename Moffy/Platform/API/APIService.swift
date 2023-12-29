//
//  APIService.swift
//  Moffy
//
//  Created by macbook on 15/12/2023.
//

import Foundation

enum APIService {
  case generMovie
  case generTV
  case movieTopRate(page: String)
  case tvShowTopRate(page: String)
  case searchMovie(page: String, query: String)
  case searchTvShow(page: String, query: String)
  case getMovieGenerID(generID: String)
  case searchActor(page: String, query: String)
  
  var domain: String {
    switch self {
    default:
      return URLs.domain
    }
  }
  
  var path: String? {
    switch self {
    case .generMovie:
      return "/3/genre/movie/list"
    case .generTV:
      return "/3/genre/tv/list"
    case .movieTopRate:
      return "/3/movie/top_rated"
    case .tvShowTopRate:
      return "/3/tv/top_rated"
    case .searchMovie:
      return "/3/search/movie"
    case .searchTvShow:
      return "/3/search/tv"
    case .getMovieGenerID:
      return "/3/discover/movie"
    case .searchActor:
      return "/3/search/person"
    }
  }
  
  var method: String {
    switch self {
    default:
      return "GET"
    }
  }
  
  var params: [String: String?] {
    var params: [String: String?] = [:]
    
    switch self {
    case.movieTopRate(let page):
      params["page"] = page
      params["api_key"] = "dc9e9a73378330417bb4818abf1b60ed"
    case.tvShowTopRate(let page):
      params["page"] = page
      params["api_key"] = "dc9e9a73378330417bb4818abf1b60ed"
    case.searchMovie(let page ,let query):
      params["page"] = page
      params["query"] = query
      params["api_key"] = "dc9e9a73378330417bb4818abf1b60ed"
    case.searchTvShow(let page,let query):
      params["page"] = page
      params["query"] = query
      params["api_key"] = "dc9e9a73378330417bb4818abf1b60ed"
    case.getMovieGenerID(let id):
      params["page"] = "1"
      params["with_genres"] = id
      params["api_key"] = "dc9e9a73378330417bb4818abf1b60ed"
    case.searchActor(let page, let query):
      params["page"] = page
      params["query"] = query
      params["api_key"] = "dc9e9a73378330417bb4818abf1b60ed"
    default:
      params["api_key"] = "dc9e9a73378330417bb4818abf1b60ed"
    }
    return params
  }
  
  var headers: [String: String?] {
    var headers: [String: String?] = [:]
    switch self {
    default:
      headers["Content-Type"] = "application/json"
    }
    return headers
  }
}

extension APIService {
  func request(body: Data? = nil) -> URLRequest? {
    guard
      let url = URL(string: domain),
      var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
    else {
      return nil
    }
    if let path {
      urlComponents.path = path
    }
    
    urlComponents.queryItems = params.map({
      return URLQueryItem(name: $0, value: $1)
    })
    guard let urlRequest = urlComponents.url else {
      return nil
    }
    var request = URLRequest(url: urlRequest)
    request.httpMethod = method
    
    headers.forEach {
      request.setValue($1, forHTTPHeaderField: $0)
    }
    
    if let body {
      request.httpBody = body
    }
    
    return request
  }
}

