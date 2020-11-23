//
//  AddTimePopupVC.swift
//  Triage
//
//  Created by Tamer Bader on 8/9/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit

class AddTimePopupVC: UIViewController {

    @IBOutlet var daysCollectionView: UICollectionView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var timePicker: UIDatePicker!
    @IBOutlet var selectDaysLabel: UILabel!
    
    weak var delegate: DropoffTimeDelegate?
    var selectedDays: [Int] = []
    
    // Editing Selection
    var isEditingSelection: Bool = false
    var currentDropoffTime: DropoffTime?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up collection view to show days
        daysCollectionView.delegate = self
        daysCollectionView.dataSource = self
        daysCollectionView.isUserInteractionEnabled = true
        daysCollectionView.allowsMultipleSelection = true
        
        // Screen UI Setup
        saveButton.layer.cornerRadius = 10
        
        // Check if data initialization is needed
        if (isEditingSelection) {
            initializeWithDropoffTime()
        }

        // Do any additional setup after loading the view.
    }
    
    func initializeWithDropoffTime() {
        guard let currentDropoffTime: DropoffTime = currentDropoffTime else { return }
        
        for day in currentDropoffTime.days {
            selectedDays.append(day.rawValue)
        }
        
        timePicker.date = currentDropoffTime.date
        
        daysCollectionView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func didTapSave(_ sender: UIButton) {
        
        // Check if user selected days
        
        if (selectedDays.count == 0) {
            selectDaysLabel.textColor = UIColor.red
            selectDaysLabel.shake()
            return
        }
        
        let date: Date = self.timePicker.date
        
        let formattedTime: String = date.apiFormat()
        var days: [Day] = []
        for day in selectedDays {
            let selectedDay: Day = Day(rawValue: day)!
            days.append(selectedDay)
        }
        
        let dropoffTime: DropoffTime = DropoffTime(time: formattedTime, days: days, date: date)
        
        dropoffTime.convertDropoffTimeToCronTime()
        
        if (isEditingSelection) {
            delegate?.didEditDropoffTime(time: dropoffTime, originalTime: currentDropoffTime!)
        } else {
            delegate?.didAddDropoffTime(time: dropoffTime)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc
    func didTapDay(sender: UIButton) {
      
        
        DispatchQueue.main.async {
            print("Hewwoo")
                  print(sender.tag)
            UIView.animate(withDuration: 0.05, animations: {
                if (self.selectedDays.contains(sender.tag)) {
                    self.selectedDays.remove(at: self.selectedDays.index(of: sender.tag)!)
                      } else {
                    self.selectedDays.append(sender.tag)
                      }
                var indexPaths: [IndexPath] = []
                indexPaths.append(IndexPath(item: sender.tag, section: 0))
                self.daysCollectionView.reloadItems(at: indexPaths)
            })
            
        }
        
    }
    
}

extension AddTimePopupVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:DayCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! DayCell
        switch (indexPath.item) {
        case 0:
            cell.dayButton.setTitle("Monday", for: .normal)
        case 1:
            cell.dayButton.setTitle("Tuesday", for: .normal)
        case 2:
            cell.dayButton.setTitle("Wednesday", for: .normal)
        case 3:
            cell.dayButton.setTitle("Thursday", for: .normal)
        case 4:
            cell.dayButton.setTitle("Friday", for: .normal)
        case 5:
            cell.dayButton.setTitle("Saturday", for: .normal)
        case 6:
            cell.dayButton.setTitle("Sunday", for: .normal)
        default:
            cell.dayButton.setTitle("Ummm", for: .normal)
        }
        cell.dayButton.tag = indexPath.item
        cell.dayButton.addTarget(self, action: #selector(didTapDay), for: .touchUpInside)
        cell.content.layer.cornerRadius = 5

        
        if (selectedDays.contains(indexPath.item)) {
            cell.content.backgroundColor = UIColor(displayP3Red: 0.249, green: 0.515, blue: 0.939, alpha: 1)
            cell.dayButton.setTitleColor(.white, for: .normal)
            
        } else {
            cell.content.backgroundColor = UIColor(displayP3Red: 0.925, green: 0.925, blue: 0.91, alpha: 1)
            cell.dayButton.setTitleColor(.black, for: .normal)

        }
        return cell
    }
    
        
    
}
