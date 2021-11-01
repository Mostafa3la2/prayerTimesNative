//
//  PrayersWidget.swift
//  PrayersWidget
//
//  Created by Mostafa on 25/01/2021.
//

import WidgetKit
import SwiftUI
import Intents
import Moya
import CoreLocation


private func detectNextPrayer(timings:prayerTimeTiming)->(prayers,[prayers],Bool){
    let date = Date()
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "HH:mm"
    let dateString = dateformatter.string(from: date)
    
    if dateString >= timings.fajr! && dateString < timings.dhuhr!{
        return (.dhur,[.asr,.maghreb,.isha,.fajr],false)
    }else if dateString >= timings.dhuhr! && dateString < timings.asr!{
        return (.asr,[.maghreb,.isha,.fajr,.dhur],false)
    }
    else if dateString >= timings.asr! && dateString < timings.maghrib!{
        return (.maghreb,[.isha,.fajr,.dhur,.asr],false)
    }else if dateString >= timings.maghrib! && dateString < timings.isha!{
        return (.isha,[.fajr,.dhur,.asr,.maghreb],false)
    }
    else if dateString >= timings.isha! {
        return (.fajr,[.dhur,.asr,.maghreb,.isha],true)
    }
    return (.fajr,[.dhur,.asr,.maghreb,.isha],false)
}
struct PrayerEntry:TimelineEntry{
    var date: Date
    var nextPrayer:Prayer?
    var otherPrayers:[Prayer]?
    var timings:prayerTimeTiming?
    init(date:Date,timings:prayerTimeTiming) {
        self.date = date
        self.timings = timings
        let prayersOrder = detectNextPrayer(timings: timings)
        self.nextPrayer = Prayer(name: prayersOrder.0.rawValue, time: timingMapper(timings: timings, prayer: prayersOrder.0), imageName: getImageName(prayer: prayersOrder.0), prayerType: prayersOrder.0)
        self.otherPrayers = [
            Prayer(name: prayersOrder.1[0].rawValue, time: timingMapper(timings: timings, prayer: prayersOrder.1[0]), imageName: getImageName(prayer: prayersOrder.1[0]), prayerType: prayersOrder.1[0])
            ,Prayer(name: prayersOrder.1[1].rawValue, time: timingMapper(timings: timings, prayer: prayersOrder.1[1]), imageName: getImageName(prayer: prayersOrder.1[1]), prayerType: prayersOrder.1[1])
            ,Prayer(name: prayersOrder.1[2].rawValue, time: timingMapper(timings: timings, prayer: prayersOrder.1[2]), imageName: getImageName(prayer: prayersOrder.1[2]), prayerType: prayersOrder.1[2])
            ,Prayer(name: prayersOrder.1[3].rawValue, time: timingMapper(timings: timings, prayer: prayersOrder.1[3]), imageName: getImageName(prayer: prayersOrder.1[3]), prayerType: prayersOrder.1[3])]
    }
    init(date:Date,nextPrayer:Prayer,otherPrayers:[Prayer]) {
        self.date = date
        self.nextPrayer = nextPrayer
        self.otherPrayers = otherPrayers
    }
    
}

struct Provider:TimelineProvider{
    let prayerProvide = MoyaProvider<PrayerServices>()
    let widgetLocationManager = WidgetLocationManager()
    
    func placeholder(in context: Context) -> PrayerEntry {
        let entry = PrayerEntry(date: Date(), nextPrayer: Prayer(name: "الفجر", time: "4:30", imageName: "sunrise", prayerType: .fajr), otherPrayers: [Prayer(name: "الظهر", time: "12:00", imageName: "sun", prayerType: .dhur),Prayer(name: "العصر", time: "15:00", imageName: "sun", prayerType: .asr),Prayer(name: "المغرب", time: "18:00", imageName: "sunset", prayerType: .maghreb),Prayer(name: "العشاء", time: "19:30", imageName: "moon", prayerType: .isha)])
        return entry
    }
    
    
    
    
    
