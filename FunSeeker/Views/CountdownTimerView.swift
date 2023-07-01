//
//  CountdownTimer.swift
//  FunSeeker
//
//  Created by Chris Kocabas on 2023-06-04.


import SwiftUI

struct CountDownTimerView: View {

  // Current date state
  @State var nowDate: Date = Date()
  // Reference date for countdown
  let referenceDate: Date

  // Timer that updates the current date every second
  var timer: Timer {
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
      self.nowDate = Date()
    }
  }

  var body: some View {
    Text(countDownString(from: referenceDate))
      .font(.system(size: 16, weight: .light, design: .rounded))
      .onAppear(perform: {
        _ = self.timer // Start the timer when the view appears
      })
  }

  // Function to calculate the countdown string
  func countDownString(from date: Date) -> String {
    let calendar = Calendar(identifier: .gregorian)
    let components = calendar.dateComponents(
      [.day, .hour, .minute, .second],
      from: nowDate,
      to: referenceDate
    )
    return String(
      format: "%02dd:%02dh:%02dm:%02ds",
      components.day ?? 00,
      components.hour ?? 00,
      components.minute ?? 00,
      components.second ?? 00
    )
  }

}

struct CountdownTimerView_Previews: PreviewProvider {
  static var previews: some View {
    CountDownTimerView(referenceDate: Date())
  }
}
