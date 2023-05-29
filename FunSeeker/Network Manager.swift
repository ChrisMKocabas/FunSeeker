//
//  Network Manager.swift
//  FunSeeker
//
//  Created by Chris Kocabas on 2023-05-25.
//

import Foundation
import Network

class NetworkManager: ObservableObject{

  private let monitor = NWPathMonitor()
  private let queue = DispatchQueue(label: "NetworkManager")
  @Published var isActive = false
  @Published var isExpensive = false
  @Published var isConstrained = false
  @Published var connectionType = NWInterface.InterfaceType.other


  var connectionDescription: String{
    if isActive{
      return "Connected to the internet."
    } else {
      return "No internet connection."
    }
  }

  init(){
    monitor.pathUpdateHandler = { path in
      DispatchQueue.main.async {
        self.isActive = path.status == .satisfied
        self.isExpensive = path.isExpensive
        self.isConstrained = path.isExpensive
        let connectionTypes: [NWInterface.InterfaceType] = [.cellular,.wifi,.wiredEthernet]
        self.connectionType = connectionTypes.first(where: path.usesInterfaceType) ?? .other

        print("\(self.connectionDescription)")
      }
    }

    monitor.start(queue: queue)
  }

}
