//
//  iCoin_Widget.swift
//  iCoin-Widget
//
//  Created by 김윤석 on 2023/01/31.
//

import WidgetKit
import SwiftUI
import Intents

//위젯 새로 고침을 결정할 객체
struct Provider:
    IntentTimelineProvider {
    //아무런 데이터가 없을때 보여지는 위젯
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    // latest version of the widget
    // 현재 위젯이 어떻게 생겼는가
    // (위젯을 고를때 data가 apply된 예제로 위젯을 볼수 있다.)
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    // 타임라인은 array of entry라고 보면된다
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(
                byAdding: .minute,
                value: hourOffset,
                to: currentDate
            )!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
//        let refreshAfter = Calendar.current.date(
//            byAdding: .minute,
//            value: 1,
//            to: currentDate
//        )!
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct iCoin_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
            .foregroundColor(.red)
    }
}

struct iCoin_Widget: Widget {
    let kind: String = "iCoin_Widget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: Provider()
        ) { entry in
            iCoin_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        
//        StaticConfiguration(
//            kind: kind,
//            provider: Provider()
//        ) { entry in
//            iCoin_WidgetEntryView(entry: entry)
//        }
//        .configurationDisplayName("My Widget")
//        .description("This is an example widget.")
    }
}

struct iCoin_Widget_Previews: PreviewProvider {
    static var previews: some View {
        iCoin_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
