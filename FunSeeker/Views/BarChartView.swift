//
//  BarChartView.swift
//  FunSeeker
//
//  Created by Chris Kocabas on 2023-06-04.
//

import SwiftUI
import Charts

// Data for the bar chart
let data = [
  (price: "Free", val:30),
  (price: "Cheap", val:100),
  (price: "Fair", val:250),
  (price: "Med", val:500),
  (price: "Exp", val:750),
  (price: "Steep", val:1000)
]

struct BarChartView: View {

  // State variables for minimum and maximum values
  @State var min = Double()
  @State var max = Double()

  var body: some View {
    Chart{
      // Iterate through the data and create a BarMark for each entry
      ForEach(data, id: \.price) {
        BarMark(
          x: .value("Price", String($0.price.prefix(5))),
          y: .value("Value", $0.val)
        )
        .accessibilityLabel("\($0.val)")
      }
      .foregroundStyle(
        .linearGradient(
          colors: [.green,.green,.yellow, .red],
          startPoint: .leading,
          endPoint: .trailing
        )
      )
      .alignsMarkStylesWithPlotArea()

      // RuleMarks to represent minimum and maximum thresholds
      RuleMark(y: .value("Break Even Threshold", min))
        .foregroundStyle(.red)
      RuleMark(y: .value("Break Even Threshold", max))
        .foregroundStyle(.red)

    }
    .frame(height: 200)
    .padding()
  }
}

struct BarChartView_Previews: PreviewProvider {
  static var previews: some View {
    BarChartView()
  }
}
