//
//  Ticket+CoreDataProperties.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 8/2/24.
//
//

import Foundation
import CoreData


extension Ticket {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ticket> {
        return NSFetchRequest<Ticket>(entityName: "Ticket")
    }

    @NSManaged public var movieTitle: String?
    @NSManaged public var date: Date?
    @NSManaged public var timeSlot: String?
    @NSManaged public var seats: String?
    @NSManaged public var snacks: String?
    @NSManaged public var totalPrice: Double
    @NSManaged public var id: String?
    @NSManaged public var posterPath: String?

}

extension Ticket : Identifiable {

}
