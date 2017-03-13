//
//  FlightRecordModel.swift
//  AlaskaCodeTest
//
//  Created by nishanth golla on 2/26/17.
//  Copyright © 2017 nishanth golla. All rights reserved.
//

import UIKit

class FlightRecordModel: NSObject, NSCoding{
    
    
    struct Keys {
        static let FligtCode = "flightCode"
        static let AirportCode = "airportCode"
        static let ArrivalTime = "arrivalTime"
    }
    
   private var _flightCode:String = " "
   private var _airportCode:String = " "
   private var _arrivalTime:String = " "
    
    
    init(dict: NSDictionary) {
        self._flightCode = dict.object(forKey: "FltId") as! String
        self._airportCode = dict.object(forKey: "Orig") as! String
        self._arrivalTime = dict.object(forKey: "EstArrTime") as! String
    }
    
    
    required init(coder decoder:NSCoder) {
        if let flightCodeObject = decoder.decodeObject(forKey: Keys.FligtCode) as? String {
            _flightCode = flightCodeObject
        }
        
        if let airportCodeObject = decoder.decodeObject(forKey: Keys.AirportCode) as? String {
            _airportCode = airportCodeObject
        }
        if let arrivalTimeObject =  decoder.decodeObject(forKey: Keys.ArrivalTime) as? String {
            _arrivalTime =  arrivalTimeObject
        }
        
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_flightCode, forKey: Keys.FligtCode)
        aCoder.encode(_airportCode, forKey: Keys.AirportCode)
        aCoder.encode(_arrivalTime, forKey: Keys.ArrivalTime)
    }
    
    
    var flightCode: String {
            
        get{
            
            return _flightCode
        }
        set{
            _flightCode = newValue
        }
    }

        var airportCode: String {
            
            get{
                return _airportCode
            }
            
            set{
                _airportCode = newValue
            }
            
        }
    
    var arrivalTime:String {
        get{
            return _arrivalTime
        }
        set{
            _arrivalTime = newValue
        }
    }
    


    }
    
    
    
    

