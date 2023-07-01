//
//  NetworkManager.swift
//  FunSeeker
//
//  Created by Chris Kocabas on 2023-05-25.
//

import Foundation
import Network

class NetworkManager: ObservableObject {

  private let monitor = NWPathMonitor()
  private let queue = DispatchQueue(label: "NetworkManager")

  // Published properties to track network status and connection information
  @Published var isActive = false
  @Published var isExpensive = false
  @Published var isConstrained = false
  @Published var connectionType = NWInterface.InterfaceType.other

  // Computed property to display connection status description
  var connectionDescription: String {
    if isActive {
      return "Connected to the internet."
    } else {
      return "No internet connection."
    }
  }

  init() {
    // Define the pathUpdateHandler closure to update the network status properties
    monitor.pathUpdateHandler = { path in
      DispatchQueue.main.async {
        // Update isActive based on network status
        self.isActive = path.status == .satisfied

        // Update isExpensive and isConstrained based on network cost
        self.isExpensive = path.isExpensive
        self.isConstrained = path.isExpensive

        // Determine the connection type and update connectionType property
        let connectionTypes: [NWInterface.InterfaceType] = [.cellular, .wifi, .wiredEthernet]
        self.connectionType = connectionTypes.first(where: path.usesInterfaceType) ?? .other

        // Print the connection description for debugging purposes
        print("\(self.connectionDescription)")
      }
    }

    // Start the network monitor on the specified queue
    monitor.start(queue: queue)
  }
}
