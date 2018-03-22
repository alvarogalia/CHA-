//
//  CuentasViewController.swift
//  Chauchas
//
//  Created by Alvaro Galia Valenzuela on 04-03-18.
//  Copyright © 2018 Alvaro Galia Valenzuela. All rights reserved.
//

import UIKit

class CuentasViewController: UIViewController {

    @IBOutlet weak var btnSalir: UIButton!
    @IBOutlet weak var btnDonar: UIButton!
    @IBOutlet weak var txtApiKey: UITextField!
    @IBOutlet weak var txtSecretKey: UITextField!
    @IBOutlet weak var lblMensajeError: UILabel!
    
    
    @IBAction func btnSalir(_ sender: Any) {
        UIView.animate(withDuration: 2, animations: {
            self.lblMensajeError.text = "Sesión cerrada correctamente"
            self.btnValidarCuenta.backgroundColor = self.colorOriginal
            self.btnValidarCuenta.setTitleColor(self.colorLetraOriginal, for: .normal)
            self.btnValidarCuenta.setTitle("Validar Cuenta", for: .normal)
            
            self.btnSalir.isHidden = true
            
            self.txtSecretKey.text = ""
            self.txtApiKey.text = ""
        }, completion: { (value : Bool) in
            self.lblMensajeError.textColor = UIColor.red
            self.lblMensajeError.isHidden = true
        })
        self.standard.set("", forKey: "ApiKey")
        self.standard.set("", forKey: "SecretKey")
        self.standard.synchronize()
    }
    
    @IBAction func btnDonar(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Donación", message: "La dirección será copiada al portapapeles y serás redirigido al sitio de OrionX para llevar a cabo la donación. Solo pega la dirección copiada donde se indica.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Donar en CHA ❤", style: UIAlertActionStyle.default, handler: { action in
            UIPasteboard.general.string = "cjWoW7oAKKKB4d1o75vVWY4KFbbA2ySx1f"
            UIApplication.shared.open(URL(string : "https://orionx.com/accounts/CHA/send")!, options: [:],completionHandler: nil)
        }))
        alert.addAction(UIAlertAction(title: "Donar en BTC ❤", style: UIAlertActionStyle.default, handler: { action in
            UIPasteboard.general.string = "1BL8MqdiAVmzjFx4kukptYQJdWiLxQSsDk"
            UIApplication.shared.open(URL(string : "https://orionx.com/accounts/BTC/send")!, options: [:],completionHandler: nil)
        }))
        alert.addAction(UIAlertAction(title: "Quizá más tarde 🙄", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func btnLinkKeys(_ sender: Any) {
        UIApplication.shared.open(URL(string : "https://orionx.com/developers/keys")!, options: [:],completionHandler: nil)
    }
    var colorOriginal : UIColor = UIColor.black
    var colorLetraOriginal : UIColor = UIColor.black
    let standard = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var apiKey = ""
        var secret = ""
        
        let standard = UserDefaults.standard
        
        if let ApiKeySession = standard.object(forKey: "ApiKey") as? String {
            apiKey = ApiKeySession
        }
        if let SecretKeySession = standard.object(forKey: "SecretKey") as? String {
            secret = SecretKeySession
        }
        
        txtApiKey.text = apiKey
        txtSecretKey.text = secret
        
        if(apiKey != "" && secret != ""){
            validarCuenta()
        }
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet weak var btnValidarCuenta: UIButton!
    @IBAction func btnValidarCuenta(_ sender: Any) {
        if(self.btnValidarCuenta.title(for: .normal) == "Validar Cuenta" && txtApiKey.text != "" && txtSecretKey.text != ""){
            validarCuenta()
        }else{
            self.performSegue(withIdentifier: "loginSuccess", sender: self)
        }
        
    }
    
    func validarCuenta(){
        let body = ["query": "query{ me{ name }}"]
        
        
        let request = getRequestInicial(ApiKey:txtApiKey.text!, SecretKey:txtSecretKey.text!, body: body)
        //let request = getRequest(body: body)
        let task = URLSession.shared.dataTask(with: request) { (datos, response, error) in
            if(datos != nil){
                
                
                var ok = false
                var nombre = ""
                let json = try? JSONSerialization.jsonObject(with: datos!) as! [String: Any]
                if let data = json!["data"] as? [String: Any]{
                    if let me = data["me"] as? [String: Any]{
                        if let name = me["name"] as? String{
                            ok = true
                            nombre = name
                        }
                    }
                }
                DispatchQueue.main.async {
                    if(ok){
                        self.lblMensajeError.textColor = UIColor.green
                        self.lblMensajeError.text = "Bienvenid@ \(nombre)"
                        
                        self.btnSalir.isHidden = false
                        
                        self.standard.set(self.txtApiKey.text, forKey: "ApiKey")
                        self.standard.set(self.txtSecretKey.text, forKey: "SecretKey")
                        self.standard.synchronize()
                        
                        self.colorOriginal = self.btnValidarCuenta.backgroundColor!
                        self.colorLetraOriginal = self.btnValidarCuenta.titleColor(for: .normal)!
                        
                        self.btnValidarCuenta.setTitle("Comenzar", for: .normal)
                        self.btnValidarCuenta.backgroundColor = self.colorOriginal
                        self.btnValidarCuenta.setTitleColor(self.colorLetraOriginal, for: .normal)
                    }else{
                        self.lblMensajeError.textColor = UIColor.red
                        self.lblMensajeError.text = "Error en la validación de la ApiKey"
                    }
                    self.lblMensajeError.isHidden = false
                }
            }else{
                self.lblMensajeError.textColor = UIColor.red
                self.lblMensajeError.text = "Error en la validación de la ApiKey"
                
                DispatchQueue.main.async {
                    self.lblMensajeError.isHidden = false
                }
            }
        }
        
        task.resume()
    }
}
