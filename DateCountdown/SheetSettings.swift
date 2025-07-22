//
//  SheetSettings.swift
//  DateCountdown
//
//  Created by Jordan on 06.07.2025.
//

import SwiftUI

struct SheetSettings: View {
    @AppStorage("startDate") private var startDate: Date = .now
    @AppStorage("endDate") private var endDate: Date = .now

    @Binding var workDays: [String]

    private let days = DateFormatter().weekdaySymbols

    var body: some View {
        List {
            DatePicker("Start date", selection: $startDate)
            DatePicker("End date", selection: $endDate)

            if let days {
                Section("Workdays") {
                    ForEach(days, id: \.self) { workDay in
                        Button {
                            toggleWorkDay(workDay)
                        } label: {
                            HStack {
                                Text(workDay)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Image(systemName: workDays.contains(workDay) ? "checkmark" : "")
                            }
                        }
                    }
                }
            }
        }
    }

    private func toggleWorkDay(_ workDay: String) {
        if let index = workDays.firstIndex(of: workDay) {
            workDays.remove(at: index)
        } else {
            workDays.append(workDay)
        }
    }
}
