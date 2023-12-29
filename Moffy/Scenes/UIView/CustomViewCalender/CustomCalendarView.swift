//
//  CustomCalendarView.swift
//  Moffy
//
//  Created by MRX on 27/12/2023.
//

import UIKit
import FSCalendar
import SnapKit

protocol CustomCalendarViewDelegate: AnyObject {
  func didSelectedStartDate(with date: Date)
  func didSelectedEndDate(with date: Date)
}

class CustomCalendarView: UIView {
  private var calendarView: FSCalendar!
  private var selectedDate: Date?
  private var collectionView: UICollectionView!
  
  private var listMonths: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
  private var listYears: [String] = ["2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023", "2024", "2025", "2026"]
  
  private var datas: [String] = []
  private var cacheSelectedMonth: [Int] = []
  private var currentMonth: Int = 0
  private var currentYear: Int = 0
  private var isChangeMonthToYear: Bool = true
  
  var height: CGFloat?
  var isSelectedStartDate: Bool = true
  
  weak var delegate: CustomCalendarViewDelegate?
  
  private lazy var monthButton: UIButton = {
    let monthButton = UIButton()
    monthButton.setTitle("month", for: .normal)
    monthButton.titleLabel?.font = UIFont(name: "Quicksand-SemiBold", size: 14)
    monthButton.setTitleColor(UIColor(rgb: 0x595959), for: .normal)
    return monthButton
  }()
  
  private lazy var linelable: UILabel = {
    let linelable = UILabel()
    linelable.text = "-"
    return linelable
  }()
  
  private lazy var yearButton: UIButton = {
    let yearButton = UIButton()
    yearButton.setTitle("year", for: .normal)
    yearButton.titleLabel?.font = UIFont(name: "Quicksand-SemiBold", size: 14)
    yearButton.setTitleColor(UIColor(rgb: 0x595959), for: .normal)
    return yearButton
  }()
  
  private lazy var yearLabel: UILabel = {
    let yearLabel = UILabel()
    yearLabel.font = UIFont(name: "Quicksand-Regular", size: 14)
    yearLabel.textColor = UIColor(rgb: 0x595959)
    yearLabel.textAlignment = .center
    yearLabel.isHidden = true
    return yearLabel
  }()
  
