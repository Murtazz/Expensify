//
//  SharedTransactionsList.swift
//  Expensify
//
//  Created by Murtaza Khalid on 2023-04-18.
//

import Foundation
class SharedTransactionCollection {
    
    static let sharedTransactionCollection = SharedTransactionCollection()
    var transactionList : TransactionList?
 
    // method to restore the fruit collection from a file
    func loadTransList() {
        //transactionList?.loadTransactions()
    }

    // method to save the fruit collection to a file
    func saveTransList() {
        //fruitCollection?.reset()
        //transactionList?.saveTransactions()
    }
     
}
