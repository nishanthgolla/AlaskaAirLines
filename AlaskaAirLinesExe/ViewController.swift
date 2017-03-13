//
//  ViewController.swift
//  AlaskaAirLinesExe
//
//  Created by nishanth golla on 2/26/17.
//  Copyright © 2017 nishanth golla. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var finalData:Array<FlightRecordModel> = []
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return url!.appendingPathComponent("Data").path
        }
    @IBOutlet weak var airportCode: UITextField!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let terminateTimeStamp = (PlistManager.sharedInstance.getValueForKey(key: "terminate"))
        if(Date().timeIntervalSince(terminateTimeStamp as! Date) < 600.00)
        {
            loadData()
        }else{
            let updateTime = Date()
            PlistManager.sharedInstance.saveValue(value: updateTime as AnyObject, forKey: "terminate")
            NSKeyedArchiver.archiveRootObject(finalData, toFile: filePath)
        }
        
    }
    
    
    
    private func savaData(recordArray: [FlightRecordModel]){
        
        NSKeyedArchiver.archiveRootObject(recordArray, toFile: filePath)
        
    }
    
    private func loadData(){
        
        if let overData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [FlightRecordModel]{
            finalData = overData
        }
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if((PlistManager.sharedInstance.getValueForKey(key:"isAppRunningFirstTime")) as! Bool){
            
            PlistManager.sharedInstance.saveValue(value: false as AnyObject, forKey: "isAppRunningFirstTime")
        }else{
            
            self.airportCode.text = PlistManager.sharedInstance.getValueForKey(key: "airPortCode") as! String?
            
        }

    }

    @IBAction func submitButton(_ sender: Any) {
        
        
        if(self.airportCode.text?.characters.count == 3){
            PlistManager.sharedInstance.saveValue(value: self.airportCode.text as AnyObject, forKey: "airPortCode")
        }else{
            let alertCt = UIAlertController(title: "Alert", message: "Enter The AirPort Code Correctly", preferredStyle: UIAlertControllerStyle.alert)
            
            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction) in
                alertCt.dismiss(animated: true, completion: nil)
            })
            
            alertCt.addAction(alertAction)
            present(alertCt, animated: true, completion: nil)
            
        }

        let fetchObject = ServiceClass()
        let airportThreeCode:String = self.airportCode.text!
        
        fetchObject.fetchFlightsRecordsWithUrl(flightCode: airportThreeCode as String) { (allFlightRecords, error) in
            if let flightData = allFlightRecords{
                self.finalData = flightData as! Array<FlightRecordModel>
                self.savaData(recordArray: self.finalData)
                self.tableView.reloadData()
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.finalData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let cellData = self.finalData[indexPath.row]
        
        cell.textLabel?.text = "\(cellData.flightCode)"+" "+"\(cellData.airportCode)"+" " + "\(cellData.arrivalTime)"
        
        return cell
        
    }

}

