//
//  MovieManager.swift
//  Moffy
//
//  Created by MRX on 16/12/2023.
//

import Foundation
import UIKit
import Combine

class MovieManager {
  static let shared = MovieManager()
  
  @Published private(set) var movie: [Movie] = []
  @Published private(set) var geners: [GenresMovie] = []
  @Published private(set) var cacheGeners: [GenresMovie] = []
  @Published private(set) var topRateMovies: [Movie] = []
  @Published private(set) var movieGeners: [Movie] = []
  @Published private(set) var movieLikes: [Movie] = []
  @Published private(set) var searchMovie: [Movie] = []
  @Published private(set) var movieGenerID: [Movie] = []
  @Published private(set) var seclectedMovies: [Movie] = []
  @Published private(set) var cacheGennerStruct: [GenerMovieStruct] = []
  @Published private(set) var canLoadMore: Bool = false
  private var currenPage: Int = 1
  
  enum GetMovieType {
    case topRateMovie
    case searchMovie
    case movieForGenerId
    
  }
}

extension MovieManager {
  
  func fecthMovie(_ movieType: GetMovieType, page: String = "", query: String = "", generID: String = "") {
    switch movieType {
    case .topRateMovie:
      self.getMovie(.movieTopRate(page: page))
    case .searchMovie:
      self.getMovie(.searchMovie(page: page, query: query))
    case .movieForGenerId:
      self.getMovie(.getMovieGenerID(generID: generID))
    }
  }
  
  func getMovie(_ requets: APIService, page: String = "1", query: String = "a") {
    self.movie.removeAll()
    Task {
      do {
        let movieResponse = try await APIManager.shared.getModel(with: MovieRespone.self, request: requets)
        self.movie.append(contentsOf: movieResponse.results ?? [Movie]())
        print("vuongdv", self.movie.count)
      }
      catch let error {
        print(error.localizedDescription)
      }
    }
  }
  
  func fetchMovieForGenerID(with generID: String) {
//    Task {
//      do {
//        let movieResponse = try await APIManager.shared.getModel(with: MovieRespone.self, request: .getMovieGenerID(generID: generID))
//        self.movieGenerID.append(contentsOf: movieResponse.results ?? [Movie]())
//      }
//      catch {
//        print(error)
//      }
//    }
  }
  
  func fetchGenerMovie() {
    Task {
      do {
        let genresResponse = try await  APIManager.shared.getModel(with: GenerMovieResponse.self, request: .generMovie)
        self.geners = genresResponse.genres
      }
      catch (let error) {
        print(error.localizedDescription)
      }
    }
  }
  
  func fecthTopRateMovie() {
    Task {
      do {
          let movieResponse = try await APIManager.shared.getModel(with: MovieRespone.self, request: .movieTopRate(page: String(self.currenPage)))
          topRateMovies.append(contentsOf: movieResponse.results ?? [Movie]())
        //MARK: - LoadMore
        
        if self.currenPage < movieResponse.totalPages ?? 0 {
          self.currenPage += 1
        }
        
        if self.canLoadMore  {
          topRateMovies.append(contentsOf: movieResponse.results ?? [])
        }
        
        if checkGenerMovie(topRateMovies).isEmpty {
          self.movieGeners = topRateMovies
        }else {
          self.movieGeners = checkGenerMovie(topRateMovies)
        }
      }
      
      catch let error {
        print("error", error.localizedDescription)
      }
    }
  }
  
  func searchMovie(with query: String) {
    Task {
      do {
        if query.isEmpty {
          self.movieGeners = checkGenerMovie(topRateMovies)
        }else {
          let movieResponse = try await APIManager.shared.getModel(with: MovieRespone.self, request: .searchMovie(page: String(self.currenPage), query: query))
          self.searchMovie.append(contentsOf: movieResponse.results ?? [Movie] ())
          self.movieGeners = searchMovie
          self.topRateMovies = searchMovie
          if self.currenPage < movieResponse.totalPages ?? 0 {
            self.currenPage += 1
          }
          
          if self.canLoadMore  {
            topRateMovies.append(contentsOf: movieResponse.results ?? [Movie] ())
            self.searchMovie.append(contentsOf: movieResponse.results ?? [Movie] ())
          }
        }
      }
      catch let error {
        print("error", error.localizedDescription)
      }
    }
  }
  
  func save(gener: GenresMovie, image: UIImage) {
    if !self.cacheGeners.contains(where: {$0.id == gener.id}) {
        self.cacheGeners.append(gener)
      let item = GenerMovieStruct(genres: gener, image: image)
      self.cacheGennerStruct.append(item)
    }else {
      return
    }
    self.fetchMovieForGenerID(with: "\(gener.id)")
  }
  
  func setMovieLike(movie: Movie) {
    if !self.movieLikes.contains(where: {$0.id ?? 0 == movie.id ?? 0}) {
      self.movieLikes.append(movie)
    }else {
      return
    }
  }
  
  func setSelectedMovie(movie: Movie) {
    if !self.seclectedMovies.contains(where: {$0.id ?? 0 == movie.id ?? 0}) {
      self.seclectedMovies.append(movie)
    }else {
      return
    }
  }
  
  func isSelected(with movies: [Movie], movie: Movie) -> Bool {
    return movies.contains(where: {$0.id ?? 0 == movie.id})
  }
  
  func isSelectedGener(gener: GenresMovie) -> Bool {
    return self.cacheGennerStruct.map({$0.genres}).contains(where: {$0?.id == gener.id})
  }
  
  func getIndexForSelectedGener() -> Int {
    return self.cacheGeners.count - 1
  }
  
  func isCanLoadMore(with bool: Bool) {
    self.canLoadMore = bool
  }
  
  func checkGenerMovie(_ movie: [Movie]) -> [Movie] {
    var movieGeners: [Movie] = []
    if movie.isEmpty {
      movieGeners = self.topRateMovies
    }else {
      for i in cacheGeners {
        let arrays = topRateMovies.filter({$0.genreIds.contains(where: {$0 == Int(i.id)})})
        movieGeners = arrays
      }
      return movieGeners
    }
    return movieGeners
  }
  
  func removeMovieLike() {
    self.movieLikes.removeAll()
  }
  
  func removeSelectedMovie(_ index: Int) {
    self.seclectedMovies.remove(at: index)
  }
  
  func removeSelectedMovieAll() {
    self.seclectedMovies.removeAll()
  }
  
  func removeSearchMovie() {
    self.searchMovie.removeAll()
  }
  
  func removeGenerMovie() {
    self.movieGeners.removeAll()
  }
}

extension MovieManager {
  func getGenersName(with id: Int) -> String {
    switch id {
    case 28:
      return "Action"
    case 12:
      return "Adventure"
    case 16:
      return "Animation"
    case 35:
      return "Comedy"
    case 80:
      return "Crime"
    case 99:
      return "Documentary"
    case 18:
      return "Animation"
    case 10751:
      return "Family"
    case 14:
      return "Fantasy"
    case 36:
      return "History"
    case 27:
      return "Horror"
    case 10402:
      return "Animation"
    case 9648:
      return "Mystery"
    case 10749:
      return "Romance"
    case 878:
      return "Science Fiction"
    case 10770:
      return "TV Movie"
    case 53:
      return "Thriller"
    case 10752:
      return "War"
    case 37:
      return "Western"
    default:
      return ""
    }
  }
}
