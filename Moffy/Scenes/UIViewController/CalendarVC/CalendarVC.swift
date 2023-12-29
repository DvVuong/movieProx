//
//  CalendarVC.swift
//  Moffy
//
//  Created by MRX on 27/12/2023.
//

import UIKit

protocol CalendarVCDelegate: AnyObject {
  func didChooseStartDate(with date: Date)
  func diChooseEndDate(with date: Date)
}

class CalendarVC: BaseViewController {
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var doneButton: UIButton!
  @IBOutlet weak var calendarview: CustomCalendarView!
  
  private var selectedDate: Date = Date()
  var handlerChooseDate: ((Date) -> Void)? = nil
  
  var isSelectedStartDate: Bool = true
  
  weak var delegate: CalendarVCDelegate?
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.calendarview.delegate = self
    self.calendarview.isSelectedStartDate = self.isSelectedStartDate
  }
  
  @IBAction func didTapBackButton(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
  @IBAction func didTapDoneButton(_ sender: Any) {
    self.dismiss(animated: true)
    self.handlerChooseDate?(selectedDate)
  }
}

extension CalendarVC: CustomCalendarViewDelegate {
  func didSelectedStartDate(with date: Date) {
    delegate?.didChooseStartDate(with: date)
  }
  
  func didSelectedEndDate(with date: Date) {
    delegate?.diChooseEndDate(with: date)
  }
}
