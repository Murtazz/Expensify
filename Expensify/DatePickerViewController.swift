//
//  DatePickerViewController.swift
//  Expensify
//
//  Created by Murtaza Khalid on 2023-04-18.
//

import UIKit

class DatePickerViewController: UIViewController {

    @IBOutlet weak var datePicked: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicked.contentHorizontalAlignment = .center
        // Do any additional setup after loading the view.
    }
    func getDatePicked() -> Date {
        return datePicked.date
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