  private var month: String = ""
  private var year: String  = ""
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.setupCalendar()
    setupMonthCollectionView()
  }
  
  private func setupMonthCollectionView() {
    let layout = UICollectionViewFlowLayout()
    self.collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
    self.collectionView.registerNib(ofType: MonthCVC.self)
    self.collectionView.isHidden = true
    self.collectionView.performBatchUpdates(nil, completion: nil)
    self.addSubview(collectionView)
    self.makeCollectionview()
  }
  
  private func makeCollectionview() {
    self.collectionView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(60)
      make.trailing.equalToSuperview().offset(-24)
      make.leading.equalToSuperview().offset(24)
      make.bottom.equalToSuperview().offset(-24)
    }
  }
  
  private func setupCalendar() {
    calendarView = FSCalendar(frame: CGRect(x: 0, y: 0, width: self.frame.width * 0.8, height: self.frame.height * 0.8))
    calendarView.delegate = self
    calendarView.dataSource = self
    calendarView.appearance.headerDateFormat = ""
    calendarView.appearance.headerTitleFont = UIFont(name: "Quicksand-SemiBold", size: 14)
    calendarView.appearance.headerTitleColor = UIColor(rgb: 0x595959)
    calendarView.appearance.weekdayTextColor = UIColor(rgb: 0x595959)
    calendarView.appearance.weekdayFont = UIFont(name: "Quicksand-SemiBold", size: 14)
    calendarView.appearance.titleDefaultColor = UIColor(rgb: 0x595959)
    calendarView.appearance.titleFont = UIFont(name: "Quicksand-Regular", size: 14)
    calendarView.appearance.titleTodayColor = UIColor(rgb: 0xFBF9FF)
    calendarView.appearance.borderRadius = 0.5
    month = calendarView.currentPage.asFormatterString(with: "MMMM")
    year  = calendarView.currentPage.asFormatterString(with: "yyyy")
    self.currentMonth = calendarView.currentPage.getMonth()
    self.currentYear = calendarView.currentPage.getYearToInt()
    
    if let date = selectedDate {
      calendarView.select(date, scrollToDate: true)
    }
    
    calendarView.reloadData()
    calendarView.today = selectedDate
    self.addSubview(calendarView)
    self.addSubview(yearLabel)
    self.addSubview(monthButton)
    self.addSubview(linelable)
    self.addSubview(yearButton)
    self.makeCalendarContrains()
    self.makeTitleForButton(with: month, year: year)
    self.makeTitleForYearLabel("\(self.currentYear)")
  }
  
  private func makeCalendarContrains() {
    calendarView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-24)
      make.leading.equalToSuperview().offset(24)
      make.bottom.equalToSuperview().offset(-24)
    }
    self.layoutIfNeeded()
    self.makeHearderForCalendar()
  }
  
  private func makeHearderForCalendar() {
    self.monthButton.addTarget(self, action: #selector(didTapMonthButton(_:)), for: .touchUpInside)
    self.yearButton.addTarget(self, action: #selector(didTapYearButton(_:)), for: .touchUpInside)
    
    let header = calendarView.calendarHeaderView
    header.scrollEnabled = false
    
    let prevButton = UIButton()
    prevButton.setImage(UIImage(named: "ic_prev")?.withRenderingMode(.alwaysOriginal), for: .normal)
    prevButton.addTarget(self, action: #selector(didTapPrevButton(_:)), for: .touchUpInside)
    self.addSubview(prevButton)
    
    let nextButton = UIButton()
    nextButton.setImage(UIImage(named: "ic_next")?.withRenderingMode(.alwaysOriginal), for: .normal)
    nextButton.addTarget(self, action: #selector(didTapNextButton(_:)), for: .touchUpInside)
    self.addSubview(nextButton)
    
    prevButton.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.centerY.equalTo(header.snp.centerY)
      make.left.equalTo(header.snp.left)
      make.height.equalTo(header.snp.height)
      make.width.equalTo(40)
    }
    
    nextButton.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.centerY.equalTo(header.snp.centerY)
      make.right.equalTo(header.snp.right)
      make.height.equalTo(header.snp.height)
      make.width.equalTo(40)
    }
    
    self.yearLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(25)
      make.centerX.equalTo(header.snp.centerX)
      make.width.equalTo(100)
      make.height.equalTo(24)
    }
    
    monthButton.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.centerY.equalTo(header.snp.centerY)
      make.left.equalTo(prevButton.snp.right).offset(10)
      make.height.equalTo(header.snp.height)
      make.width.greaterThanOrEqualTo(100)
    }
    
    linelable.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(25)
      make.left.greaterThanOrEqualTo(prevButton.snp.right).offset(105)
      make.width.equalTo(6)
      make.height.equalTo(26)
    }
    
    yearButton.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.centerY.equalTo(header.snp.centerY)
      make.right.equalTo(nextButton.snp.left).offset(10)
      make.height.equalTo(header.snp.height)
      make.width.equalTo(100)
    }
    
    self.layoutIfNeeded()
  }
  
  private func scrollToNextMonth() {
    calendarView.setCurrentPage(calendarView.currentPage.add(month: 1) ?? Date(), animated: true)
    calendarView.reloadData()
    month = calendarView.currentPage.asFormatterString(with: "MMMM")
    year = calendarView.currentPage.asFormatterString(with: "yyyy")
    self.makeTitleForButton(with: month, year: year)
  }
  
  private func scrollToPrevMonth() {
    calendarView.setCurrentPage(calendarView.currentPage.add(month: -1) ?? Date(), animated: true)
    calendarView.reloadData()
    month =  calendarView.currentPage.asFormatterString(with: "MMMM")
    year = calendarView.currentPage.asFormatterString(with: "yyyy")
    self.makeTitleForButton(with: month, year: year)
  }
  
  private func makeTitleForButton(with month: String, year: String) {
    monthButton.setTitle(month, for: .normal)
    yearButton.setTitle(year, for: .normal)
  }
  
  private func scrollToMonth(with monthNumber: Int) {
    let index = monthNumber
    let monthNum = Calendar.current.date(byAdding: .month, value: index - self.currentMonth, to: calendarView.currentPage)
    calendarView.setCurrentPage(monthNum!, animated: true)
    self.currentMonth = calendarView.currentPage.getMonth()
    month =  calendarView.currentPage.asFormatterString(with: "MMMM")
    year = calendarView.currentPage.asFormatterString(with: "yyyy")
    self.calendarView.reloadData()
    self.makeTitleForButton(with: month, year: year)
  }
  
  private func scrollToYear(with yearName: String) {
    let index = (Int(yearName) ?? 0) - self.currentYear
    let yearNum = Calendar.current.date(byAdding: .year, value: index, to: calendarView.currentPage)
    calendarView.setCurrentPage(yearNum!, animated: true)
    self.currentYear = calendarView.currentPage.getYearToInt()
    month =  calendarView.currentPage.asFormatterString(with: "MMMM")
    year = calendarView.currentPage.asFormatterString(with: "yyyy")
    self.calendarView.reloadData()
    self.makeTitleForButton(with: month, year: year)
  }
  
  private func makeTitleForYearLabel(_ year: String) {
    self.yearLabel.text = year
  }
  
  private func showCompnens() {
    self.collectionView.isHidden = false
    self.monthButton.isHidden = true
    self.linelable.isHidden = true
    self.yearLabel.isHidden = false
    self.yearButton.isHidden = true
  }
  
  private func hideComponse() {
    self.collectionView.isHidden = true
    self.monthButton.isHidden = false
    self.linelable.isHidden = false
    self.yearButton.isHidden = false
    self.yearLabel.isHidden = true
  }
}

