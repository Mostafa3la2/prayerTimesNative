//
//  PrayerServices.swift
//  PrayerTime
//
//  Created by Mostafa on 01/02/2021.
//

import Foundation
import Moya
enum PrayerServices{
    case getPrayersByLatLong(lat:String,long:String,tomorrow:Bool)
}
extension PrayerServices:TargetType{
    var baseURL: URL {
        return URL(string: "https://api.aladhan.com/v1")!
    }
    
    var path: String {
        switch self{
        case .getPrayersByLatLong(let _,let _,let tomorrow):
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-YYYY"
            var dateString = ""
            if !tomorrow{
                return "/timings"
            }else{
                let now = Calendar.current.dateComponents(in: .current, from: date)
                let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + 1)
                let dateTomorrow = Calendar.current.date(from: tomorrow)!
                dateString = dateFormatter.string(from: dateTomorrow)
                return "/timings/\(dateString)"
            }
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPrayersByLatLong:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getPrayersByLatLong(let lat,let long, _):
            return .requestParameters(parameters: ["latitude":lat,"longitude":long,"method":5], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    
}
