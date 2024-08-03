//
//  CoreDataManager.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 8/2/24.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    var persistentContainer: NSPersistentContainer
    
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.persistentContainer = appDelegate.persistentContainer
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func createTicket(movieTitle: String, date: Date, timeSlot: TimeSlot, seats: [Seat], snacks: [OrderedFood], totalPrice: Double, posterPath: String?) {
        let context = persistentContainer.viewContext
        let ticket = Ticket(context: context)
        ticket.movieTitle = movieTitle
        ticket.date = date
        ticket.timeSlot = timeSlot.showTime.formattedTime
        ticket.seats = seats.map { $0.seatCode }.joined(separator: ", ")
        ticket.snacks = snacks.map { "\($0.quantity)x \($0.food.name) (\($0.size.name))" }.joined(separator: ", ")
        ticket.totalPrice = totalPrice
        ticket.posterPath = posterPath
        
        do {
            try context.save()
            print("Debug - Ticket saved to Core Data: \(movieTitle)")
        } catch {
            print("Debug - Failed to save ticket: \(error)")
        }
    }
    
    func fetchTickets() -> [Ticket] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Ticket> = Ticket.fetchRequest()
        
        do {
            let tickets = try context.fetch(fetchRequest)
            print("Debug - Fetched \(tickets.count) tickets from Core Data")
            return tickets
        } catch {
            print("Debug - Failed to fetch tickets: \(error)")
            return []
        }
    }
}
