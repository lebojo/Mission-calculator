//
//  ContentView.swift
//  DateCountdown
//
//  Created by Jordan on 06.07.2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("startDate") private var startDate: Date = .now
    @AppStorage("endDate") private var endDate: Date = .now

    @State private var workDays: [String] = []
    @State private var showSettings = false

    private var daysDone: Int {
        Calendar.current.dateComponents([.day], from: startDate, to: .now).day ?? 0
    }

    private var workDaysDone: Int {
        calculateWorkDaysDone()
    }

    private var workDaysRemaining: Int {
        calculateWorkDaysRemaining()
    }

    private var totalDaysRemaining: Int {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        let endDateDay = calendar.startOfDay(for: endDate)

        return calendar.dateComponents([.day], from: startDate, to: endDateDay).day ?? 0
    }

    private var workDaysProgress: Double? {
        guard let totalDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day,
              let daysDone = Calendar.current.dateComponents([.day], from: startDate, to: .now).day else {
            return nil
        }
        guard totalDays > 0 else {
            return nil
        }
        return Double(daysDone) / Double(totalDays)
    }

    var body: some View {
        NavigationStack {
            List {
                VStack {
                    HStack {
                        VStack {
                            Text("\(workDaysDone)")
                                .font(.largeTitle)
                            Text("Workdays done")
                        }
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)

                        VStack {
                            Text("\(workDaysRemaining)")
                                .font(.largeTitle)
                            Text("Workdays remaining")
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding()
                    .multilineTextAlignment(.center)

                    if let workDaysProgress {
                        ProgressView(value: workDaysProgress)
                            .padding(.vertical)
                    }
                }

                Section("Global timers") {
                    Text("Days done: \(daysDone)")
                    Text("Days remaining: \(totalDaysRemaining)")
                    HStack {
                        Text("Total time remaining:")
                        Text(endDate, style: .relative)
                    }
                }
            }
            .animation(.default, value: workDays)
            .navigationTitle("Mission calculator")
            .toolbar {
                Button("Settings", systemImage: "gear") {
                    showSettings.toggle()
                }
            }
            .sheet(isPresented: $showSettings) {
                SheetSettings(workDays: $workDays)
                    .presentationDragIndicator(.visible)
            }
        }
    }

    private func calculateWorkDaysRemaining() -> Int {
        let cal = Calendar.current
        let start = cal.startOfDay(for: .now)
        let end = cal.startOfDay(for: endDate)

        guard end > start else { return 0 }

        let weekdays = Set(workDays.compactMap { cal.weekdaySymbols.firstIndex(of: $0).map { $0 + 1 } })
        let days = Int(end.timeIntervalSince(start) / 86400)

        return (0 ..< days).filter { weekdays.contains(cal.component(
            .weekday,
            from: cal.date(byAdding: .day, value: $0, to: start)!
        )) }.count
    }

    private func calculateWorkDaysDone() -> Int {
        let cal = Calendar.current
        let start = cal.startOfDay(for: startDate)
        let end = cal.startOfDay(for: .now)

        guard end > start else { return 0 }

        let weekdays = Set(workDays.compactMap { cal.weekdaySymbols.firstIndex(of: $0).map { $0 + 1 } })
        let days = Int(end.timeIntervalSince(start) / 86400)

        return (0 ..< days).filter { weekdays.contains(cal.component(
            .weekday,
            from: cal.date(byAdding: .day, value: $0, to: start)!
        )) }.count
    }
}

#Preview {
    ContentView()
}
