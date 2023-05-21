//
//  DetailViewController.swift
//  Expensify
//
//  Created by Murtaza Khalid on 2023-04-21.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var merchName: UILabel!
    
    @IBOutlet weak var amount: UILabel!
    
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var imageview: UIImageView!
    
    func updateView() {
        let transaction = SharedTransactionCollection.sharedTransactionCollection.transactionList?.tappedTran
        merchName.text = transaction?.merchant
        amount.text = "CA$" + (transaction?.amtSign.description ?? "")
        category.text = transaction?.category
        date.text = transaction?.date
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        updateView()
    }
    @IBAction func unwindToDetail(_ unwindSegue: UIStoryboardSegue) {
        
        //let sourceViewController = unwindSegue.source
        //if let editViewController = unwindSegue.source as? EditViewController {
            //let transaction = editViewController.getUpdatedTransaction() <-- implement this
            //SharedTransactionCollection.sharedTransactionCollection.transactionList?.updateTransaction(with: transaction)
            //tableData.append(fruit)
            //SharingFruitCollection.sharedFruitCollection.fruitCollection?.addFruit(fruit: fruit)
        //}
        // Use data from the view controller which initiated the unwind segue
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
