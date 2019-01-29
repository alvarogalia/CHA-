//
//  CrearOrdenLimitViewController.swift
//  Chauchas
//
//  Created by Alvaro Galia Valenzuela on 04-03-18.
//  Copyright © 2018 Alvaro Galia Valenzuela. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Firebase

class CrearOrdenLimitViewController: UIViewController, GADBannerViewDelegate {

    var mercado = ""
    var bannerView: GADBannerView!
    
    var cantChauchasCompradas = 0.0
    var saldoDisponible = 0

    var mainCurrencyUnits = 0
    var secondaryCurrencyUnits = 0
    
    var mainCurrencySymbol = ""
    var secondaryCurrencySymbol = ""
    
    @IBOutlet weak var txtPrecioLimite: UITextField!
    @IBOutlet weak var txtMonto: UITextField!
    @IBOutlet weak var lblMontoRecibir: UILabel!
    @IBOutlet weak var lblMontoAGastar: UILabel!
    @IBOutlet weak var selectorCompraVenta: UISegmentedControl!
    
    @IBOutlet weak var viewBanner: UIView!
    @IBOutlet weak var btnCrearOrden: UIButton!
    
    @IBAction func selectorPorcentaje(_ sender: Any) {
        obtieneCantidadChauchasCompradas()
        if(selectorCompraVenta.selectedSegmentIndex == 0){
            if(txtPrecioLimite.text != ""){
                let precioLimite : Double = (txtPrecioLimite.text?.doubleValue)!
                if(precioLimite > 0.0){
                    
                    let this = sender as! UISegmentedControl
                    var saldoAUsar = 0.0
                    if(this.selectedSegmentIndex == 4){
                        saldoAUsar = Double(saldoDisponible) * 1.0
                    }
                    if(this.selectedSegmentIndex == 3){
                        saldoAUsar = Double(saldoDisponible) * 0.5
                    }
                    if(this.selectedSegmentIndex == 2){
                        saldoAUsar = Double(saldoDisponible) * 0.25
                    }
                    if(this.selectedSegmentIndex == 1){
                        saldoAUsar = Double(saldoDisponible) * 0.10
                    }
                    if(this.selectedSegmentIndex == 0){
                        saldoAUsar = Double(saldoDisponible) * 0.05
                    }
                    let montoX8 = Double(saldoAUsar / precioLimite) * 100000000.0
                    let montoInt = Int(montoX8)
                    let montoFinal = Double(montoInt) / 100000000.0
                    
                    txtMonto.text = "\(montoFinal)"
                    
                    lblMontoAGastar.text = "\(self.secondaryCurrencySymbol)\(Int(montoFinal * precioLimite))"
                    lblMontoRecibir.text = "\(self.mainCurrencySymbol)\(montoFinal)"
                    
                }else{
                    txtMonto.text = "0"
                    lblMontoAGastar.text = "0"
                    lblMontoRecibir.text = "0"
                }
            }else{
                txtMonto.text = "0"
                lblMontoAGastar.text = "0"
                lblMontoRecibir.text = "0"
            }
            
            
        }else{
            if(txtPrecioLimite.text != ""){
                let precioLimite : Double = (txtPrecioLimite.text?.doubleValue)!
                if(precioLimite > 0.0){
                    
                    let this = sender as! UISegmentedControl
                    var saldoAUsar = 0.0
                    if(this.selectedSegmentIndex == 4){
                        saldoAUsar = Double(cantChauchasCompradas) * 1.0
                    }
                    if(this.selectedSegmentIndex == 3){
                        saldoAUsar = Double(cantChauchasCompradas) * 0.5
                    }
                    if(this.selectedSegmentIndex == 2){
                        saldoAUsar = Double(cantChauchasCompradas) * 0.25
                    }
                    if(this.selectedSegmentIndex == 1){
                        saldoAUsar = Double(cantChauchasCompradas) * 0.10
                    }
                    if(this.selectedSegmentIndex == 0){
                        saldoAUsar = Double(cantChauchasCompradas) * 0.05
                    }
                    let montoInt = Int(saldoAUsar * precioLimite)
                    
                    txtMonto.text = "\(saldoAUsar)"
                    
                    lblMontoAGastar.text = "\(self.mainCurrencySymbol)\(saldoAUsar)"
                    lblMontoRecibir.text = "\(self.secondaryCurrencySymbol)\(montoInt)"
                    
                }else{
                    txtMonto.text = "0"
                    lblMontoAGastar.text = "0"
                    lblMontoRecibir.text = "0"
                }
            }else{
                txtMonto.text = "0"
                lblMontoAGastar.text = "0"
                lblMontoRecibir.text = "0"
            }
        }
    }
    @IBAction func selectorCompraVenta(_ sender: Any) {
        if(selectorCompraVenta.selectedSegmentIndex == 0){
            txtMonto.text = "0"
            lblMontoAGastar.text = "0"
            lblMontoRecibir.text = "0"
            selectorCompraVenta.tintColor = UIColor(displayP3Red: 13/255.0, green: 101/255.0, blue: 91/255.0, alpha: 1.0)
            btnCrearOrden.backgroundColor = UIColor(displayP3Red: 13/255.0, green: 101/255.0, blue: 91/255.0, alpha: 1.0)
        }else{
            txtMonto.text = "0"
            lblMontoAGastar.text = "0"
            lblMontoRecibir.text = "0"
            selectorCompraVenta.tintColor = UIColor(displayP3Red: 133/255.0, green: 0/255.0, blue: 12/255.0, alpha: 1.0)
            btnCrearOrden.backgroundColor = UIColor(displayP3Red: 133/255.0, green: 0/255.0, blue: 12/255.0, alpha: 1.0)
        }
        
    }
    @IBAction func btnCrearOrden(_ sender: Any) {
        if(txtMonto.text == ""){
            txtMonto.text = "0"
        }
        if(txtPrecioLimite.text == ""){
            txtPrecioLimite.text = "0"
        }
        if(lblMontoRecibir.text != "0" && lblMontoAGastar.text != "0"){
            if(selectorCompraVenta.selectedSegmentIndex == 0){
                let alert = UIAlertController(title: "Confirmación", message: "Estás seguro de comprar \(self.mainCurrencySymbol)\((txtMonto.text?.doubleValue)!) a \(self.secondaryCurrencySymbol)\(txtPrecioLimite.text!)?", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Confirmar", style: UIAlertActionStyle.default, handler: { action in
                    
                    self.compraChauchas(monto: (self.txtMonto.text?.doubleValue)!, valorChaucha: Int(self.txtPrecioLimite.text!)!)
                    self.txtMonto.text = "0"
                    self.lblMontoAGastar.text = "0"
                    self.lblMontoRecibir.text = "0"
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "Confirmación", message: "Estás seguro de comprar \(self.mainCurrencySymbol)\((txtMonto.text?.doubleValue)!) a \(self.secondaryCurrencySymbol)\(txtPrecioLimite.text!)?", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Confirmar", style: UIAlertActionStyle.default, handler: { action in
                    
                    self.vendeChauchas(monto: (self.txtMonto.text?.doubleValue)!, valorChaucha: Int(self.txtPrecioLimite.text!)!)
                    self.txtMonto.text = "0"
                    self.lblMontoAGastar.text = "0"
                    self.lblMontoRecibir.text = "0"
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    var timer = Timer()
    var standard = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()

        if let market = standard.object(forKey: "mercado") as? String {
            mercado = market
        }
        
        self.mainCurrencySymbol = standard.string(forKey: "mainCurrencySymbol") ?? ""
        self.mainCurrencyUnits = standard.integer(forKey: "mainCurrencyUnits")
        self.secondaryCurrencyUnits = standard.integer(forKey: "mainCurrencyUnits")
        self.secondaryCurrencySymbol = standard.string(forKey: "secondaryCurrencySymbol") ?? ""
        
        
        hideKeyboardWhenTappedAround()
        obtieneCantidadChauchasCompradas()
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-6479995755181265/1420891830"
        bannerView.rootViewController = self
        viewBanner.addBannerViewToView(bannerView: bannerView)
        bannerView.load(GADRequest())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.obtieneCantidadChauchasCompradas), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func obtieneCantidadChauchasCompradas(){
        
        let limit : Double = (txtPrecioLimite.text?.doubleValue)!
        let monto : Double = (txtMonto.text?.doubleValue)!
        
        if(selectorCompraVenta.selectedSegmentIndex == 0){
            lblMontoAGastar.text = "\(self.secondaryCurrencySymbol)\(Int(limit * monto))"
            lblMontoRecibir.text = "\(self.mainCurrencySymbol)\(txtMonto.text ?? "0")"
            if(Int(limit * monto) > self.saldoDisponible){
                btnCrearOrden.isEnabled = false
            }else{
                btnCrearOrden.isEnabled = true
            }
        }else{
            if(monto > cantChauchasCompradas){
                 btnCrearOrden.isEnabled = false
            }else{
                btnCrearOrden.isEnabled = true
            }
            lblMontoAGastar.text = "\(self.mainCurrencySymbol)\(txtMonto.text ?? "0")"
            lblMontoRecibir.text = "\(self.secondaryCurrencySymbol)\(Int(limit * monto))"
        }
        
        let body = ["query": "{ market(code: \"\(mercado)\") { commission mainCurrency { ...getMarketCurrency } secondaryCurrency { ...getMarketCurrency } } me { _id marketFees(marketCode: \"\(mercado)\") { maker taker } }}fragment getMarketCurrency on Currency { wallet { availableBalance }}"]
        
        let request = getRequest(body: body)

        let task = URLSession.shared.dataTask(with: request) { (datos, response, error) in
            if(datos != nil){
                if let json = try? JSONSerialization.jsonObject(with: datos!) as! [String: Any]{
                    if let data = json["data"] as? [String: Any]{
                        if let market = data["market"] as? [String : Any]{
                            var secondaryCurrencyWalletWalletAvailableBalance = 0
                            var mainCurrencyWalletAvailableBalance = 0
                            
                            if let mainCurrency = market["mainCurrency"] as? [String: Any]{
                                if let mainCurrencyWallet = mainCurrency["wallet"] as? [String: Any]{
                                    mainCurrencyWalletAvailableBalance = mainCurrencyWallet["availableBalance"] as? Int ?? 0
                                }
                            }
                            
                            if let secondaryCurrency = market["secondaryCurrency"] as? [String: Any]{
                                if let secondaryCurrencyWallet = secondaryCurrency["wallet"] as? [String: Any]{
                                    secondaryCurrencyWalletWalletAvailableBalance = secondaryCurrencyWallet["availableBalance"] as? Int ?? 0
                                }
                            }
                            DispatchQueue.main.async {
                                self.saldoDisponible = secondaryCurrencyWalletWalletAvailableBalance
                                self.cantChauchasCompradas = Double(mainCurrencyWalletAvailableBalance) / Double(truncating: pow(10, self.mainCurrencyUnits) as NSNumber)
                            }
                        }
                    }
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
