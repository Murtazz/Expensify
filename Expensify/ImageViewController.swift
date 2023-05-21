//
//  ImageViewController.swift
//  Expensify
//
//  Created by Murtaza Khalid on 2023-04-21.
//

import UIKit

class ImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = SharedTransactionCollection.sharedTransactionCollection.transactionList?.tappedTran?.receiptImg ?? nil
        //let defaultimg = UIImage(named: "other.png")?.pngData()
        if data != nil {
            imageView.image = UIImage(data: (SharedTransactionCollection.sharedTransactionCollection.transactionList?.tappedTran?.receiptImg)!)
        } else {
            imageView.image = UIImage(named: "other.png")
        }
        
        print(SharedTransactionCollection.sharedTransactionCollection.transactionList?.tappedTran?.receiptImg == nil)
        // Do any additional setup after loading the view.
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
