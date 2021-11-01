//
//  SwiftUIView.swift
//  PrayerTime
//
//  Created by Mostafa on 25/01/2021.
//

import SwiftUI

struct OtherPrayersView: View {
    var prayer:Prayer
    var currentPrayerType:prayers
    var body: some View {
        VStack(spacing:10){
            Image(prayer.imageName).resizable().frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor((currentPrayerType == .dhur || currentPrayerType == .asr ) ? .black : .white)
            HStack(spacing:5){
                Text(prayer.name).font(Font.custom("ReemKufi-Regular", size: 10)).minimumScaleFactor(0.5).scaledToFit().foregroundColor((currentPrayerType == .dhur || currentPrayerType == .asr ) ? .black : .white)
                Text(prayer.time).font(Font.custom("ReemKufi-Regular", size: 10)).fixedSize().foregroundColor((currentPrayerType == .dhur || currentPrayerType == .asr ) ? .black : .white)
//                Text(prayer.name).font(.system(size: 10)).minimumScaleFactor(0.5).scaledToFit()
//                Text(prayer.time).font(.system(size: 10)).fixedSize()
            }.environment(\.layoutDirection, .rightToLeft)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        OtherPrayersView(prayer: Prayer(name: "المغرب", time: "5:30", imageName: "sun", prayerType: .maghreb), currentPrayerType: .asr)
    }
}
