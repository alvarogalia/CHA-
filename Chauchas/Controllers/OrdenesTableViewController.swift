//
//  OrdenesTableViewController.swift
//  Chauchas
//
//  Created by Alvaro Galia Valenzuela on 04-03-18.
//  Copyright © 2018 Alvaro Galia Valenzuela. All rights reserved.
//

import UIKit

class OrdenesTableViewController: UITableViewController {

    @IBOutlet weak var lblTotalCompras: UILabel!
    @IBOutlet weak var lblTotalVentas: UILabel!
    @IBOutlet weak var viewTotales: UIView!
    
    @IBOutlet weak var selectorEstadoOrdenes: UISegmentedControl!
    var arrayAbiertas = [Orden]()
    var arrayCerradas = [Orden]()
    var arrayCanceladas = [Orden]()
    var array = [Orden]()
    
    var mercado = ""
    
    var totalCompras = 0
    var totalVentas = 0
    
    var mainCurrencyUnits = 0
    var secondaryCurrencyUnits = 0
    
    var mainCurrencySymbol = ""
    var secondaryCurrencySymbol = ""
    
    @IBAction func selectorEsadoOrdenes(_ sender: Any) {
        obtieneOrdenes()
    }
    
    var timer = Timer()
    var standard = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        if let market = standard.object(forKey: "mercado") as? String {
            mercado = market
        }
        
        self.mainCurrencySymbol = standard.string(forKey: "mainCurrencySymbol") ?? ""
        self.mainCurrencyUnits = standard.integer(forKey: "mainCurrencyUnits")
        self.secondaryCurrencyUnits = standard.integer(forKey: "mainCurrencyUnits")
        self.secondaryCurrencySymbol = standard.string(forKey: "secondaryCurrencySymbol") ?? ""
        
