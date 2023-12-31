//
//  Destination.swift
//  iTour
//
//  Created by SCOTT CROWDER on 11/21/23.
//

import Foundation
import SwiftData

@Model
final class Destination {
    var name: String
    var details: String
    var date: Date
    var priority: Int
    
    var formatedDate: String {
        date.formatted(date: .long, time: .shortened)
    }
    
    @Relationship(deleteRule: .cascade, inverse: \Sight.destination) var sights = [Sight]()
    @Attribute(.externalStorage) var image: Data?
    
    init(name: String = "", details: String = "", date: Date = .now, priority: Int = 2) {
        self.name = name
        self.details = details
        self.date = date
        self.priority = priority
    }
}
