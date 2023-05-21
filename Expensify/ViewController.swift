//
//  ViewController.swift
//  Expensify
//
//  Created by Murtaza Khalid on 2023-04-17.
//

import UIKit
import CoreData
import Charts


class  TableViewCell: UITableViewCell {
    
    @IBOutlet weak var merchant: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var img: UIImageView!
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var firstload = true
    let cellIdentifier = "reuseIdentifier"
    let segueID = "showDetail"
    //var transactionPD = Transaction(date: "01/24/2022", merchant: "Apple", amount: 11.49, type: "debit", categoryid: 8, category: "Shopping", receiptImg: nil)
    @IBOutlet weak var income: UILabel!
    
    @IBOutlet weak var expenses: UILabel!
    
    @IBOutlet weak var total: UILabel!
    
    @IBOutlet weak var overview: UILabel!
    var tableData = [Transaction]() // the data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell =  tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TableViewCell
        if (cell == nil) {
            cell = TableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier)
        }
        
        // set the cell
        cell?.merchant?.text = tableData[indexPath.row].merchant
        cell?.category?.text = tableData[indexPath.row].category
        cell?.date?.text = String(tableData[indexPath.row].date)
        
        cell?.amount?.text = "CA$" + String(tableData[indexPath.row].amtSign)
        
        cell?.img.image = tableData[indexPath.row].icon
        

        return cell! // return  the cell to the table view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        //SharingFruitCollection.sharedFruitCollection.fruitCollection?.setCurrentIndex(to: indexPath.row)
        
        
        //print(SharingFruitCollection.sharedFruitCollection.fruitCollection?.currentFruit().fruitName)
        SharedTransactionCollection.sharedTransactionCollection.transactionList?.tappedTran = tableData[indexPath.row]
        performSegue(withIdentifier: segueID, sender: tableData[indexPath.row])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        overview.layer.zPosition = 1
        // Do any additional setup after loading the view.
        _ = SharedTransactionCollection()
        SharedTransactionCollection.sharedTransactionCollection.transactionList = TransactionList()
        if (firstload) {
            firstload = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
            do {
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let transaction = result as! Transaction
                    SharedTransactionCollection.sharedTransactionCollection.transactionList?.addTrans(transaction: transaction)
                }
            } catch {
                print("Fetch Failed")
            }
        }
        
        updateTotals()
        //SharedTransactionCollection.sharedTransactionCollection.transactionList?.loadTransactions()
        tableData = SharedTransactionCollection.sharedTransactionCollection.transactionList?.list ?? []
        
    }
    func updateTotals() {
        income.text = SharedTransactionCollection.sharedTransactionCollection.transactionList?.getIncome().description
        expenses.text = SharedTransactionCollection.sharedTransactionCollection.transactionList?.getExpenses().description
        total.text = SharedTransactionCollection.sharedTransactionCollection.transactionList?.getDiff().description
    }
    override func viewDidAppear(_ animated: Bool) {
        tableData = SharedTransactionCollection.sharedTransactionCollection.transactionList?.recentTrans(no: 7) ?? []
        updateTotals()
        tableView.reloadData()
    }
    
    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) {
        tableData = SharedTransactionCollection.sharedTransactionCollection.transactionList?.list ?? []
        updateTotals()
        tableView.reloadData()
        // Use data from the view controller which initiated the unwind segue
    }
    
    //use to reset
    func deleteAllData() {
        let objects: [NSManagedObject] = tableData// A list of objects
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // Get a reference to a managed object context
        let context = appDelegate.persistentContainer.viewContext

        // Delete multiple objects
        for object in objects {
            context.delete(object)
        }

        // Save the deletions to the persistent store
        do {
            try context.save()
        } catch {
            print("delete failed")
        }
    }

}