extension CustomCalendarView {
  @objc private func didTapPrevButton(_ sender: UIButton) {
    if isChangeMonthToYear {
      self.scrollToPrevMonth()
      
    }else {
      print("nam truoc")
    }
  }
  
  @objc private func didTapNextButton(_ sender: UIButton) {
    if isChangeMonthToYear {
      self.scrollToNextMonth()
      
    }else {
      print("nam sau")
    }
  }
  
  @objc private func didTapMonthButton(_ sender: UIButton) {
    self.showCompnens()
    self.collectionView.reloadData()
    self.makeTitleForYearLabel(self.year)
  }
  
  @objc private func didTapYearButton(_ sender: UIButton) {
    self.showCompnens()
    self.collectionView.reloadData()
    self.isChangeMonthToYear.toggle()
    let firstItem = self.listYears.first ?? ""
    let endItem = self.listYears.last ?? ""
    self.makeTitleForYearLabel("\(firstItem) - \(endItem)")
  }
}

//MARK: FSCalendarDelegate
extension CustomCalendarView: FSCalendarDelegate {
  //  func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
  //    self.height = bounds.height
  //    self.frame.size.height = bounds.height
  //  }
  //
  //  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  //      // Here you can return specify the height of the cell.
  //    return  self.height ?? 0.0
  //  }
  
}

extension CustomCalendarView: FSCalendarDataSource {
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    if self.isSelectedStartDate {
      self.delegate?.didSelectedStartDate(with: date)
    }else {
      self.delegate?.didSelectedEndDate(with: date)
    }
  }
}

//MARK: - CollectionView
extension CustomCalendarView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if self.isChangeMonthToYear {
      return self.listMonths.count
    }else {
      return self.listYears.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeue(ofType: MonthCVC.self, indexPath: indexPath)
    if self.isChangeMonthToYear {
      let month = self.listMonths[indexPath.row]
      cell.bindingData(month, index: indexPath.row)
      cell.handlerChooseItem = {[weak self] month, _ in
        if let `self` = self {
          cell.selected()
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.hideComponse()
            cell.deSelected()
          }
          self.scrollToMonth(with: month)
        }
      }
      return cell
      
    }else {
      let month = self.listYears[indexPath.row]
      cell.bindingData(month, index: indexPath.row)
      cell.handlerChooseItem = {[weak self] month, year in
        if let `self` = self {
          cell.selected()
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.hideComponse()
            cell.deSelected()
            self.isChangeMonthToYear = true
          }
          self.scrollToYear(with: year)
        }
      }
      return cell
    }
  }
}

extension CustomCalendarView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let withItem = collectionView.frame.width / 4
    return CGSize(width: withItem, height: 72)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 0
  }
}