    func getSnapshot(in context: Context, completion: @escaping (PrayerEntry) -> Void) {
        let entry = PrayerEntry(date: Date(), nextPrayer: Prayer(name: "الفجر", time: "4:30", imageName: "sunrise", prayerType: .fajr), otherPrayers: [Prayer(name: "الظهر", time: "12:00", imageName: "sun", prayerType: .dhur),Prayer(name: "العصر", time: "15:00", imageName: "sun", prayerType: .asr),Prayer(name: "المغرب", time: "18:00", imageName: "sunset", prayerType: .maghreb),Prayer(name: "العشاء", time: "19:30", imageName: "moon", prayerType: .isha)])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<PrayerEntry>) -> Void) {
        print("hello")
        let defaults = UserDefaults.standard
        
        widgetLocationManager.fetchLocation(handler: { location in
            print(location)
            prayerProvide.request(.getPrayersByLatLong(lat: String(location.coordinate.latitude), long: String(location.coordinate.longitude), tomorrow: false)) { (result) in
                print("result is \(result)")
                switch result{
                case .success(let response):
                    let decoder = JSONDecoder()
                    do{
                        let prayerModel = try decoder.decode(prayerTimeModel.self, from: response.data)
                        let timing = prayerModel.data?.timings
                        let firstEntry = PrayerEntry(date: Date(), timings: timing!)
                        let nextprayer = detectNextPrayer(timings: timing!).0
                        let tomorrow = detectNextPrayer(timings: timing!).2
                        if !tomorrow{
                            let nextPrayerTiming = timingMapper(timings: timing!, prayer: nextprayer)
                            let dateformatter = DateFormatter()
                            dateformatter.dateStyle = .none
                            dateformatter.dateFormat = "HH:mm"
                            defaults.setValue(timing!.fajr, forKey: "fajr")
                            defaults.setValue(timing!.dhuhr, forKey: "dhur")
                            defaults.setValue(timing!.asr, forKey: "asr")
                            defaults.setValue(timing!.maghrib, forKey: "maghrib")
                            defaults.setValue(timing!.isha, forKey: "isha")
                            let nextPrayerDate = dateformatter.date(from: nextPrayerTiming)
                            let secondEntry = PrayerEntry(date: nextPrayerDate!, timings: timing!)
                            let timeline = Timeline(entries:[firstEntry,secondEntry],policy : .after(nextPrayerDate!))
                            completion(timeline)
                        }else{
                            prayerProvide.request(.getPrayersByLatLong(lat: String(location.coordinate.latitude), long: String(location.coordinate.longitude), tomorrow: true)) { (result) in
                                switch result{
                                case .success(let response):
                                    print(response.response)
                                    do{
                                        let prayerModel = try decoder.decode(prayerTimeModel.self, from: response.data)
                                        let timing = prayerModel.data?.timings
                                        let firstEntry = PrayerEntry(date: Date(), timings: timing!)
                                        let nextprayer = detectNextPrayer(timings: timing!).0
                                        let nextPrayerTiming = timingMapper(timings: timing!, prayer: nextprayer)
                                        let dateformatter = DateFormatter()
                                        dateformatter.dateStyle = .none
                                        dateformatter.dateFormat = "HH:mm"
                                        defaults.setValue(timing!.fajr, forKey: "fajr")
                                        defaults.setValue(timing!.dhuhr, forKey: "dhur")
                                        defaults.setValue(timing!.asr, forKey: "asr")
                                        defaults.setValue(timing!.maghrib, forKey: "maghrib")
                                        defaults.setValue(timing!.isha, forKey: "isha")
                                        let nextPrayerDate = dateformatter.date(from: nextPrayerTiming)
                                        let secondEntry = PrayerEntry(date: nextPrayerDate!, timings: timing!)
                                        let timeline = Timeline(entries:[firstEntry,secondEntry],policy : .after(nextPrayerDate!))
                                        completion(timeline)
                                    }catch{
                                        print(error.localizedDescription)
                                    }
                                case .failure(_):
                                    completion(failureHandler())
                                }
                            }
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                case .failure( _):
                   
                    completion(failureHandler())
                }
                
            }
            
        })
        
    }
    private func failureHandler()->Timeline<PrayerEntry>{
        let defaults = UserDefaults.standard
        let fajr:String = (defaults.value(forKey: "fajr") ?? "NaN") as! String
        let dhur:String = (defaults.value(forKey: "dhur") ?? "NaN") as! String
        let asr:String = (defaults.value(forKey: "asr") ?? "NaN") as! String
        let maghrib:String = (defaults.value(forKey: "maghrib") ?? "NaN") as! String
        let isha:String = (defaults.value(forKey: "isha") ?? "NaN") as! String
        let timings = prayerTimeTiming(fajr: fajr, dhur: dhur, asr: asr, maghreb: maghrib, isha: isha)
        let entry = PrayerEntry(date: Date(), timings: timings)
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())
        let timeline = Timeline(entries:[entry],policy : .after(nextUpdate!))
        return timeline
    }

    
    
    typealias Entry = PrayerEntry
    
    
}


