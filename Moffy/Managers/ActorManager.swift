//
//  ActorManager.swift
//  Moffy
//
//  Created by MRX on 26/12/2023.
//

import UIKit
import Combine

class ActorManager {
    static let shared = ActorManager()
    
    @Published var actors: [Actor] = []
    @Published var movie: [Movie] = []
}

extension ActorManager {
    func searchActor(with query: String) {
        self.movie.removeAll()
        Task {
            do {
                let actorResponse = try await APIManager.shared.getModel(with: ActorResponse.self, request: .searchActor(page: "1", query: query))
                self.actors = actorResponse.results
                let movie = self.actors.map({$0.knownFor}).map({$0})
                movie.forEach { item in
                    self.movie.append(contentsOf: item)
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
