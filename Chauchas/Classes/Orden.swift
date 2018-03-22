//
//  Orden.swift
//  Chauchas
//
//  Created by Alvaro Galia Valenzuela on 04-03-18.
//  Copyright © 2018 Alvaro Galia Valenzuela. All rights reserved.
//

import Foundation
class Orden {
    var _id : String = ""
    var sell : Bool = false
    var type : String = ""
    var amount : Int = 0
    var amountToHold : Int = 0
    var secondaryAmount : Int = 0
    var filled : Int = 0
    var closedAt : Int = 0
    var secondaryFilled : Int = 0
    var limitPrice : Int = 0
    var createdAt : Int = 0
    var activatedAt : Int = 0
    var isStop : Bool = false
    var status : String = ""
    var stopPriceUp : Int = 0
    var stopPriceDown : Int = 0
    var mainCurrencyCode : String = ""
    var secondaryCurrencyCode : String = ""
}