struct WidgetEntryView:View {
    @Environment(\.widgetFamily) var family
    
    let entry : Provider.Entry
    
    struct widgetView:View{
        var entry:Provider.Entry
        var body: some View{
            VStack{
                NextPrayerView(prayer: entry.nextPrayer!, currentPrayerType: entry.nextPrayer!.prayerType)
                HStack{
                    OtherPrayersView(prayer: entry.otherPrayers![0], currentPrayerType: entry.nextPrayer!.prayerType)
                    OtherPrayersView(prayer: entry.otherPrayers![1], currentPrayerType: entry.nextPrayer!.prayerType)
                    OtherPrayersView(prayer: entry.otherPrayers![2], currentPrayerType: entry.nextPrayer!.prayerType)
                    OtherPrayersView(prayer: entry.otherPrayers![3], currentPrayerType: entry.nextPrayer!.prayerType)
                }.environment(\.layoutDirection, .rightToLeft)
            }
        }
    }
    struct smallWidgetView:View{
        var entry:Provider.Entry
        var body: some View{
            VStack{
                NextPrayerView(prayer: entry.nextPrayer!, currentPrayerType: entry.nextPrayer!.prayerType)
               .environment(\.layoutDirection, .rightToLeft)
            }
        }
    }
    @ViewBuilder
    fileprivate func styleWidget()->some View {
        switch family{
        case .systemSmall:
            smallWidgetView(entry: entry)
        case .systemMedium:
            widgetView(entry: entry)
        case .systemLarge:
            widgetView(entry: entry)
            
        }
    }
    
    var body: some View{
        styleWidget()
        
        
    }
    
}

@main
struct PrayersWidget: Widget {
    let kind: String = "PrayersWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetEntryView(entry:entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Image(getBackgroundImageName(prayer: entry.nextPrayer!)).resizable().scaledToFill())
            
        }
    }
}


struct TestWidget_Previews: PreviewProvider {
    
    static var previews: some View {
        WidgetEntryView(entry:PrayerEntry(date: Date(), nextPrayer: Prayer(name: "الفجر", time: "4:30", imageName: "sunrise", prayerType: .fajr), otherPrayers: [Prayer(name: "الظهر", time: "12:00", imageName: "sun", prayerType: .dhur),Prayer(name: "العصر", time: "15:00", imageName: "sun", prayerType: .asr),Prayer(name: "المغرب", time: "18:00", imageName: "sunset", prayerType: .maghreb),Prayer(name: "العشاء", time: "19:30", imageName: "moon", prayerType: .isha)])).previewContext(WidgetPreviewContext(family: .systemMedium))
        
    }
}
