//
//  TransactionList.swift
//  Expensify
//
//  Created by Murtaza Khalid on 2023-04-18.
//

import Foundation
typealias TransactionDict = [String: [Transaction]]
struct TransactionList {
    var tappedTran: Transaction?
    var list = [Transaction]() // a collection is an array of fruits
    var current: Int = 0 // the current fruit in the collection (to be shown in the scene)
    var fileURL : URL {
        let documentDirectoryURL = try!
        FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return documentDirectoryURL.appendingPathComponent ("Codable.file" )
    }
    
    init(){
        
    }
    mutating func addTrans(transaction: Transaction) {
        self.list.insert(transaction, at: 0)
        list = sortByDate()
        current += 1
    }
    
    func recentTrans(no: Int) -> [Transaction] {
        let sorted = sortByDate()
        var recent: [Transaction] = []
        if sorted.count < no {
            
            return sorted
        }
            var count = 0
        for i in sorted {
            recent.append(i)
            count += 1
            if count == no {
                return recent
            }
        }
        return recent
    }
        
    mutating func updateTable(with: [Transaction]) {
        self.list = with
        self.list = sortByDate()
    }
    
    mutating func updateTransaction(with: Transaction) {
        var count = 0
        for i in list {
            if i.id == with.id {
                list.remove(at: count)
                list.append(with)
                list = sortByDate()
                return
            }
            count += 1
        }
    }
    
    func sortByDate() -> [Transaction] {
        var sortedList = list
        sortedList = sortedList.sorted(by: { $0.dateId! > $1.dateId! })
        return sortedList
    }
    func getIncome() -> Double {
        var tot = 0.0
        for i in list {
            if i.type == "debit" {
                tot += i.amount as! Double
            }
        }
        return tot
    }
    
    func getExpenses() -> Double {
        var tot = 0.0
        for i in list {
            if i.type == "credit" {
                tot += i.amount as! Double
            }
        }
        return tot
    }
    
    func getDiff() -> Double {
        let tot = getIncome() - getExpenses()
        return tot
    }
         /*
    func saveTransactions() { // encoder
        
        let jsonEncoder = JSONEncoder()
        var jsonData = Data()
        do {
            jsonData = try jsonEncoder.encode(list)
        }
        catch {
            print("cannot encode")
        }
        do {
            try jsonData.write(to: fileURL, options: [])
        } catch {
            print ("cannot write")
        }
    }
    
    mutating func loadTransactions() { // decoder
        
        let jsonDecoder = JSONDecoder()
        
        var data = Data()
        do {
            data = try Data(contentsOf: fileURL)
        } catch {
            print ("cannot read the archive")
        }
        do {
            list = try jsonDecoder.decode([Transaction].self, from: data)
            list = sortByDate()
        } catch {
            print("cannot decode transactions from the archive")
        }
        
    }
          
    func groupTransactionsByMonth () -> TransactionDict {
        guard !list.isEmpty else { return [:] }
        let monthlyTransactions = TransactionDict(grouping: list) {
            $0.month
        }
        return monthlyTransactions
          
    }
          */
}

