//
//  Transaction.swift
//  khal3470_finalProject
//
//  Created by Murtaza Khalid on 2023-04-15.
//

import Foundation
import SwiftUIFontIcon
import UIKit
import SwiftUI
import CoreData

@objc (Transaction)
class Transaction: NSManagedObject {
    @NSManaged var id: NSNumber!
    @NSManaged var date: String!
    @NSManaged var merchant: String!
    @NSManaged var amount: NSNumber!
    @NSManaged var type: String!
    @NSManaged var categoryid: NSNumber!
    @NSManaged var category: String!
    @NSManaged var receiptImg: Data!
    @NSManaged var dateId: Date!
    @NSManaged var deleteDate: Date?
    
    var icon: UIImage {
        if let category = Category.categories.first(where: {$0.id as Int == categoryid as! Int}) {
            return category.icon
        }
        return UIImage(named: "other.png")!
    }
    var amtSign: Double {
        return Double(type == "debit" ? Double(truncating: amount) : -(Double(truncating: amount)))
    }
    
}
/*
class Transaction: Codable, Comparable {
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.dateId < rhs.dateId
    }
    
    let id: Int
    let date: String
    var merchant: String
    let amount: Double
    let type: String
    var categoryId: Int
    var category: String
    var receiptImg: UIImage?
    var dateId: Date //to sort maybe
    var formattedDate: Date {
        date.dateFormat()
    }
    var month: String {
        formattedDate.formatted(.dateTime.year().month(.wide))
    }
    var icon: UIImage {
        if let category = Category.categories.first(where: {$0.id == categoryId}) {
            return category.icon
        }
        return UIImage(named: "other.png")!
    }
    var amtSign: Double {
        return Double(type == "debit" ? amount : -amount)
    }
    public enum CodingKeys: String, CodingKey {
        case id
        case date
        case merchant
        case amount
        case type
        case categoryid
        case category
        case receiptImg
        case dateid
    }
    init(id: Int, date: String, merchant: String, amount: Double, type: String, categoryid: Int, category: String, receiptImg: UIImage?, dateid: Date) {
        self.id = id
        self.date = date
        self.merchant = merchant
        self.amount = amount
        self.type = type
        self.categoryId = categoryid
        self.category = category
        self.dateId = dateid
        if receiptImg != nil {
            self.receiptImg = receiptImg
        } else {
            self.receiptImg = UIImage(named: "other.png")
        }
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
                    
        let idData = try container.decode(Data.self, forKey: .id)
        self.id = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSNumber.self, from: idData) as? Int ?? 0
        
        // decoding the image property of the object
        let imageData = try container.decode(Data.self, forKey: .receiptImg)
        self.receiptImg = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIImage.self, from: imageData)
        
        // decoding the name property
        let dateData = try container.decode(Data.self, forKey: .date)
        self.date = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSString.self, from: dateData) as? String ?? ""
        //self.fruitName = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(nameData) as? String ?? "no fruit name"
        
        let merchData = try container.decode(Data.self, forKey: .merchant)
        self.merchant = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSString.self, from: merchData) as? String ?? ""
        
        let amtData = try container.decode(Data.self, forKey: .date)
        self.amount = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSNumber.self, from: amtData) as? Double ?? 0
        
        let typeData = try container.decode(Data.self, forKey: .type)
        self.type = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSString.self, from: typeData) as? String ?? ""
        
        let cateData = try container.decode(Data.self, forKey: .category)
        self.category = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSString.self, from: cateData) as? String ?? ""
        
        let catidData = try container.decode(Data.self, forKey: .categoryid)
        self.categoryId = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSNumber.self, from: catidData) as? Int ?? 0
        
        let dateidData = try container.decode(Data.self, forKey: .dateid)
        self.dateId = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSDate.self, from: dateidData) as? Date ?? Date()
        
    } // decoder
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let idData = try NSKeyedArchiver.archivedData(withRootObject: id, requiringSecureCoding: true)
        try container.encode(idData, forKey: .categoryid)
        
        let imageData = try NSKeyedArchiver.archivedData(withRootObject: receiptImg ?? UIImage(named: "other.png")!, requiringSecureCoding: true)
        try container.encode(imageData, forKey: .receiptImg)
        
        let dateData = try NSKeyedArchiver.archivedData(withRootObject: date, requiringSecureCoding: true)
        try container.encode(dateData, forKey: .date)
        
        let merchData = try NSKeyedArchiver.archivedData(withRootObject: merchant, requiringSecureCoding: true)
        try container.encode(merchData, forKey: .merchant)
        
        let amtData = try NSKeyedArchiver.archivedData(withRootObject: amount, requiringSecureCoding: true)
        try container.encode(amtData, forKey: .amount)
        
        let typeData = try NSKeyedArchiver.archivedData(withRootObject: type, requiringSecureCoding: true)
        try container.encode(typeData, forKey: .type)
        
        let cateData = try NSKeyedArchiver.archivedData(withRootObject: category, requiringSecureCoding: true)
        try container.encode(cateData, forKey: .category)
        
        let cateidData = try NSKeyedArchiver.archivedData(withRootObject: categoryId, requiringSecureCoding: true)
        try container.encode(cateidData, forKey: .categoryid)
        
        let dateidData = try NSKeyedArchiver.archivedData(withRootObject: dateId, requiringSecureCoding: true)
        try container.encode(dateidData, forKey: .dateid)
        
    }
}
*/
struct Category {
    let id: Int
    let name: String
    let icon: UIImage
}

extension Category {
    static let autoAndTransport = Category(id: 1, name: "Auto & Transport", icon: UIImage(named: "bus.png")!)
    static let billsAndUtilities = Category(id: 2, name: "Bills & Utilities", icon: UIImage(named: "bills.png")!)
    static let entertainment = Category(id: 3, name: "Entertainment", icon: UIImage(named: "film.png")!)
    static let feesAndCharges = Category(id: 4, name: "Fees & Charges", icon: UIImage(named: "fees.png")!)
    static let foodAndDining = Category(id: 5, name: "Food & Dining", icon: UIImage(named: "food.png")!)
    static let home = Category(id: 6, name: "Home", icon: UIImage(named: "home.png")!)
    static let income = Category(id: 7, name: "Income", icon: UIImage(named: "income.png")!)
    static let shopping = Category(id: 8, name: "Shopping", icon: UIImage(named: "shopping.png")!)
    static let transfer = Category(id: 9, name: "Transfer", icon: UIImage(named: "transfer.png")!)
}
                                
extension Category {
    static let categories: [Category] = [
        .autoAndTransport,
        .billsAndUtilities,
        .entertainment,
        .feesAndCharges,
        .foodAndDining,
        .home,
        .income,
        .shopping,
        .transfer
    ]
}

