//
//  CrearOrdenLimitViewController.swift
//  Chauchas
//
//  Created by Alvaro Galia Valenzuela on 04-03-18.
//  Copyright © 2018 Alvaro Galia Valenzuela. All rights reserved.
//

import UIKit

class CrearOrdenLimitViewController: UIViewController {

    let mercado = "CHACLP"
    
    var cantChauchasCompradas = 0.0
    var saldoDisponible = 0

    
    @IBOutlet weak var txtPrecioLimite: UITextField!
    @IBOutlet weak var txtMonto: UITextField!
    @IBOutlet weak var lblMontoRecibir: UILabel!
    @IBOutlet weak var lblMontoAGastar: UILabel!
    @IBOutlet weak var selectorCompraVenta: UISegmentedControl!
    
    @IBOutlet weak var btnCrearOrden: UIButton!
    
    @IBAction func selectorPorcentaje(_ sender: Any) {
        obtieneCantidadChauchasCompradas()
        if(selectorCompraVenta.selectedSegmentIndex == 0){
            
            if(txtPrecioLimite.text != ""){
                let precioLimite : Double = Double(txtPrecioLimite.text!)!
                if(precioLimite > 0.0){
                    
                    let this = sender as! UISegmentedControl
                    var saldoAUsar = 0.0
                    if(this.selectedSegmentIndex == 4){
                        saldoAUsar = Double(saldoDisponible) * 1
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
                    
                    lblMontoAGastar.text = "$\(Int(montoFinal * precioLimite))"
                    lblMontoRecibir.text = "CHA \(montoFinal)"
                    
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
                let precioLimite : Double = Double(txtPrecioLimite.text!)!
                if(precioLimite > 0.0){
                    
                    let this = sender as! UISegmentedControl
                    var saldoAUsar = 0.0
                    if(this.selectedSegmentIndex == 4){
                        saldoAUsar = Double(cantChauchasCompradas) * 1
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
                    
                    lblMontoAGastar.text = "CHA \(saldoAUsar)"
                    lblMontoRecibir.text = "$ \(montoInt)"
                    
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
                compraChauchas(monto: Double(txtMonto.text!)!, valorChaucha: Int(txtPrecioLimite.text!)!)
                txtMonto.text = "0"
                lblMontoAGastar.text = "0"
                lblMontoRecibir.text = "0"
            }else{
                vendeChauchas(monto: Double(txtMonto.text!)!, valorChaucha: Int(txtPrecioLimite.text!)!)
                txtMonto.text = "0"
                lblMontoAGastar.text = "0"
                lblMontoRecibir.text = "0"
            }
        }
    }
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        obtieneCantidadChauchasCompradas()
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
        
        let limit : Double = Double(txtPrecioLimite.text!) ?? 0.0
        let monto : Double = Double(txtMonto.text!) ?? 0.0
        
        if(selectorCompraVenta.selectedSegmentIndex == 0){
            lblMontoAGastar.text = "$\(Int(limit * monto))"
            lblMontoRecibir.text = "CHA \(txtMonto.text ?? "0")"
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
            lblMontoAGastar.text = "CHA \(txtMonto.text ?? "0")"
            lblMontoRecibir.text = "$\(Int(limit * monto))"
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
                                    mainCurrencyWalletAvailableBalance = mainCurrencyWallet["availableBalance"] as! Int
                                }
                            }
                            
                            if let secondaryCurrency = market["secondaryCurrency"] as? [String: Any]{
                                if let secondaryCurrencyWallet = secondaryCurrency["wallet"] as? [String: Any]{
                                    secondaryCurrencyWalletWalletAvailableBalance = secondaryCurrencyWallet["availableBalance"] as! Int
                                }
                            }
                            DispatchQueue.main.async {
                                self.saldoDisponible = secondaryCurrencyWalletWalletAvailableBalance
                                self.cantChauchasCompradas = Double(mainCurrencyWalletAvailableBalance) / 100000000.0
                            }
                        }
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
