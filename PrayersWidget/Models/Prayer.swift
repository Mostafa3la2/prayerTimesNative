//
//  Prayer.swift
//  PrayerTime
//
//  Created by Mostafa on 25/01/2021.
//

import Foundation

struct Prayer{
    var name:String
    var time:String
    var imageName:String
    var prayerType:prayers
}

enum prayers:String{
    case fajr = "الفجر"
    case dhur = "الظهر"
    case asr = "العصر"
    case maghreb = "المغرب"
    case isha = "العشاء"
}


func getImageName(prayer:prayers)->String{
    var imageName:String
    switch prayer {
    case .fajr:
        imageName = "sunrise"
    case .asr, .dhur:
        imageName = "sun"
    case .maghreb:
        imageName = "sunset"
    case .isha:
        imageName = "moon"
    }
    return imageName
}
func getBackgroundImageName(prayer:Prayer)->String{
    var imageName:String
    switch prayer.name {
    case "الفجر":
        imageName = "dawn"
    case "الظهر", "العصر":
        imageName = "sunny"
    case "المغرب":
        imageName = "sunset-1"
    case "العشاء":
        imageName = "night"
    default:
        imageName = ""
    }
    return imageName
}

func timingMapper(timings:prayerTimeTiming,prayer:prayers)->String{
    switch prayer {
    case .asr:
        return timings.asr!
    case .dhur:
        return timings.dhuhr!
    case .fajr:
        return timings.fajr!
    case .isha:
        return timings.isha!
    case .maghreb:
        return timings.maghrib!
    }
}
