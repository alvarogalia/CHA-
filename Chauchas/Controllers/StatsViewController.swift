//
//  StatsViewController.swift
//  Chauchas
//
//  Created by Alvaro Galia Valenzuela on 12-03-18.
//  Copyright © 2018 Alvaro Galia Valenzuela. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {

    @IBOutlet weak var tableViewOrderBook: UITableView!
    @IBOutlet weak var tableViewVentas: UITableView!
    
    var mercado = ""
    
    var tableViewClassVentas = OrderBookTableViewController()
    var tableViewClassOrderBook = OrderBookTableViewController()
    
    var timer = Timer()
    var standard = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()

        if let market = standard.object(forKey: "mercado") as? String {
            mercado = market
        }
        
        tableViewVentas.dataSource = tableViewClassVentas
        tableViewVentas.delegate = tableViewClassVentas
        
        tableViewOrderBook.dataSource = tableViewClassOrderBook
        tableViewOrderBook.delegate = tableViewClassOrderBook
        
    }

    override func viewWillAppear(_ animated: Bool) {
        obtieneListados()
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.obtieneListados), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var arrBuy = [OrderBook]()
    var arrSell = [OrderBook]()
    
    @objc func obtieneListados(){
        self.arrSell.removeAll()
        self.arrBuy.removeAll()
        self.tableViewVentas.reloadData()
        self.tableViewOrderBook.reloadData()
        
        let registros:Int = Int(self.view.frame.height) / 17
        
        let body = ["query" : "{ orderBook: marketOrderBook(marketCode: \"\(mercado)\", limit: \(registros)) { buy { ...order } sell { ...order } mid spread } } fragment order on MarketBookOrder { amount limitPrice accumulated accumulatedPrice }"]
        let request = getRequest(body: body)
        
        let task = URLSession.shared.dataTask(with: request) { (datos, response, error) in
            if(datos != nil){
                let json = try? JSONSerialization.jsonObject(with: datos!) as! [String: Any]
                if let data = json!["data"] as? [String: Any]{
                    if let orderBook = data["orderBook"] as? [String : Any]{
                        var accumulated = 0
                        if let buy = orderBook["buy"] as? [[String: Any]]{
                            var amount = 0
                            for element in buy{
                                let orden = OrderBook()
                                orden.amount = element["amount"] as? Int ?? 0
                                orden.limitPrice = element["limitPrice"] as? Int ?? 0
                                orden.accumulated = element["accumulated"] as? Int ?? 0
                                if(orden.amount > amount){
                                    amount = orden.amount
                                }
                                orden.accumulatedPrice = element["accumulatedPrice"] as? Int ?? 0
                                self.arrBuy.append(orden)
                                accumulated = element["accumulated"] as? Int ?? 0
                            }
                            
                            self.tableViewClassOrderBook.maxAmount = amount
                        }
                        if let sell = orderBook["sell"] as? [[String: Any]]{
                            var amount = 0
                            for element in sell{
                                let orden = OrderBook()
                                orden.amount = element["amount"] as? Int ?? 0
                                orden.limitPrice = element["limitPrice"] as? Int ?? 0
                                orden.accumulated = element["accumulated"] as? Int ?? 0
                                if(orden.amount > amount){
                                    amount = orden.amount
                                }
                                orden.accumulatedPrice = element["accumulatedPrice"] as? Int ?? 0
                                self.arrSell.append(orden)
                                if(accumulated < element["accumulated"] as? Int ?? 0){
                                    accumulated = element["accumulated"] as? Int ?? 0
                                }
                            }
                            self.tableViewClassVentas.maxAmount = amount
                            if(self.tableViewClassVentas.maxAmount > self.tableViewClassOrderBook.maxAmount){
                                self.tableViewClassOrderBook.maxAmount = self.tableViewClassVentas.maxAmount
                            }else{
                                self.tableViewClassVentas.maxAmount = self.tableViewClassOrderBook.maxAmount
                            }
                        }
                        self.tableViewClassVentas.maxAccumulated = accumulated
                        self.tableViewClassOrderBook.maxAccumulated = accumulated
                        
                        self.tableViewClassOrderBook.mainCurrencyUnits = self.standard.integer(forKey: "mainCurrencyUnits")
                        self.tableViewClassVentas.mainCurrencyUnits = self.standard.integer(forKey: "mainCurrencyUnits")
                    }
                    
                    DispatchQueue.main.async {
                        self.tableViewClassVentas.items = self.arrSell
                        self.tableViewClassOrderBook.items = self.arrBuy
                        
                        self.tableViewClassVentas.nombreCelda = "celdaOrderBookVentas"
                        self.tableViewClassOrderBook.nombreCelda = "celdaOrderBookCompras"
                        
                        
                        self.tableViewVentas.reloadData()
                        self.tableViewOrderBook.reloadData()
                    }
                }
            }
        }
        
        task.resume()
    }

    
}
