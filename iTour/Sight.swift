//
//  Sight.swift
//  iTour
//
//  Created by SCOTT CROWDER on 11/21/23.
//

import Foundation
import SwiftData

@Model
final class Sight {
    var name: String
    
    var destination: Destination?
    
    init(name: String) {
        self.name = name
    }
}
