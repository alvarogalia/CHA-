//
//  ViewController.swift
//  Chauchas
//
//  Created by Alvaro Galia Valenzuela on 01-03-18.
//  Copyright © 2018 Alvaro Galia Valenzuela. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds
import Firebase

class ViewController: UIViewController, GADBannerViewDelegate{
    
    var bannerView: GADBannerView!
    
    @IBOutlet weak var chauchasContables: UILabel!
    @IBOutlet weak var chauchasDisponibles: UILabel!
    
    @IBOutlet weak var saldoContable: UILabel!
    @IBOutlet weak var saldoDisponible: UILabel!
    
    @IBOutlet weak var pickerChauchaCompra: UIPickerView!
    @IBOutlet weak var pickerChauchaVenta: UIPickerView!
    
    @IBOutlet weak var pickerGanancia: UIPickerView!
    @IBOutlet weak var pickerGananciaMaxima: UIPickerView!
    
    @IBOutlet weak var viewBanner: UIView!
    @IBOutlet weak var pickerUltimaTransaccionValor: UIPickerView!
    
    
    @IBAction func btnComprarTodo(_ sender: Any) {
        let cantChauchasAComprar : Double = Double(saldoPesos) / Double(self.valorActualVenta)
        
        let valorFinal = Double(valorActualVenta) / Double(truncating: pow(10, secondaryCurrencyUnits) as NSNumber)
        let precio = "\(secondaryCurrencySymbol)\(valorFinal.toString(Decimales: secondaryCurrencyUnits))"
        
        let alert = UIAlertController(title: "Confirmación", message: "Estás seguro de comprar \(mainCurrencySymbol)\(cantChauchasAComprar.toStringTrail(Decimales: self.mainCurrencyUnits)) a \(precio)?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Confirmar", style: UIAlertActionStyle.default, handler: { action in
            self.compraChauchas(monto: cantChauchasAComprar, valorChaucha: self.valorActualVenta)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func btnVenderTodo(_ sender: Any) {
        let valorFinal = Double(valorActualCompra) / Double(truncating: pow(10, secondaryCurrencyUnits) as NSNumber)
        let precio = "\(secondaryCurrencySymbol)\(valorFinal.toString(Decimales: secondaryCurrencyUnits))"
        let alert = UIAlertController(title: "Confirmación", message: "Estás seguro de comprar \(mainCurrencySymbol)\(cantChauchasCompradas.toStringTrail(Decimales: self.mainCurrencyUnits)) a \(precio)?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Confirmar", style: UIAlertActionStyle.default, handler: { action in
            self.vendeChauchas(monto: self.cantChauchasCompradas, valorChaucha: self.valorActualCompra)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnVenderMaximo(_ sender: Any) {
        let valorFinal = Double(valorActualVenta) / Double(truncating: pow(10, secondaryCurrencyUnits) as NSNumber)
        let precio = "\(secondaryCurrencySymbol)\(valorFinal.toString(Decimales: secondaryCurrencyUnits))"
        let alert = UIAlertController(title: "Confirmación", message: "Estás seguro de comprar \(mainCurrencySymbol)\(cantChauchasCompradas.toStringTrail(Decimales: self.mainCurrencyUnits)) a \(precio)?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Confirmar", style: UIAlertActionStyle.default, handler: { action in
            self.vendeChauchas(monto: self.cantChauchasCompradas, valorChaucha: self.valorActualVenta)
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnComprarMinimo(_ sender: Any) {
        let cantChauchasAComprar : Double = Double(saldoPesos) / Double(self.valorActualCompra)
        let valorFinal = Double(valorActualCompra) / Double(truncating: pow(10, secondaryCurrencyUnits) as NSNumber)
        let precio = "\(secondaryCurrencySymbol)\(valorFinal.toString(Decimales: secondaryCurrencyUnits))"
        let alert = UIAlertController(title: "Confirmación", message: "Estás seguro de comprar \(mainCurrencySymbol)\(cantChauchasAComprar.toStringTrail(Decimales: self.mainCurrencyUnits)) a \(precio)?", preferredStyle: UIAlertControllerStyle.alert)
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
    var saldoPesos = 0.0
    var saldoPesosContable = 0.0
    var mercado = ""
    
    var comisionMaker = 0.0
    var comisionTaker = 0.0
    
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
    
    var gananciaMaxima = 0
    var gananciaMinima = 0
    
    var secondaryCurrencyUnits = 0
    var mainCurrencyUnits = 0
    
    var mainCurrencySymbol = ""
    var secondaryCurrencySymbol = ""
    
    var firstTime = true
    
    var standard = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        obtieneValores()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.obtieneValores), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if let market = standard.object(forKey: "mercado") as? String {
            mercado = market
        }
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-6479995755181265/7268470104"
        bannerView.rootViewController = self
        viewBanner.addBannerViewToView(bannerView: bannerView)
        bannerView.load(GADRequest())
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
        
        let body = ["query": "{ me{marketFees(marketCode:\"\(mercado)\"){maker taker}} orderBook: marketOrderBook(marketCode: \"\(mercado)\", limit: 1) { buy { limitPrice } sell { limitPrice } spread } market(code: \"\(mercado)\") { mainCurrency { ...getMarketCurrency } secondaryCurrency { ...getMarketCurrency } lastTrade{ price } } } fragment getMarketCurrency on Currency { units symbol wallet { balance availableBalance } } "]
        
        let request = getRequest(body: body)
        
        let task = URLSession.shared.dataTask(with: request) { (datos, response, error) in
            if(datos != nil){
                DispatchQueue.main.async {
                    let json = try? JSONSerialization.jsonObject(with: datos!) as! [String: Any]
                    if let data = json!["data"] as? [String: Any]{
                        if let me = data["me"] as? [String : Any]{
                            if let marketFees = me["marketFees"] as? [String : Any]{
                                let maker = marketFees["maker"] as? Double ?? 0.0
                                let taker = marketFees["taker"] as? Double ?? 0.0
                                self.comisionMaker = maker
                                self.comisionTaker = taker
                            }
                        }
                        if let market = data["market"] as? [String : Any]{
                            if let mainCurrency = market["mainCurrency"] as? [String : Any]{
                                //let code = mainCurrency["code"] as? String ?? ""
                                self.mainCurrencyUnits = mainCurrency["units"] as? Int ?? 0
                                self.mainCurrencySymbol = mainCurrency["symbol"] as? String ?? ""
                                
                                self.standard.set(self.mainCurrencyUnits, forKey: "mainCurrencyUnits")
                                self.standard.set(self.mainCurrencySymbol, forKey: "mainCurrencySymbol")
                                
                                if let wallet = mainCurrency["wallet"] as? [String : Any]{
                                    let balance = wallet["balance"] as? Int ?? 0
                                    let availableBalance = wallet["availableBalance"] as? Int ?? 0
                                    let exponencial = pow(10, self.mainCurrencyUnits)
                                    self.chauchasContables.text = "\(self.mainCurrencySymbol)\((Double(balance) / Double(truncating: exponencial as NSNumber)).toStringTrail(Decimales: self.mainCurrencyUnits))"
                                    self.cantChauchasContables = (Double(balance) / Double(truncating: exponencial as NSNumber))
                                    
                                    self.chauchasDisponibles.text = "\(self.mainCurrencySymbol)\((Double(availableBalance) / Double(truncating: exponencial as NSNumber)).toStringTrail(Decimales: self.mainCurrencyUnits))"
                                    self.cantChauchasCompradas = (Double(availableBalance) / Double(truncating: exponencial as NSNumber))
                                }
                            }
                            if let secondaryCurrency = market["secondaryCurrency"] as? [String : Any]{
                                self.secondaryCurrencyUnits = secondaryCurrency["units"] as? Int ?? 0
                                self.secondaryCurrencySymbol = secondaryCurrency["symbol"] as? String ?? ""
                                
                                self.standard.set(self.secondaryCurrencyUnits, forKey: "secondaryCurrencyUnits")
                                self.standard.set(self.secondaryCurrencySymbol, forKey: "secondaryCurrencySymbol")
                                
                                if let wallet = secondaryCurrency["wallet"] as? [String : Any]{
                                    let balance = wallet["balance"] as? Int ?? 0
                                    let availableBalance = wallet["availableBalance"] as? Int ?? 0
                                    let exponencial = pow(10, self.secondaryCurrencyUnits)
                                    self.saldoContable.text = "\(self.secondaryCurrencySymbol)\((Double(balance) / Double(truncating: exponencial as NSNumber)).toStringTrail(Decimales: self.secondaryCurrencyUnits))"
                                    self.saldoPesosContable = (Double(balance) / Double(truncating: exponencial as NSNumber))
                                    
                                    self.saldoDisponible.text = "\(self.secondaryCurrencySymbol)\((Double(availableBalance) / Double(truncating: exponencial as NSNumber)).toStringTrail(Decimales: self.secondaryCurrencyUnits))"
                                    self.saldoPesos = (Double(availableBalance) / Double(truncating: exponencial as NSNumber))
                                }
                            }
                            
                            if let lastTrade = market["lastTrade"] as? [String : Any]{
                                let price = lastTrade["price"] as? Int ?? 0
                                let multiplicador = self.getMultiplicador(withAmount: Int(price))
                                self.pickerClassUltimaTransaccion.units = self.secondaryCurrencyUnits
                                self.pickerClassUltimaTransaccion.simbolo = self.secondaryCurrencySymbol
                                self.pickerClassUltimaTransaccion.multiplicador = multiplicador
                                let seleccionado = self.getSeleccionado(withAmount: Int(price))
                                self.pickerUltimaTransaccionValor.selectRow(seleccionado, inComponent: 0, animated: true)
                            }
                        }
                        if let orderBook = data["orderBook"] as? [String : Any]{
                            if let buy = orderBook["buy"] as? [[String : Any]]{
                                let limitPrice = buy[0]["limitPrice"] as? Int ?? 0
                                self.valorActualCompra = limitPrice
                                self.pickerViewClassChauchaCompra.units = self.secondaryCurrencyUnits
                                self.pickerViewClassChauchaCompra.simbolo = self.secondaryCurrencySymbol
                                self.pickerViewClassChauchaCompra.multiplicador = self.getMultiplicador(withAmount: limitPrice)
                                self.pickerChauchaCompra.selectRow(self.getSeleccionado(withAmount: limitPrice), inComponent: 0, animated: true)
                                
                            }
                            if let sell = orderBook["sell"] as? [[String : Any]]{
                                let limitPrice = sell[0]["limitPrice"] as? Int ?? 0
                                self.valorActualVenta = limitPrice
                                self.pickerViewClassChauchaVenta.units = self.secondaryCurrencyUnits
                                self.pickerViewClassChauchaVenta.simbolo = self.secondaryCurrencySymbol
                                self.pickerViewClassChauchaVenta.multiplicador = self.getMultiplicador(withAmount: limitPrice)
                                self.pickerChauchaVenta.selectRow(self.getSeleccionado(withAmount: limitPrice), inComponent: 0, animated: true)
                            }
                        }
                        
                        let newGananciaMaxima = Int(Double(self.valorActualVenta) * (self.cantChauchasContables - self.cantChauchasContables * self.comisionMaker))
                        
                        if (newGananciaMaxima > self.gananciaMaxima){
                            AudioServicesPlaySystemSound (self.mailUp)
                        }else if(newGananciaMaxima < self.gananciaMaxima){
                            AudioServicesPlaySystemSound (self.mailDown)
                        }
                        
                        self.gananciaMaxima = newGananciaMaxima
                        
                        
                        let newGananciaMinima = Int(Double(self.valorActualCompra) * (self.cantChauchasContables - self.cantChauchasContables * self.comisionMaker))
                        
                        if (newGananciaMinima > self.gananciaMinima){
                            AudioServicesPlaySystemSound (self.mailUp)
                        }else if (newGananciaMinima < self.gananciaMinima){
                            AudioServicesPlaySystemSound (self.mailDown)
                        }
                        
                        self.gananciaMinima = newGananciaMinima
                        
                        self.pickerGananciaClass.units = self.secondaryCurrencyUnits
                        self.pickerGananciaClass.simbolo = self.secondaryCurrencySymbol
                        self.pickerGananciaClass.multiplicador = self.getMultiplicador(withAmount: self.gananciaMinima)
                        self.pickerGanancia.selectRow(self.getSeleccionado(withAmount: self.gananciaMinima), inComponent: 0, animated: true)
                        
                        self.pickerGananciaMaximaClass.units = self.secondaryCurrencyUnits
                        self.pickerGananciaMaximaClass.simbolo = self.secondaryCurrencySymbol
                        self.pickerGananciaMaximaClass.multiplicador = self.getMultiplicador(withAmount: self.gananciaMaxima)
                        self.pickerGananciaMaxima.selectRow(self.getSeleccionado(withAmount: self.gananciaMaxima), inComponent: 0, animated: true)
                        
                    }
                    
                    if(self.firstTime){
                        self.pickerUltimaTransaccionValor.reloadAllComponents()
                        self.pickerChauchaVenta.reloadAllComponents()
                        self.pickerChauchaCompra.reloadAllComponents()
                        self.pickerGananciaMaxima.reloadAllComponents()
                        self.pickerGanancia.reloadAllComponents()
                        self.firstTime = false
                    }
                    self.standard.synchronize()
                }
            }
        }
        
        task.resume()
        
    }
    
    
    func compraChauchas(monto : Double, valorChaucha : Int){
        let montoInt : Int = Int(monto * Double(truncating : pow(10, self.mainCurrencyUnits) as NSNumber))
        let body = ["query": "mutation{ placeLimitOrder(marketCode:\"\(mercado)\", amount : \(montoInt), limitPrice: \(valorChaucha), sell: false){ _id }}"]
        
        let request = getRequest(body: body)
        
        var errorOrden = true
        
        let task = URLSession.shared.dataTask(with: request) { (datos, response, error) in
            if(datos != nil){
                DispatchQueue.main.async {
                    let json = try? JSONSerialization.jsonObject(with: datos!) as! [String: Any]
                    if let data = json!["data"] as? [String: Any]{
                        if let placeLimitOrder = data["placeLimitOrder"] as? [String : Any]{
                            if let _id = placeLimitOrder["_id"] as? String{
                                errorOrden = false
                                
                                Analytics.logEvent("compra", parameters: ["marketCode":self.mercado, "amount":monto, "limitPrice": valorChaucha])
                                
                                let alert = UIAlertController(title: "Orden creada", message: "Orden creada correctamente con ID \(_id)", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
            
            
            DispatchQueue.main.async {
                if(errorOrden){
                    let alert = UIAlertController(title: "Error", message: "Error en la creación de la orden, intente nuevamente", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        task.resume()
    }
    func vendeChauchas(monto : Double, valorChaucha : Int){
        let montoInt : Int = Int(monto * Double(truncating : pow(10, self.mainCurrencyUnits) as NSNumber))
        let body = ["query": "mutation{ placeLimitOrder(marketCode:\"\(mercado)\", amount : \(montoInt), limitPrice: \(valorChaucha), sell: true){ _id __typename }}"]
        
        let request = getRequest(body: body)
        var errorOrden = true
        
        let task = URLSession.shared.dataTask(with: request) { (datos, response, error) in
            if(datos != nil){
                DispatchQueue.main.async {
                    let json = try? JSONSerialization.jsonObject(with: datos!) as! [String: Any]
                    if let data = json!["data"] as? [String: Any]{
                        if let placeLimitOrder = data["placeLimitOrder"] as? [String : Any]{
                            if let _id = placeLimitOrder["_id"] as? String{
                                errorOrden = false
                                Analytics.logEvent("venta", parameters: ["marketCode":self.mercado, "amount":monto, "limitPrice": valorChaucha])
                                let alert = UIAlertController(title: "Orden creada", message: "Orden creada correctamente con ID \(_id)", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
            
            
            DispatchQueue.main.async {
                if(errorOrden){
                    let alert = UIAlertController(title: "Error", message: "Error en la creación de la orden, intente nuevamente", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        task.resume()
    }
    
    @IBOutlet weak var height: NSLayoutConstraint!
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.bannerView.alpha = 0.0
        self.height.constant = 50
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            self.bannerView.alpha = 1
        })
    }
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        self.height.constant = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            self.bannerView.alpha = 0.0
        })
    }
    
}

