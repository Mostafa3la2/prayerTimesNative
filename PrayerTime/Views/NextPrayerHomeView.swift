//
//  NextPrayerHomeView.swift
//  PrayerTime
//
//  Created by Mostafa on 31/08/2021.
//

import SwiftUI

struct NextPrayerHomeView: View {
    var body: some View {
        
        VStack(alignment:.center,spacing:10) {
            Text("6:20").font(Font.custom("ReemKufi-Regular", size: 35))
            HStack{
                Image("sun")
                Text("Maghrib")
            }
            HStack{
                Text("Remaining: ")
                Text("00:15")
            }
        }.background(Image("sunny").resizable().scaledToFill())
    }
}

struct NextPrayerHomeView_Previews: PreviewProvider {
    static var previews: some View {
        NextPrayerHomeView()
    }
}
