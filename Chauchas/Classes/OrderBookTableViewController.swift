//
//  OrderBookTableViewController.swift
//  Chauchas
//
//  Created by Alvaro Galia Valenzuela on 12-03-18.
//  Copyright © 2018 Alvaro Galia Valenzuela. All rights reserved.
//

import UIKit

class OrderBookTableViewController: UITableViewController {

    var maxAmount = 0
    var items = [OrderBook]()
    var nombreCelda = ""
    var maxAccumulated = 0
    
    var secondaryCurrencyUnits = 0
    var mainCurrencyUnits = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(30.0)
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
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.nombreCelda, for: indexPath) as! OrderBookTableViewCell
        
        for vista in cell.subviews{
            if ( vista.backgroundColor == cell.lblLimit.textColor){
                vista.removeFromSuperview()
            }
        }
        
        let amount = items[indexPath.row].amount
        let width = Double(Double(cell.lblChauchas.frame.width/3)*Double(amount)/Double(maxAmount))
        
        let accumulated = items[indexPath.row].accumulated
        let widthAccumulated = Double(Double(cell.lblChauchas.frame.width/3)*Double(accumulated)/Double(maxAccumulated))
        
        cell.lblChauchas.text = "\(Double(Double(items[indexPath.row].amount)/Double(truncating: pow(10, self.mainCurrencyUnits) as NSNumber)).toString(Decimales: self.mainCurrencyUnits))"
        cell.lblLimit.text = "\(Double(Double(items[indexPath.row].limitPrice) / Double(truncating: pow(10, self.secondaryCurrencyUnits) as NSNumber)).toString(Decimales: self.secondaryCurrencyUnits))"

        //cell.viewChamullo.frame = CGRect(x: cell.viewChamullo.frame.minX, y: cell.viewChamullo.frame.minY, width: CGFloat(width), height: cell.viewChamullo.frame.height)

        // Configure the cell...
        
        //cell.viewChamullo.frame = CGRect(x: 1, y: 1, width: 100, height: 50)
        //cell.updateConstraints()
        
        
        let viewAccumulated = UIView()
        viewAccumulated.frame = CGRect(x: 0.0, y: 0.0, width: widthAccumulated, height: Double(cell.frame.height))
        viewAccumulated.backgroundColor = cell.lblLimit.textColor
        viewAccumulated.alpha = 0.3
        cell.addSubview(viewAccumulated)
        
        let view = UIView()
        view.frame = CGRect(x: 0.0, y: 0.0, width: width, height: Double(cell.frame.height))
        view.backgroundColor = cell.lblLimit.textColor
        view.alpha = 0.5
        cell.addSubview(view)
        
        
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

}