        obtieneOrdenes()
        
    }
    func obtieneOrdenes(){
        self.array.removeAll()
        self.tableView.reloadData()
        timer.invalidate()
        if(selectorEstadoOrdenes.selectedSegmentIndex == 0){
            self.viewTotales.isHidden = false
            obtieneOrdenesAbiertas()
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.obtieneOrdenesAbiertas), userInfo: nil, repeats: true)
        }else if(selectorEstadoOrdenes.selectedSegmentIndex == 1){
            self.viewTotales.isHidden = false
            obtieneOrdenesCerradas()
            timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.obtieneOrdenesCerradas), userInfo: nil, repeats: true)
        }else if(selectorEstadoOrdenes.selectedSegmentIndex == 2){
            self.viewTotales.isHidden = true
            obtieneOrdenesCanceladas()
            timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.obtieneOrdenesCanceladas), userInfo: nil, repeats: true)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        obtieneOrdenes()
    }
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellOrden", for: indexPath) as! OrdenesTableViewCell
        
        if(array[indexPath.row].sell){
            //cell.backgroundColor = UIColor(displayP3Red: 90/255.0, green: 97/255.0, blue: 55/255.0, alpha: 1.0)
            
            cell.lblOperacion.text = "Venta"
            cell.lblTotal.textColor = UIColor.green
            cell.lblTotalEjecutado.textColor = UIColor.green
            
            if(array[indexPath.row].type == "market"){
                cell.lblMonto.text = "market"
                cell.lblCantidad.text = "\(Double(array[indexPath.row].amount) / Double(truncating: pow(10, self.secondaryCurrencyUnits) as NSNumber))"
                cell.lblTotal.text = "0"
                cell.lblTotalEjecutado.text = "0"
            }
        }else{
            //cell.backgroundColor = UIColor(displayP3Red: 87/255.0, green: 61/255.0, blue: 54/255.0, alpha: 1.0)
            cell.lblOperacion.text = "Compra"
            cell.lblTotal.textColor = UIColor.red
            cell.lblTotalEjecutado.textColor = UIColor.red
            if(array[indexPath.row].type == "market"){
                cell.lblMonto.text = "market"
                cell.lblCantidad.text = "\(array[indexPath.row].secondaryAmount)"
                cell.lblFilled.text = "\(Double(array[indexPath.row].secondaryFilled)/Double(truncating: pow(10, self.secondaryCurrencyUnits) as NSNumber))"
                
                cell.lblTotal.text = "\(Int(Double(array[indexPath.row].secondaryAmount)))"
                cell.lblTotalEjecutado.text = "\(Int(Double(array[indexPath.row].secondaryFilled)))"
            }
        }
        if(array[indexPath.row].type == "limit"){
            cell.lblMonto.text = "\(array[indexPath.row].limitPrice)\(array[indexPath.row].mainCurrencyCode)"
            cell.lblCantidad.text = "\(Double(array[indexPath.row].amount)/Double(truncating: pow(10, self.secondaryCurrencyUnits) as NSNumber))"
            cell.lblTotal.text = "\(Int(Double(array[indexPath.row].amount)/Double(truncating: pow(10, self.secondaryCurrencyUnits) as NSNumber) * Double(array[indexPath.row].limitPrice)))"
            cell.lblTotalEjecutado.text = "\(Int(Double(array[indexPath.row].filled)/Double(truncating: pow(10, self.secondaryCurrencyUnits) as NSNumber) * Double(array[indexPath.row].limitPrice)))"
            
        }
        
        cell.lblFilled.text = "\(Double(array[indexPath.row].filled)/Double(truncating: pow(10, self.secondaryCurrencyUnits) as NSNumber))"
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70.0)
    }

    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cancelarOrden(withID: array[indexPath.row]._id)
            array.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func obtieneOrdenesAbiertas(){
        let body = ["query" : "query { orders(marketCode: \"\(mercado)\", onlyOpen: true, limit: 10000, page: 1) { totalCount hasNextPage page items { _id sell type amount amountToHold secondaryAmount filled closedAt secondaryFilled limitPrice createdAt activatedAt isStop status stopPriceUp stopPriceDown market { name code mainCurrency { code format longFormat units __typename } secondaryCurrency { code format longFormat units __typename } __typename } __typename } __typename }}"]
        
        let request = getRequest(body: body)
        
        
        let task = URLSession.shared.dataTask(with: request) { (datos, response, error) in
            if(datos != nil){
                let json = try? JSONSerialization.jsonObject(with: datos!) as! [String: Any]
                if let data = json!["data"] as? [String: Any]{
                    if let orders = data["orders"] as? [String : Any]{
                        if let items = orders["items"] as? [[String: Any]]{
                            self.arrayAbiertas.removeAll()
                            self.totalCompras = 0
                            self.totalVentas = 0
                            
                            for item in items{
                                let orden = self.llenaOrden(withItem: item)
                                self.arrayAbiertas.append(orden)
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.array = self.arrayAbiertas
                        self.tableView.reloadData()
                        
                        self.lblTotalVentas.text = "\(self.secondaryCurrencySymbol)\(self.totalVentas)"
                        self.lblTotalCompras.text = "\(self.secondaryCurrencySymbol)\(self.totalCompras)"
                    }
                }
            }
        }
        
        task.resume()
    }
    @objc func obtieneOrdenesCerradas(){
        let body = ["query" : "query { orders(marketCode: \"\(mercado)\", onlyClosed: true, limit: 10000, page: 1) { totalCount hasNextPage page items { _id sell type amount amountToHold secondaryAmount filled closedAt secondaryFilled limitPrice createdAt activatedAt isStop status stopPriceUp stopPriceDown market { name code mainCurrency { code format longFormat units __typename } secondaryCurrency { code format longFormat units __typename } __typename } __typename } __typename }}"]
        
        let request = getRequest(body: body)
        
        
        
        let task = URLSession.shared.dataTask(with: request) { (datos, response, error) in
            if(datos != nil){
                let json = try? JSONSerialization.jsonObject(with: datos!) as! [String: Any]
                if let data = json!["data"] as? [String: Any]{
                    if let orders = data["orders"] as? [String : Any]{
                        if let items = orders["items"] as? [[String: Any]]{
                            self.arrayCerradas.removeAll()
                            self.totalCompras = 0
                            self.totalVentas = 0
                            for item in items{
                                let orden = self.llenaOrden(withItem: item)
                                if(orden.status == "closed"){
                                    self.arrayCerradas.append(orden)
                                }
                            }
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.array = self.arrayCerradas
                self.tableView.reloadData()
                self.lblTotalVentas.text = "\(self.secondaryCurrencySymbol)\(self.totalVentas)"
                self.lblTotalCompras.text = "\(self.secondaryCurrencySymbol)\(self.totalCompras)"
            }
        }
        
        task.resume()
    }
    
    @objc func obtieneOrdenesCanceladas(){
        let body = ["query" : "query { orders(marketCode: \"\(mercado)\", onlyClosed: true, limit: 50, page: 1) { totalCount hasNextPage page items { _id sell type amount amountToHold secondaryAmount filled closedAt secondaryFilled limitPrice createdAt activatedAt isStop status stopPriceUp stopPriceDown market { name code mainCurrency { code format longFormat units __typename } secondaryCurrency { code format longFormat units __typename } __typename } __typename } __typename }}"]
        
        let request = getRequest(body: body)
        
        
        
        let task = URLSession.shared.dataTask(with: request) { (datos, response, error) in
            if(datos != nil){
                if let json = try? JSONSerialization.jsonObject(with: datos!) as! [String: Any]{
                    if let data = json["data"] as? [String: Any]{
                        if let orders = data["orders"] as? [String : Any]{
                            if let items = orders["items"] as? [[String: Any]]{
                                self.arrayCanceladas.removeAll()
                                self.totalCompras = 0
                                self.totalVentas = 0
                                for item in items{
                                    let orden = self.llenaOrden(withItem: item)
                                    if(orden.status == "canceled"){
                                        self.arrayCanceladas.append(orden)
                                    }
                                }
                            }
                            
                        }
                    }
                }
                
            }
            DispatchQueue.main.async {
                self.array = self.arrayCanceladas
                self.tableView.reloadData()
                
                self.lblTotalVentas.text = "\(self.secondaryCurrencySymbol)\(self.totalVentas)"
                self.lblTotalCompras.text = "\(self.secondaryCurrencySymbol)\(self.totalCompras)"
            }
        }
        
        task.resume()
    }
    func llenaOrden(withItem: [String: Any]) -> Orden{
        let orden = Orden()
        let item = withItem
        
        orden._id = item["_id"] as! String
        orden.sell = item["sell"] as! Bool
        orden.type = item["type"] as! String
        orden.amount = item["amount"] as? Int ?? 0
        orden.amountToHold = item["amountToHold"] as? Int ?? 0
        orden.secondaryAmount = item["secondaryAmount"] as? Int ?? 0
        orden.closedAt = item["closedAt"] as? Int ?? 0
        orden.filled = item["filled"] as? Int ?? 0
        orden.secondaryFilled = item["secondaryFilled"] as? Int ?? 0
        orden.limitPrice = item["limitPrice"] as? Int ?? 0
        orden.createdAt = item["limitPrice"] as? Int ?? 0
        orden.activatedAt = item["activatedAt"] as? Int ?? 0
        orden.isStop = item["isStop"] as? Bool ?? false
        orden.status = item["status"] as! String
        orden.stopPriceUp = item["stopPriceUp"] as? Int ?? 0
        orden.stopPriceDown = item["stopPriceDown"] as? Int ?? 0
        
        if(orden.type == "limit"){
            if(orden.sell){
                self.totalVentas = self.totalVentas + Int(Double(orden.amount)/Double(truncating: pow(10, self.secondaryCurrencyUnits) as NSNumber) * Double(orden.limitPrice))
            }else{
                self.totalCompras = self.totalCompras + Int(Double(orden.amount)/Double(truncating: pow(10, self.secondaryCurrencyUnits) as NSNumber) * Double(orden.limitPrice))
            }
            
        }
        
        return orden
    }
    func cancelarOrden(withID: String){
        let body = ["query":"mutation{cancelOrder(orderId:\"\(withID)\") {_id}}"]
        let request = getRequest(body: body)
        let task = URLSession.shared.dataTask(with: request) { (datos, response, error) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
}
