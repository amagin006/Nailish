//
//  MainCalenderViewController.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-26.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit
import FSCalendar
import CoreData

private let cellId = "cellId"

class MainCalenderViewController: FetchTableViewController, UITableViewDataSource {

    let gregorian: Calendar = Calendar(identifier: .gregorian)
    var selectDate = Date()
    
    override func viewWillAppear(_ animated: Bool) {
        calendarView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton: UIBarButtonItem = {
            let bt = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAppointmentPressed))
            return bt
        }()
        navigationItem.rightBarButtonItem = addButton
        self.tableView = appointTableView
        setupCalendar()
        setupTableViewUI()
        getAppointmentdata(date: selectDate)
    }
    
    private func setupCalendar() {
        view.addSubview(calendarView)
        calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        calendarView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
  
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.scrollDirection = .horizontal
        calendarView.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 20)
        calendarView.appearance.headerTitleColor = UIColor(cgColor: #colorLiteral(red: 0.1657347977, green: 0.4068609476, blue: 0.3094298542, alpha: 1))
        calendarView.appearance.weekdayTextColor = UIColor(cgColor: #colorLiteral(red: 0.1657347977, green: 0.4068609476, blue: 0.3094298542, alpha: 1))
//        let swipUpGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipUp))
//        swipUpGesture.direction = .up
//        let swipDownGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipDown))
//        swipDownGesture.direction = .down
//        self.calendarView.addGestureRecognizer(swipUpGesture)
//        self.calendarView.addGestureRecognizer(swipDownGesture)
    }
    
    private func setupTableViewUI() {
        view.addSubview(appointTitleView)
        appointTitleView.topAnchor.constraint(equalTo: calendarView.bottomAnchor).isActive = true
        appointTitleView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        appointTitleView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        appointTitleView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        appointTitleView.addSubview(appointTitleLabel)
        appointTitleLabel.leadingAnchor.constraint(equalTo: appointTitleView.leadingAnchor, constant: 20).isActive = true
        appointTitleLabel.centerYAnchor.constraint(equalTo: appointTitleView.centerYAnchor).isActive = true
        
        appointTitleView.addSubview(addAppointmentButton)
        addAppointmentButton.trailingAnchor.constraint(equalTo: appointTitleView.trailingAnchor, constant: -20).isActive = true
        addAppointmentButton.centerYAnchor.constraint(equalTo: appointTitleView.centerYAnchor).isActive = true
        
        view.addSubview(appointTableView)
        appointTableView.topAnchor.constraint(equalTo: appointTitleView.bottomAnchor).isActive = true
        appointTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        appointTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appointTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        appointTableView.delegate = self
        appointTableView.dataSource = self
        appointTableView.separatorColor = .clear
        appointTableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    func getAppointmentdata(date: Date) {
        let predicate = NSPredicate(format: "%@ =< visitDate AND visitDate < %@", getBeginingAndEndOfDay(date).begining as CVarArg, getBeginingAndEndOfDay(date).end as CVarArg)
        let startTimeDescriptors = NSSortDescriptor(key: "startTime", ascending: true)
        fetchedReportItemResultsController.fetchRequest.sortDescriptors = [startTimeDescriptors]
        fetchedReportItemResultsController.fetchRequest.predicate = predicate
        do {
            try fetchedReportItemResultsController.performFetch()
        } catch let err {
            print(err)
        }
    }

    @objc func addAppointmentPressed() {
        let addAppointmentVC = AddAppointmentViewController()
        addAppointmentVC.selectedDate = selectDate
        self.navigationController?.pushViewController(addAppointmentVC, animated: true)
    }
    
    // appointTableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CalendarTableViewCell
        cell.appointmentReport = fetchedReportItemResultsController.object(at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedReportItemResultsController.sections?[section].numberOfObjects {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let count = fetchedReportItemResultsController.sections?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addAppointmentVC = AddAppointmentViewController()
        getAppointmentdata(date: selectDate)
        let appointment = fetchedReportItemResultsController.object(at: indexPath)
        addAppointmentVC.reportItem = appointment
        self.navigationController?.pushViewController(addAppointmentVC, animated: true)
    }
    
    // UI Parts
    let calendarView: FSCalendar = {
        let cl = FSCalendar(frame: CGRect(x: 0, y: 0, width: 320, height: 400))
        cl.translatesAutoresizingMaskIntoConstraints = false
        return cl
    }()
    
    lazy var appointTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let appointTitleView: UIView = {
        let tv = UIView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.init(red: 150/255, green: 206/255, blue: 180/255, alpha: 1)
        return tv
    }()
    
    let appointTitleLabel: MyUILabel = {
        let lb = MyUILabel()
        lb.text = "Appointment"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .white
        return lb
    }()
    
    let addAppointmentButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("Add", for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.titleLabel?.text = "Add"
        bt.addTarget(self, action: #selector(addAppointmentPressed), for: .touchUpInside)
        return bt
    }()

    
}

extension MainCalenderViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    func getWeekIndex(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let weekday = getWeekIndex(date)
        if weekday == 1 {
            return UIColor.red
        } else if weekday == 7 {
            return UIColor.blue
        }
        return nil
    }
    
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        getAppointmentdata(date: date)
        selectDate = date
        appointTableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        getAppointmentdata(date: date)
        return fetchedReportItemResultsController.fetchedObjects?.count ?? 0
    }
    
    private func getBeginingAndEndOfDay(_ date:Date) -> (begining: Date , end: Date) {
        let begining = Calendar(identifier: .gregorian).startOfDay(for: date)
        let end = begining + 24*60*60
        return (begining, end)
    }
    //    @objc func swipUp() {
    //        self.calendarView.setScope(.week, animated: true)
    //    }
    //
    //    @objc func swipDown() {
    //        self.calendarView.setScope(.month, animated: true)
    //    }
    //
    //    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
    //        calendarView.heightAnchor.constraint(equalToConstant: bounds.height)
    //        self.calendarView.layoutIfNeeded()
    //    }

}
