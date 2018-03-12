//
//  ViewController.swift
//  Chauchas
//
//  Created by Alvaro Galia Valenzuela on 01-03-18.
//  Copyright © 2018 Alvaro Galia Valenzuela. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var chauchasContables: UILabel!
    @IBOutlet weak var chauchasDisponibles: UILabel!
    
    @IBOutlet weak var saldoContable: UILabel!
    @IBOutlet weak var saldoDisponible: UILabel!
    
    @IBOutlet weak var pickerChauchaCompra: UIPickerView!
    @IBOutlet weak var pickerChauchaVenta: UIPickerView!
    
    @IBOutlet weak var pickerGanancia: UIPickerView!
    @IBOutlet weak var pickerGananciaMaxima: UIPickerView!
    
    @IBOutlet weak var pickerUltimaTransaccionValor: UIPickerView!
    
    
    @IBAction func btnComprarTodo(_ sender: Any) {
        let cantChauchasAComprar : Double = Double(saldoPesos) / Double(self.valorActualVenta)
        
        let alert = UIAlertController(title: "Confirmación", message: "Estás seguro de comprar \(cantChauchasAComprar.toString(Decimales: decimales)) Chauchas a $\(self.valorActualVenta)?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Confirmar", style: UIAlertActionStyle.default, handler: { action in
            
            self.compraChauchas(monto: cantChauchasAComprar, valorChaucha: self.valorActualVenta)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func btnVenderTodo(_ sender: Any) {
        let alert = UIAlertController(title: "Confirmación", message: "Estás seguro de vender \(self.cantChauchasCompradas.toString(Decimales: decimales)) Chauchas a $\(self.valorActualCompra)?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Confirmar", style: UIAlertActionStyle.default, handler: { action in
            self.vendeChauchas(monto: self.cantChauchasCompradas, valorChaucha: self.valorActualCompra)
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnVenderMaximo(_ sender: Any) {
        let alert = UIAlertController(title: "Confirmación", message: "Estás seguro de vender \(self.cantChauchasCompradas.toString(Decimales: decimales)) Chauchas a $\(self.valorActualVenta)?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Confirmar", style: UIAlertActionStyle.default, handler: { action in
            self.vendeChauchas(monto: self.cantChauchasCompradas, valorChaucha: self.valorActualVenta)
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnComprarMinimo(_ sender: Any) {
        let cantChauchasAComprar : Double = Double(saldoPesos) / Double(self.valorActualCompra)
        
        let alert = UIAlertController(title: "Confirmación", message: "Estás seguro de comprar \(cantChauchasAComprar.toString(Decimales: decimales)) Chauchas a $\(self.valorActualCompra)?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Confirmar", style: UIAlertActionStyle.default, handler: { action in
            self.compraChauchas(monto: cantChauchasAComprar, valorChaucha: self.valorActualCompra)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    var timer = Timer()
    
    var valorActualCompra = 0
    var valorActualVenta = 0
    
    var cantChauchasCompradas = 0.0
    var cantChauchasContables = 0.0
    
    var precioCompra = 0
    var valorCompra = 0
    var saldoPesos = 0
    var ganancia = 0
    var decimales = 0
    let mercado = "CHACLP"
    
    let mailUp: SystemSoundID = 1004
    let mailDown: SystemSoundID = 1003
    let tick : SystemSoundID = 1100
    let tock : SystemSoundID = 1104
    let montoSube : SystemSoundID =  1115
    let montoBaja : SystemSoundID =  1116
    
    var pickerViewClass = SaldoUIPickerView()
    var pickerViewClassChauchaCompra = SaldoUIPickerView()
    var pickerViewClassChauchaVenta = SaldoUIPickerView()
    var pickerGananciaClass = SaldoUIPickerView()
    var pickerGananciaMaximaClass = SaldoUIPickerView()
    var pickerClassUltimaTransaccion = SaldoUIPickerView()
    
    var interval = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        obtieneValores()
        
        if(getWiFiSsid() != nil && (UIDevice.current.batteryState == .charging || UIDevice.current.batteryState == .full)){
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.obtieneValores), userInfo: nil, repeats: true)
        }else{
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.obtieneValores), userInfo: nil, repeats: true)
        }
        
        pickerChauchaCompra.delegate = pickerViewClassChauchaCompra
        pickerChauchaCompra.dataSource = pickerViewClassChauchaCompra
        
        pickerChauchaVenta.delegate = pickerViewClassChauchaVenta
        pickerChauchaVenta.dataSource = pickerViewClassChauchaVenta
        
        pickerGanancia.delegate = pickerGananciaClass
        pickerGanancia.dataSource = pickerGananciaClass
        
        pickerChauchaCompra.isUserInteractionEnabled = false
        pickerChauchaVenta.isUserInteractionEnabled = false
        
        pickerGanancia.isUserInteractionEnabled = false
        pickerGananciaClass.isRojoVerde = true
        
        pickerGananciaMaximaClass.isRojoVerde = true
        pickerGananciaMaxima.isUserInteractionEnabled = false
        pickerGananciaMaxima.delegate = pickerGananciaMaximaClass
        pickerGananciaMaxima.dataSource = pickerGananciaMaximaClass
        
        pickerUltimaTransaccionValor.isUserInteractionEnabled = false
        pickerUltimaTransaccionValor.delegate = pickerClassUltimaTransaccion
        pickerUltimaTransaccionValor.dataSource = pickerClassUltimaTransaccion
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func getMultiplicador(withAmount: Int) -> Int {
        var amount = withAmount
        if(amount < 0){
            amount = amount * -1
        }
        let multiplicador = (((amount / 1000)) * 1000)
        return multiplicador
    }
    func getSeleccionado(withAmount: Int) -> Int {
        var seleccionado = (Int(withAmount / 1000) * 1000) - withAmount
        if(seleccionado < 0){
            seleccionado = seleccionado * -1
        }
        return seleccionado
    }
    
    @objc func obtieneValores(){
        
        let body = ["query": "{ orderBook: marketOrderBook(marketCode: \"\(mercado)\", limit: 1) { buy { limitPrice } sell { limitPrice } spread } market(code: \"\(mercado)\") { mainCurrency { ...getMarketCurrency } secondaryCurrency { ...getMarketCurrency } lastTrade{ price } } } fragment getMarketCurrency on Currency { code units symbol wallet { balance availableBalance } } "]
        
        let request = getRequest(body: body)
        
        let task = URLSession.shared.dataTask(with: request) { (datos, response, error) in
            if(datos != nil){
                DispatchQueue.main.async {
                    let json = try? JSONSerialization.jsonObject(with: datos!) as! [String: Any]
                    if let data = json!["data"] as? [String: Any]{
                        if let market = data["market"] as? [String : Any]{
                            if let mainCurrency = market["mainCurrency"] as? [String : Any]{
                                //let code = mainCurrency["code"] as? String ?? ""
                                let units = mainCurrency["units"] as? Int ?? 0
                                let symbol = mainCurrency["symbol"] as? String ?? ""
                                if let wallet = mainCurrency["wallet"] as? [String : Any]{
                                    let balance = wallet["balance"] as? Int ?? 0
                                    let availableBalance = wallet["availableBalance"] as? Int ?? 0
                                    self.decimales = units
                                    let exponencial = pow(10, units)
                                    self.chauchasContables.text = "\(symbol)\((Double(balance) / Double(truncating: exponencial as NSNumber)).toString(Decimales: units))"
                                    self.cantChauchasContables = (Double(balance) / Double(truncating: exponencial as NSNumber))
                                    
                                    self.chauchasDisponibles.text = "\(symbol)\((Double(availableBalance) / Double(truncating: exponencial as NSNumber)).toString(Decimales: units))"
                                    self.cantChauchasCompradas = (Double(availableBalance) / Double(truncating: exponencial as NSNumber))
                                }
                            }
                            if let secondaryCurrency = market["secondaryCurrency"] as? [String : Any]{
                                let code = secondaryCurrency["code"] as? String ?? ""
                                //let units = secondaryCurrency["units"] as? String ?? ""
                                let symbol = secondaryCurrency["symbol"] as? String ?? ""
                                if let wallet = secondaryCurrency["wallet"] as? [String : Any]{
                                    let balance = wallet["balance"] as? Int ?? 0
                                    let availableBalance = wallet["availableBalance"] as? Int ?? 0
                                    self.saldoContable.text = "\(code)\(symbol) \(balance)"
                                    self.saldoDisponible.text = "\(code)\(symbol) \(availableBalance)"
                                    self.saldoPesos = availableBalance
                                }
                            }
                            
                            if let lastTrade = market["lastTrade"] as? [String : Any]{
                                let price = lastTrade["price"] as? Int ?? 0
                                
                                self.pickerClassUltimaTransaccion.multiplicador = self.getMultiplicador(withAmount: price)
                                self.pickerUltimaTransaccionValor.selectRow(self.getSeleccionado(withAmount: price), inComponent: 0, animated: true)
                                
                            }
                        }
                        if let orderBook = data["orderBook"] as? [String : Any]{
                            if let buy = orderBook["buy"] as? [[String : Any]]{
                                let limitPrice = buy[0]["limitPrice"] as? Int ?? 0
                                self.valorActualCompra = limitPrice
                                
                                self.pickerViewClassChauchaCompra.multiplicador = self.getMultiplicador(withAmount: limitPrice)
                                self.pickerChauchaCompra.selectRow(self.getSeleccionado(withAmount: limitPrice), inComponent: 0, animated: true)
                                
                            }
                            if let sell = orderBook["sell"] as? [[String : Any]]{
                                let limitPrice = sell[0]["limitPrice"] as? Int ?? 0
                                self.valorActualVenta = limitPrice
                                
                                self.pickerViewClassChauchaVenta.multiplicador = self.getMultiplicador(withAmount: limitPrice)
                                self.pickerChauchaVenta.selectRow(self.getSeleccionado(withAmount: limitPrice), inComponent: 0, animated: true)
                            }
                        }
                        
                        let gananciaMaxima = Int(Double(self.valorActualVenta) * self.cantChauchasContables)
                        let gananciaMinima = Int(Double(self.valorActualCompra) * self.cantChauchasContables)
                        
                        self.pickerGananciaClass.multiplicador = self.getMultiplicador(withAmount: gananciaMinima)
                        self.pickerGanancia.selectRow(self.getSeleccionado(withAmount: gananciaMinima), inComponent: 0, animated: true)
                        self.pickerGananciaMaximaClass.multiplicador = self.getMultiplicador(withAmount: gananciaMaxima)
                        self.pickerGananciaMaxima.selectRow(self.getSeleccionado(withAmount: gananciaMaxima), inComponent: 0, animated: true)
                    }
                }
            }
        }
        
        task.resume()
        
    }
    
    
    func compraChauchas(monto : Double, valorChaucha : Int){
        let montoInt : Int = Int(monto * 100000000.0)
        let body = ["query": "mutation{ placeLimitOrder(marketCode:\"\(mercado)\", amount : \(montoInt), limitPrice: \(valorChaucha), sell: false){ _id __typename }}"]
        
        let request = getRequest(body: body)
        
        let task = URLSession.shared.dataTask(with: request) { (datos, response, error) in
            DispatchQueue.main.async {
                
            }
            
        }
        
        task.resume()
    }
    func vendeChauchas(monto : Double, valorChaucha : Int){
        let montoInt : Int = Int(monto * 100000000.0)
        let body = ["query": "mutation{ placeLimitOrder(marketCode:\"\(mercado)\", amount : \(montoInt), limitPrice: \(valorChaucha), sell: true){ _id __typename }}"]
        
        let request = getRequest(body: body)
        let task = URLSession.shared.dataTask(with: request) { (datos, response, error) in
            
            DispatchQueue.main.async {
            }
            
        }
        
        task.resume()
    }
}

