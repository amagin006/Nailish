//
//  MainCalenderViewController.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-26.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit
import FSCalendar

private let cellId = "cellId"

class MainCalenderViewController: UIViewController {

    let gregorian: Calendar = Calendar(identifier: .gregorian)
    private let myArray = ["First","Second","Third"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendar()
        setupTableViewUI()
        
    }
    
    private func setupCalendar() {
        view.addSubview(calendarView)
        calendarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        calendarView.heightAnchor.constraint(equalToConstant: 300).isActive = true
  
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
        view.addSubview(appointTitleLabel)
        appointTitleLabel.topAnchor.constraint(equalTo: calendarView.bottomAnchor).isActive = true
        appointTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        appointTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        appointTitleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(appointTableView)
        appointTableView.topAnchor.constraint(equalTo: appointTitleLabel.bottomAnchor).isActive = true
        appointTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        appointTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appointTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        appointTableView.delegate = self
        appointTableView.dataSource = self
        appointTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }

    

    
    // UI Parts
    let calendarView: FSCalendar = {
        let cl = FSCalendar(frame: CGRect(x: 0, y: 0, width: 320, height: 400))
        cl.translatesAutoresizingMaskIntoConstraints = false
        return cl
    }()
    
    let appointTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let appointTitleLabel: MyUILabel = {
        let lb = MyUILabel()
        lb.text = "Appointment"
        lb.font = UIFont.boldSystemFont(ofSize: 26)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.7957356597, green: 0.9098039269, blue: 0.5860904475, alpha: 1))
        return lb
    }()

}

extension MainCalenderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = myArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }


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
        let selectDate = getDay(date)
        print(selectDate)
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
