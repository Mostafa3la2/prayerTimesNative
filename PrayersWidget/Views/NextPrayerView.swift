//
//  NextPrayerView.swift
//  PrayerTime
//
//  Created by Mostafa on 25/01/2021.
//

import SwiftUI

struct NextPrayerView: View {
    var prayer:Prayer
    var currentPrayerType:prayers
    var body: some View {
        HStack(spacing:10){
            Image(prayer.imageName).resizable().frame(width: 30, height: 30, alignment: .center).foregroundColor((currentPrayerType == .dhur || currentPrayerType == .asr ) ? .black : .white)
            Text(prayer.name).font(Font.custom("ReemKufi-Regular", size: 15)).foregroundColor((currentPrayerType == .dhur || currentPrayerType == .asr ) ? .black : .white)
            Text(prayer.time).font(Font.custom("ReemKufi-Regular", size: 15)).foregroundColor((currentPrayerType == .dhur || currentPrayerType == .asr ) ? .black : .white)
        }.environment(\.layoutDirection, .rightToLeft)
        
    }
}

struct NextPrayerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NextPrayerView(prayer: Prayer(name: "الفجر", time: "4:30", imageName: "sunset", prayerType: .fajr), currentPrayerType: .fajr)
            
        }
    }
}
