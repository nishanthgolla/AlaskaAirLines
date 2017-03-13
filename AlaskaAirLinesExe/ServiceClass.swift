//
//  ServiceClass.swift
//  AlaskaCodeTest
//
//  Created by nishanth golla on 2/23/17.
//  Copyright © 2017 nishanth golla. All rights reserved.
//

import UIKit

class ServiceClass: NSObject {
    
    
    func fetchFlightsRecordsWithUrl(flightCode: String, WithCompletion:@escaping (AnyObject?, NSError?)->Void) -> Void {
        
        let urL = URL.init(string: "https://api.qa.alaskaair.com/1/airports/\(flightCode)/flights/0/60")
        
        
        let  configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        
        var request = URLRequest(url: urL!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 120.0)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic YWFnZTQxNDAxMjgwODYyNDk3NWFiYWNhZjlhNjZjMDRlMWY6ODYyYTk0NTFhYjliNGY1M2EwZWJiOWI2ZWQ1ZjYwOGM=", forHTTPHeaderField: "Authorization")
        
        
        let postDataTask:URLSessionDataTask = session.dataTask(with: request) { (data, responce, erreo) in
            let jsonData = data
            do{
                
                var allFlightdata:Array<Any> = []
                let flightData = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                
                let dateFormatter = DateFormatter()
                
                for each in (flightData as! Array<Any>) {
                    var flightDict = (each as! Dictionary<String, Any>)
                    
                    
                    
                    // Converting the UTC time to local TimeZone
                    let mytime:String = (flightDict["EstArrTime"] as! String)
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    let date = dateFormatter.date(from: mytime)// create   date from string
                    dateFormatter.timeZone = NSTimeZone.local
                    let timeStamp = dateFormatter.string(from: date!)
                    
                    //For fetching the current time range of one hour
                    let currentTimeStamp = Date()
                    let calendar = Calendar.current
                    let date3 = calendar.date(byAdding: .minute, value: 60, to: currentTimeStamp )
                    let date4 = calendar.date(byAdding: .minute, value: -10, to: currentTimeStamp )
                    let dateStart = dateFormatter.string(from: date3!)
                    let dateend = dateFormatter.string(from: date4!)
                    
                    flightDict["EstArrTime"] = timeStamp
                    
                    let flightRecord:FlightRecordModel = FlightRecordModel.init(dict: flightDict as NSDictionary)
                    // Applying the Time Filter
                    if(flightRecord.arrivalTime >= dateend && flightRecord.arrivalTime <= dateStart){
                        
                        allFlightdata.append(flightRecord)
                        
                    }
                    
                }
                
                // Implementing the sort functionality
                allFlightdata.sort(by: { ($0 as! FlightRecordModel).arrivalTime.compare(($1 as! FlightRecordModel).arrivalTime as String) == ComparisonResult.orderedAscending })
                DispatchQueue.main.async {
                    WithCompletion(allFlightdata as AnyObject?,nil)
                }
            }
            catch let JSONerror as NSError{
                DispatchQueue.main.async {
                    WithCompletion(nil,JSONerror)
                    
                }
            }
        }
        postDataTask.resume()
        
    }
    
    
    
}
