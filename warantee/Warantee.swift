//
//  Warantee.swift
//  warantee
//
//  Created by Humaid Khan on 13/12/2019.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation
// warantee class
class Warantee {
    // private variables
    private var _id:Int
    private var _uid: String
    private var _date: String
    private var _amount: Float
    private var _category: Int
    private var _warantyPeriod: Int
    private var _sellerName: String
    private var _sellerPhone: String
    private var _sellerEmail: String
    private var _location: String
    private var _createdAt: String
    private var _updatedAt: String
    
    //getters and setters
    var id: Int{
        set(id){_id = id}
        get{return _id}
    }
    var uid: String{
        set(uid){_uid = uid}
        get{return _uid}
    }
    var date: String{
        set(date){_date = date}
        get{return _date}
    }
    var amount: Float{
        set(amount){_amount = amount}
        get{return _amount}
    }
    var category: Int{
        set(category){_category = category}
        get{return _category}
    }
    var warantyPeriod: Int{
        set(warantyPeriod){_warantyPeriod = warantyPeriod}
        get{return _warantyPeriod}
    }
    var sellerName: String{
        set(sellerName){_sellerName = sellerName}
        get{return _sellerName}
    }
    var sellerPhone: String{
        set(sellerPhone){_sellerPhone = sellerPhone}
        get{return _sellerPhone}
    }
    var sellerEmail: String{
        set(sellerEmail){_sellerEmail = sellerEmail}
        get{return _sellerEmail}
    }
    var location: String{
        set(location){_location = location}
        get{return _location}
    }
    var createdAt: String{
        set(createdAt){_createdAt = createdAt}
        get{return _createdAt}
    }
    var updatedAt: String{
        set(updatedAt){_updatedAt = updatedAt}
        get{return _updatedAt}
    }
    
    //constructors
    internal init(id: Int, uid: String, date: String, amount: Float, category: Int, warantyPeriod: Int, sellerName: String, sellerPhone: String, sellerEmail: String, location: String, createdAt: String, updatedAt: String) {
        self._id = id
        self._uid = uid
        self._date = date
        self._amount = amount
        self._category = category
        self._warantyPeriod = warantyPeriod
        self._sellerName = sellerName
        self._sellerPhone = sellerPhone
        self._sellerEmail = sellerEmail
        self._location = location
        self._createdAt = createdAt
        self._updatedAt = updatedAt
    }
    
       
    
}
