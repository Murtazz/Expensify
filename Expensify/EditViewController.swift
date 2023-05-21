//
//  EditViewController.swift
//  Expensify
//
//  Created by Murtaza Khalid on 2023-04-21.
//

import UIKit
import CoreData

class EditViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var popUpButtonCategory: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var merchant: UITextField!
    
    @IBOutlet weak var amount: UITextField!
    
    @IBOutlet weak var debitOrCredit: UISegmentedControl!
    var selectedTransaction: Transaction?
    var receiptImage = SharedTransactionCollection.sharedTransactionCollection.transactionList?.tappedTran?.receiptImg ?? nil
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPopUpButton()
        self.merchant.delegate = self
        self.amount.delegate = self
        datePicker.contentHorizontalAlignment = .left
        selectedTransaction = SharedTransactionCollection.sharedTransactionCollection.transactionList?.tappedTran
        merchant.text = selectedTransaction?.merchant
        amount.text = selectedTransaction?.amount.description
        datePicker.date = selectedTransaction?.dateId ?? Date()
        if selectedTransaction?.type == "debit" {
            debitOrCredit.selectedSegmentIndex = 0
        } else {
            debitOrCredit.selectedSegmentIndex = 1
        }
        // Do any additional setup after loading the view.
    }
    
    func setupPopUpButton() {
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
    
    @IBAction func tap(_ sender: Any) {
        merchant.resignFirstResponder()
        amount.resignFirstResponder()
    }
    func createAlert(title: String, message: String, actTitle: String) { // alert creator for multiple use
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: actTitle, style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func update(_ sender: Any) {
        if merchant.text == "" {
            createAlert(title: "Missing Merchant Name.", message: "please add merchant name", actTitle: "OK")
            return
        }
        var amountdouble: Double
        if let amt = Double(amount.text!) {
            amountdouble = amt
        } else {
            createAlert(title: "Missing Amount.", message: "please enter the amount", actTitle: "OK")
            return
        }
        let debCred = checkSign()
        let category = popUpButtonCategory.titleLabel?.text
        let cid = getCid(category: category!)
        let formattedDate = String(datePicker.date.formatted(date: .long, time: .shortened))
        
       
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        do {
            let results: NSArray = try context.fetch(request) as NSArray
            for result in results {
                let transaction = result as! Transaction
                if selectedTransaction == transaction {
                    transaction.date = formattedDate
                    transaction.merchant = merchant.text
                    transaction.amount = amountdouble as NSNumber
                    transaction.type = debCred
                    transaction.categoryid = cid as NSNumber
                    transaction.category = category!
                    transaction.receiptImg = receiptImage ?? nil
                    transaction.dateId = datePicker.date
                    SharedTransactionCollection.sharedTransactionCollection.transactionList?.updateTransaction(with: transaction)
                    SharedTransactionCollection.sharedTransactionCollection.transactionList?.tappedTran = transaction
                }
            }
        } catch {
            print("Fetch Failed")
        }
        
        
       
        
        //print(transDate)
        /*
        let id = SharedTransactionCollection.sharedTransactionCollection.transactionList!.tappedTran?.id
        let newTransaction = Transaction(id: id!, date: formattedDate, merchant: merchant.text!, amount: amountdouble, type: debCred, categoryid: cid, category: category!, receiptImg: receiptImage, dateid: datePicker.date)
        SharedTransactionCollection.sharedTransactionCollection.transactionList?.updateTransaction(with: newTransaction)
        SharedTransactionCollection.sharedTransactionCollection.transactionList?.tappedTran = newTransaction
        */
        createAlert(title: "Transaction Updated", message: "your transaction has been updated.", actTitle: "OK")
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
    
    @IBAction func picture(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present (picker, animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss (animated: true, completion: nil)
    }
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //didFinishPickingMediaWithInfo info: [UIImagePickerController. InfoKey : Any])
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("image not working")
            return
        }
        receiptImage = image.pngData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if merchant == textField {
            print("return pressed")
            merchant.resignFirstResponder()
        } else if amount == textField {
            print("return pressed")
            amount.resignFirstResponder()
            
        }
        return true
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
