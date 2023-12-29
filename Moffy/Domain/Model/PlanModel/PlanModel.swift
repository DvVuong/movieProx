//
//  SuggestPlanModel.swift
//  Moffy
//
//  Created by MRX on 21/12/2023.
//

import UIKit

struct PlanModel {
    var id = UUID()
    var titlePlan: String
    var startDate: Date
    var endDate: Date
    var generPlan: String
    var movie: [Movie]
    var imageCoverPlan: String?
    var note: String?
}
