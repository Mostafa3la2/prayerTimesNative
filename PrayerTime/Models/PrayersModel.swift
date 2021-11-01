//
//  PrayersModel.swift
//  PrayerTime
//
//  Created by Mostafa on 01/02/2021.
//

import Foundation

struct prayerTimeModel : Codable {

        let code : Int?
        let data : prayerTimeDatum?
        let status : String?

        enum CodingKeys: String, CodingKey {
                case code = "code"
                case data = "data"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                code = try values.decodeIfPresent(Int.self, forKey: .code)
                data = try values.decodeIfPresent(prayerTimeDatum.self, forKey: .data)
                status = try values.decodeIfPresent(String.self, forKey: .status)
        }

}

struct prayerTimeDatum : Codable {

        let timings : prayerTimeTiming?

        enum CodingKeys: String, CodingKey {

                case timings = "timings"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                timings = try values.decodeIfPresent(prayerTimeTiming.self, forKey: .timings)
        }

}
struct prayerTimeTiming : Codable {

        let asr : String?
        let dhuhr : String?
        let fajr : String?
        let imsak : String?
        let isha : String?
        let maghrib : String?
        let midnight : String?
        let sunrise : String?
        let sunset : String?

        enum CodingKeys: String, CodingKey {
                case asr = "Asr"
                case dhuhr = "Dhuhr"
                case fajr = "Fajr"
                case imsak = "Imsak"
                case isha = "Isha"
                case maghrib = "Maghrib"
                case midnight = "Midnight"
                case sunrise = "Sunrise"
                case sunset = "Sunset"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                asr = try values.decodeIfPresent(String.self, forKey: .asr)
                dhuhr = try values.decodeIfPresent(String.self, forKey: .dhuhr)
                fajr = try values.decodeIfPresent(String.self, forKey: .fajr)
                imsak = try values.decodeIfPresent(String.self, forKey: .imsak)
                isha = try values.decodeIfPresent(String.self, forKey: .isha)
                maghrib = try values.decodeIfPresent(String.self, forKey: .maghrib)
                midnight = try values.decodeIfPresent(String.self, forKey: .midnight)
                sunrise = try values.decodeIfPresent(String.self, forKey: .sunrise)
                sunset = try values.decodeIfPresent(String.self, forKey: .sunset)
        }
    init(fajr:String,dhur:String,asr:String,maghreb:String,isha:String) {
        self.fajr = fajr
        self.dhuhr = dhur
        self.asr = asr
        self.maghrib = maghreb
        self.isha = isha
        self.imsak = ""
        self.midnight = ""
        self.sunset = ""
        self.sunrise = ""
    }

}




