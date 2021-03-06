//
//  MercadosCollectionViewController.swift
//  Chauchas
//
//  Created by Alvaro Galia Valenzuela on 15-03-18.
//  Copyright © 2018 Alvaro Galia Valenzuela. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Firebase

private let reuseIdentifier = "cellMercado"

class MercadosCollectionViewController: UICollectionViewController, GADBannerViewDelegate {

    var mercados = [Mercado]()
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-6479995755181265/1720629950"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
    }

    var timer = Timer()
    
    override func viewWillAppear(_ animated: Bool) {
        cargaMercados()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.cargaMercados), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    @objc func cargaMercados(){
        let body = ["query": "query getMarkets { clpMarkets: markets { ...exchangeNavbarMarkets } } fragment exchangeNavbarMarkets on Market { releaseDate code name lastTrade { price } currentStats(aggregation: d1) { close open volume variation } secondaryCurrency { symbol format units } }"]
        
        let request = getRequest(body: body)
        
        
        mercados = [Mercado]()
        let task = URLSession.shared.dataTask(with: request) { (datos, response, error) in
            if(datos != nil){
                DispatchQueue.main.async {
                    let json = try? JSONSerialization.jsonObject(with: datos!) as! [String: Any]
                    if let data = json!["data"] as? [String: Any]{
                        if let clpMarkets = data["clpMarkets"] as? [[String:Any]]{
                            for market in clpMarkets{
                                let mercado = Mercado()
                                mercado.code = market["code"] as? String ?? ""
                                mercado.name = market["name"] as? String ?? ""
                                mercado.releaseDate = market["releaseDate"] as? Int ?? 0
                                
                                if let lastTrade = market["lastTrade"] as? [String : Any]{
                                    mercado.price = lastTrade["price"] as? Int ?? 0
                                }
                                if let currentStats = market["currentStats"] as? [String : Any]{
                                    mercado.volume = currentStats["volume"] as? Int ?? 0
                                    mercado.variation = currentStats["variation"] as? Double ?? 0.0
                                }
                                if let secondaryCurrency = market["secondaryCurrency"] as? [String : Any]{
                                    mercado.symbol = secondaryCurrency["symbol"] as? String ?? ""
                                    mercado.units = secondaryCurrency["units"] as? Int ?? 0
                                }
                                //if(mercado.code == "CHACLP" || mercado.code == "LUKCLP" || mercado.code == "XMRCLP"){
                                    let timestamp = NSDate().timeIntervalSince1970
                                    let timestamp2 = Int(timestamp*1000)
                                    
                                    if(mercado.releaseDate <= timestamp2){
                                        self.mercados.append(mercado)
                                    }
                                //}
                            }
                        }
                    }
                    self.collectionView?.reloadData()
                }
            }
        }
        
        task.resume()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if(mercados.count > 0){
            return mercados.count + 1
        }else{
            return mercados.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(indexPath.row < self.mercados.count){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MercadosCollectionViewCell
            var units = 8
            let volume = Double(mercados[indexPath.row].volume) / Double(truncating : pow(10,units) as NSNumber)
            cell.lblVolumen.text = "\(volume.toStringTrail(Decimales: 3))"
            
            units = 2
            let variation = Double(mercados[indexPath.row].variation) * Double(truncating : pow(10,units) as NSNumber)
            cell.lblVariacion.text = "\(variation.toStringTrail(Decimales: units))%"
            if(variation > 0){
                cell.lblVariacion.textColor = UIColor.green
            }else{
                cell.lblVariacion.textColor = UIColor.red
            }
            
            
            cell.lblNombreMercado.text = "\(mercados[indexPath.row].name)"
            
            units = mercados[indexPath.row].units
            let price = Double(mercados[indexPath.row].price) / Double(truncating : pow(10,units) as NSNumber)
            cell.lblUltimaTransaccion.text = "\(mercados[indexPath.row].symbol)\(price.toStringTrail(Decimales: units))"
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellBanner", for: indexPath) as! BannerMercadoCollectionViewCell
            cell.frame = CGRect(x: cell.frame.minX, y: cell.frame.minY, width: cell.frame.width, height: 50)
            cell.vista.addBannerViewToView(bannerView: bannerView)
            return cell
        }
    }

    var standard = UserDefaults.standard
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.row < self.mercados.count){
            self.standard.set(mercados[indexPath.row].code, forKey: "mercado")
            self.standard.synchronize()
            Analytics.logEvent("mercadoSeleccionado", parameters: ["marketName":mercados[indexPath.row].code])
            self.performSegue(withIdentifier: "mercadoSeleccionado", sender: self)
        }
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
