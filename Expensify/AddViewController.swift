//
//  AddViewController.swift
//  Expensify
//
//  Created by Murtaza Khalid on 2023-04-17.
//

import UIKit
import CoreData

class AddViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var popUpButtonCategory: UIButton!
    
    @IBOutlet weak var displayDate: UILabel!
    @IBOutlet weak var debitOrCredit: UISegmentedControl!
    @IBOutlet weak var merchName: UITextField!
    @IBOutlet weak var amountWorkings: UILabel!
    
    var chosenCategory: String?
    var chosenid: Int?
    var receiptImage: UIImage?
    
    func addnum(no: String) {
        let current = amountWorkings.text ?? ""
        amountWorkings.text = current + no
    }
    @IBAction func clear(_ sender: Any) {
        amountWorkings.text = ""
    }
    
    @IBAction func one(_ sender: Any) {
        addnum(no: "1")
    }
    
    @IBAction func two(_ sender: Any) {
        addnum(no: "2")
    }
    @IBAction func three(_ sender: Any) {
        addnum(no: "3")
    }
    @IBAction func four(_ sender: Any) {
        addnum(no: "4")
    }
    @IBAction func five(_ sender: Any) {
        addnum(no: "5")
    }
    
    @IBAction func six(_ sender: Any) {
        addnum(no: "6")
    }
    @IBAction func seven(_ sender: Any) {
        addnum(no: "7")
    }
    @IBAction func eight(_ sender: Any) {
        addnum(no: "8")
    }
    @IBAction func nine(_ sender: Any) {
        addnum(no: "9")
    }
    @IBAction func zero(_ sender: Any) {
        addnum(no: "0")
    }
    @IBAction func dot(_ sender: Any) {
        addnum(no: ".")
    }
    func createAlert(title: String, message: String, actTitle: String) { // alert creator for multiple use
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: actTitle, style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func addTransaction(_ sender: Any) {
        if merchName.text == "" {
            createAlert(title: "Missing Merchant Name.", message: "please add merchant name", actTitle: "OK")
            return
        }
        var amountdouble: Double
        if let amt = Double(amountWorkings.text!) {
            amountdouble = amt
        } else {
            createAlert(title: "Missing Amount.", message: "please enter the amount", actTitle: "OK")
            return
        }
        let debCred = checkSign()
        let category = popUpButtonCategory.titleLabel?.text
        let cid = getCid(category: category!)
        let formattedDate = String(transDate.formatted(date: .long, time: .shortened))
        //print(transDate)
        let newid = SharedTransactionCollection.sharedTransactionCollection.transactionList!.current + 1
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: context)
        let newTransaction = Transaction(entity: entity!, insertInto: context)
        newTransaction.id = newid as NSNumber
        newTransaction.date = formattedDate
        newTransaction.merchant = merchName.text
        newTransaction.amount = amountdouble as NSNumber
        newTransaction.type = debCred
        newTransaction.categoryid = cid as NSNumber
        newTransaction.category = category!
        newTransaction.receiptImg = receiptImage?.pngData() ?? nil
        newTransaction.dateId = transDate
        SharedTransactionCollection.sharedTransactionCollection.transactionList?.addTrans(transaction: newTransaction)
        do {
            try context.save()
        } catch {
            print("context save error")
        }
        
        //let newTransaction = Transaction(id: newid, date: formattedDate, merchant: merchName.text!, amount: amountdouble, type: debCred, categoryid: cid, category: category!, receiptImg: receiptImage, dateid: transDate)
        
        merchName.text = ""
        amountWorkings.text = ""
        receiptImage = nil
        createAlert(title: "Transaction Created", message: "your transaction has been added.", actTitle: "OK")
    }
    func checkSign() -> String {
        if debitOrCredit.selectedSegmentIndex == 0 {
            return "debit"
        }
        return "credit"
    }
    func getCid(category: String) -> Int {
        switch category {
        case "Auto & Transport":
            return 1
        case "Bills & Utilities":
            return 2
        case "Entertainment":
            return 3
        case "Fees & Charges":
            return 4
        case "Food & Dining":
            return 5
        case "Home":
            return 6
        case "Income":
            return 7
        case "Shopping":
            return 8
        case "Transfer":
            return 9
        default:
            return 0
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setPopupButton()
        self.merchName.delegate = self
        displayDate.text = String(transDate.formatted(date: .numeric, time: .shortened))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func DebitCred(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
    }
    
    @IBAction func tap(_ sender: Any) {
        merchName.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == merchName {
            print("pressed return")
            merchName.resignFirstResponder()
        }
        return true
    }
    
    func setPopupButton () {
        let optionClosure = {(action : UIAction) in
            print (action.title)
        }
        self.popUpButtonCategory.menu = UIMenu(children :[
            UIAction(title: "Auto & Transport", state : .on, handler: optionClosure),
            UIAction(title : "Bills & Utilities",handler: optionClosure),
            UIAction (title: "Entertainment", handler: optionClosure),
            UIAction(title: "Fees & Charges", handler: optionClosure),
            UIAction(title : "Food & Dining", handler: optionClosure),
            UIAction (title: "Home", handler: optionClosure),
            UIAction(title: "Income", handler: optionClosure),
            UIAction(title : "Shopping", handler: optionClosure),
            UIAction (title: "Transfer", handler: optionClosure),
            UIAction (title: "Other", handler: optionClosure)
        ])
        self.popUpButtonCategory.showsMenuAsPrimaryAction = true
        self.popUpButtonCategory.changesSelectionAsPrimaryAction = true
    }

    var transDate: Date = Date()
    @IBAction func unwindToAdd(_ unwindSegue: UIStoryboardSegue) {
        if let datePickerViewController = unwindSegue.source as? DatePickerViewController {
            transDate = datePickerViewController.getDatePicked()
            print(transDate)
            displayDate.text = String(transDate.formatted(date: .long, time: .shortened))
            //print(transDate)
            //SharingFruitCollection.sharedFruitCollection.fruitCollection?.addFruit(fruit: fruit)
        }
    }
    
    
    
    @IBAction func cameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present (picker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss (animated: true, completion: nil)
    }
    
    @IBOutlet weak var test: UIImageView!
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //didFinishPickingMediaWithInfo info: [UIImagePickerController. InfoKey : Any])
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("image not working")
            return
        }
        receiptImage = image
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func dataFilePath() -> String {
          let urls = FileManager.default.urls(for:
             .documentDirectory, in: .userDomainMask)
          var url:String?
          url = urls.first?.appendingPathComponent("data.plist").path
          return url!
    } //dataFilePath 
    
}
