//
//  PlanManager.swift
//  Moffy
//
//  Created by MRX on 21/12/2023.
//

import Foundation
import Combine

class PlanManager {
  static let shared = PlanManager()
  @Published private(set) var suggestPlans: [PlanModel] = []
  @Published private(set) var planForWeekend: [PlanModel] = []
  @Published private(set) var yourPlan: [PlanModel] = []
}

extension PlanManager {
  func getRandomMoviesLike() {
    let movieLike = MovieManager.shared.movieLikes
    if movieLike.count >= 3 {
      let limiteMovie =  Array(movieLike.prefix(3))
      self.createPlanForWeekend(limiteMovie)
    }else {
      self.createPlanForWeekend(movieLike)
    }
  }
  
  func getRandomeMovieGener() {
    let movieGener = MovieManager.shared.movieGeners
    if movieGener.count >= 3 {
      let limtedMovie = Array(movieGener.shuffled().prefix(3))
      self.createPlanForWeekend(limtedMovie)
    }else {
      self.createPlanForWeekend(movieGener)
    }
  }
  
  private func createPlanForWeekend(_ movieGener: [Movie]) {
    //MARK: - Make PlanForWeekend
    let planForWeekend = PlanModel(titlePlan: "Plan for the weekend",
                                   startDate: Date(),
                                   endDate: Date(),
                                   generPlan: "Demo",
                                   movie: movieGener,
                                   note: "Plan for the weekend")
    
    
    //MARK: - Make Plan GenerMovie
    let randomGenerMovie = Array(movieGener.shuffled().prefix(3))
    let generID = randomGenerMovie.map({$0.genreIds}).first?.map({$0}).first
    let nameGener = MovieManager.shared.getGenersName(with: generID ?? 0)
    
    let planForGener = PlanModel(titlePlan: " \(nameGener) Plan",
                                 startDate: Date(),
                                 endDate: Date(),
                                 generPlan: nameGener,
                                 movie: randomGenerMovie,
                                 note: "Trong UIKit của iOS, alignmentRect(forFrame:) là một phương thức của UIView được sử dụng để tính toán một hình chữ nhật (rectangle) trong không gian tọa độ local của một view mà sẽ được đặt align (canh chỉnh) với các views khác. Nó liên quan đến hệ thống layout và quyết định vị trí và kích thước của một view dựa trên các quy tắc canh chỉnh và layout. Hàm này nhận một CGRect trong hệ thống tọa độ của view và trả về một hình chữ nhật (rectangle) mới, được điều chỉnh (aligned) để phản ánh việc canh chỉnh của view đối với các view khác trong cùng một hệ thống layout. Dưới đây là cách bạn có thể sử dụng alignmentRect(forFrame:):")
    
    
    //MARK: - Make Plan for NameMovie
    let randomMovie = Array(MovieManager.shared.movieGenerID.shuffled().prefix(3))
    let randomNameMovie = randomMovie.map({$0.title ?? ""}).first
    
    let planForNameMovie = PlanModel(titlePlan: randomNameMovie ?? "",
                                     startDate: Date(),
                                     endDate: Date(),
                                     generPlan: nameGener,
                                     movie: randomMovie,
                                     note: "Trong ví dụ trên, hàm heightForText được sử dụng để tính toán chiều cao dựa trên nội dung văn bản của mỗi item. Bạn có thể thay đổi logic tính toán chiều cao tùy thuộc vào nhu cầu cụ thể của bạn, chẳng hạn như tính toán chiều cao dựa trên hình ảnh hoặc nội dung phức tạp khác.")
    
    let movieLike = MovieManager.shared.movieGeners
    
    let demoPlan = PlanModel(titlePlan: "Demo Plan",
                             startDate: Date(),
                             endDate: Date(),
                             generPlan: "Action",
                             movie: movieLike)
    
    
    self.planForWeekend.append(planForGener)
    self.planForWeekend.append(planForWeekend)
    self.planForWeekend.append(planForNameMovie)
    self.yourPlan.append(demoPlan)
  }
  
  func createYourPlan(_ plan: PlanModel) {
    if !self.yourPlan.contains(where: {$0.id == plan.id}) {
      self.yourPlan.append(plan)
    }
  }
}
