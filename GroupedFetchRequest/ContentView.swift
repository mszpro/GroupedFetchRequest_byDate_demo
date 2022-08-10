//
//  ContentView.swift
//  GroupedFetchRequest
//
//  Created by Sora on 2022/08/09.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @SectionedFetchRequest<String, Item>(
        sectionIdentifier: \.dateText,
        sortDescriptors: [SortDescriptor(\.date, order: .reverse)]
    )
    private var itemSections: SectionedFetchResults<String, Item>
    
    @State private var userSelectedDate: Date = Date()
    @State private var userEnteredContent: String = ""

    var body: some View {
        
        NavigationStack {
            
            Form {
                
                Section("Add new item") {
                    DatePicker("Date", selection: $userSelectedDate, displayedComponents: [.date])
                    TextField("Name", text: $userEnteredContent)
                    Button("Create") {
                        let newRecord = Item(context: viewContext)
                        newRecord.content = self.userEnteredContent
                        newRecord.date = self.userSelectedDate
                        try? viewContext.save()
                    }
                }
                
                ForEach(itemSections) { itemSection in
                    Section(itemSection.id) {
                        ForEach(itemSection) { itemEntry in
                            VStack(alignment: .leading) {
                                Text(itemEntry.content ?? "")
                                    .font(.headline)
                                Text(itemEntry.dateText)
                            }
                        }
                    }
                }
                
            }
            
        }
        
    }

}

extension Item {
    @objc
    var dateText: String {
        guard let date = self.date else {
            return "Unknown"
        }
        return DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
    }
}
