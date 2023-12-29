//
//  TvShowManager.swift
//  Moffy
//
//  Created by MRX on 18/12/2023.
//

import UIKit
import Combine

class TvShowManager {
  static let shared = TvShowManager()
  @Published var geners: [GenerTvShow] = []
  @Published var cacheGeners: [GenerTvShow] = []
  @Published var topRateTvShow: [Movie] = []
  @Published var tvShowGener: [Movie] = []
  @Published var tvShowLike: [Movie] = []
  @Published var searchTvShow: [Movie] = []
  @Published private(set) var canLoadMore: Bool = false
  private var currenPage: Int = 1
  
}

extension TvShowManager {
  func fetchGenerTV() {
    Task {
      do {
        let generTvShowResponse = try await APIManager.shared.getModel(with: GenerTvShowResponse.self, request: .generTV)
        self.geners = generTvShowResponse.genres
      }
      catch let error {
        print("vuongdv error", error.localizedDescription)
      }
    }
  }
  
  func fecthTvShowToprate() {
    Task {
      do {
        let tvShowResponse = try await APIManager.shared.getModel(with: MovieRespone.self,
                                                                  request: .tvShowTopRate(page: String(self.currenPage)))
        topRateTvShow.append(contentsOf: tvShowResponse.results ?? [Movie]())
        
        if self.currenPage < tvShowResponse.totalPages ?? 0 {
          self.currenPage += 1
          self.canLoadMore = true
        }
        
        if self.canLoadMore  {
          topRateTvShow.append(contentsOf: tvShowResponse.results ?? [])
        }
        
        if checkGenerName(topRateTvShow).isEmpty {
          self.tvShowGener = topRateTvShow
        }else {
          self.tvShowGener = checkGenerName(topRateTvShow)
        }
      }
      catch let error {
        print("vuongdv error", error.localizedDescription)
      }
    }
  }
  
  func save(with gener: GenerTvShow) {
    if !self.cacheGeners.contains(where: {$0.id == gener.id}) {
      self.cacheGeners.append(gener)
    }else {
      return
    }
  }
  
  func setTvShowLike(tvShow: Movie) {
    if !self.tvShowLike.contains(where: {$0.id ?? 0 == tvShow.id ?? 0}) {
      self.tvShowLike.append(tvShow)
    }else {
      return
    }
  }
  
  func isSelected(tvShow: Movie) -> Bool {
    return self.tvShowLike.contains(where: {$0.id ?? 0 == tvShow.id ?? 0})
  }
  
  func isSelectedGenerTVShow(tvshow: GenerTvShow) -> Bool {
    return self.cacheGeners.contains(where: {$0.id == tvshow.id})
  }
  
  func checkGenerName(_ movie: [Movie]) -> [Movie] {
    var tvShowGener: [Movie] = []
    if movie.isEmpty {
      tvShowGener = self.topRateTvShow
    }else {
      for i in cacheGeners {
        let arrays = topRateTvShow.filter({$0.genreIds.contains(where: {$0 == Int(i.id )})})
        tvShowGener = arrays
      }
      return tvShowGener
    }
    return tvShowGener
  }
  
  func searchTvShow(with query: String) {
    Task {
      do {
        if query.isEmpty {
          self.tvShowGener = checkGenerName(topRateTvShow)
          
        } else {
          //self.tvShowGener.removeAll()
          let tvShowResponse = try await APIManager.shared.getModel(with: MovieRespone.self, request: APIService.searchTvShow(page: String(self.currenPage), query: query))
          self.tvShowGener = tvShowResponse.results ?? [Movie]()
          self.searchTvShow.append(contentsOf: tvShowResponse.results ?? [Movie]())
          
          if self.currenPage < tvShowResponse.totalPages ?? 0 {
            self.currenPage += 1
            self.canLoadMore = true
          }
          
          if self.canLoadMore  {
            self.topRateTvShow.append(contentsOf: tvShowResponse.results ?? [Movie]())
            print("vuongdv", self.searchTvShow.count)
          }
        }
      }
      catch let error {
        print("vuongdv error", error.localizedDescription)
      }
    }
  }
  
  func removeTvShowLike() {
    self.tvShowLike.removeAll()
  }
  func removeSearchTvShow() {
    self.searchTvShow.removeAll()
  }
  
  func removetopRateTvShow() {
    self.topRateTvShow.removeAll()
  }
}

extension TvShowManager {
//  @MainActor
//  private func getGenersTvShow(_ geners: [GenerTvShow]) {
//    var array: [GenerTvShowObject] = []
//    geners.forEach { gener in
//      if let generObject = RealmService.shared.getById(ofType: GenerTvShowObject.self, id: "\(gener.id)") {
//        array.append(generObject)
//      }else {
//        let generObject = GenerTvShowObject(genre: gener)
//        array.append(generObject)
//      }
//    }
//    self.geners = array
//  }
}

extension TvShowManager {
  func getGenersName(with id: Int) -> String {
    switch id {
    case 10759:
      return "Action & Adventure"
    case 16:
      return "Animation"
    case 35:
      return "Comedy"
    case 80:
      return "Crime"
    case 99:
      return "Documentary"
    case 18:
      return "Drama"
    case 10751:
      return "Family"
    case 10762:
      return "Kids"
    case 9648:
      return "Mystery"
    case 10763:
      return "News"
    case 10764:
      return "Reality"
    case 10765:
      return "Sci-Fi & Fantasy"
    case 10766:
      return "Soap"
    case 10767:
      return "Talk"
    case 10768:
      return "War & Politics"
    case 37:
      return "Western"
    default:
      return "Nill"
    }
  }
}
