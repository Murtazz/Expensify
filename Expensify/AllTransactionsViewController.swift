//
//  AllTransactionsViewController.swift
//  Expensify
//
//  Created by Murtaza Khalid on 2023-04-19.
//

import UIKit
import CoreData

class  TableViewCell2: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var merchant: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var amount: UILabel!
}


class AllTransactionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "reuseIdentifier2"
    let segueID = "showDetail"
    //var transactionPD = Transaction(date: "01/24/2022", merchant: "Apple", amount: 11.49, type: "debit", categoryid: 8, category: "Shopping", receiptImg: nil)

    var tableData = [Transaction]() // the data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell =  tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TableViewCell2
        if (cell == nil) {
            cell = TableViewCell2(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier)
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
    
    // Implement the table vew delegate function for deleting and inserting rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        if editingStyle == .delete {
            //Delete the row from the data source and from the table view
            
            context.delete(tableData[indexPath.row] as NSManagedObject)
            self.tableData.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        do {
            try context.save()
        } catch {
            print("failed save")
        }
        
        tableView.reloadData() // refresh the table view (important when we insert a row)
        SharedTransactionCollection.sharedTransactionCollection.transactionList?.updateTable(with: tableData)
        
    } // editingStyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableData = SharedTransactionCollection.sharedTransactionCollection.transactionList?.list ?? []
        
    }
    override func viewDidAppear(_ animated: Bool) {
        tableData = SharedTransactionCollection.sharedTransactionCollection.transactionList?.list ?? []
        tableView.reloadData()
    }
    
    


}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


