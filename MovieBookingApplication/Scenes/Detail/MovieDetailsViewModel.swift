//
//  MovieDetailsViewModel.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/12/24.
//

import UIKit

protocol MovieDetailsViewModelDelegate: AnyObject {
    func movieDetailsFetched(_ movie: MovieDetails)
    func showError(_ error: Error)
    func movieDetailsImageFetched(_ image: UIImage)
    func timeSlotsFetched(_ timeSlots: [TimeSlot])
}

protocol MovieDetailsViewModel {
    var delegate: MovieDetailsViewModelDelegate? { get set }
    func viewDidLoad()
    func fetchTimeSlots(for date: Date)
}

final class DefaultMovieDetailsViewModel: MovieDetailsViewModel {
    private var movieId: Int
    
    weak var delegate: MovieDetailsViewModelDelegate?
    
    init(movieId: Int) {
        self.movieId = movieId
    }
    
    func viewDidLoad() {
        fetchMovieDetails()
    }
    
    private func fetchMovieDetails() {
        Task {
            do {
                let movieDetails = try await NetworkManager.shared.fetchMovieDetails(for: movieId)
                delegate?.movieDetailsFetched(movieDetails)
                downloadImage(from: movieDetails.posterPath)
            } catch let error {
                delegate?.showError(error)
            }
        }
    }
    
    private func downloadImage(from url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            self?.delegate?.movieDetailsImageFetched(image ?? UIImage())
        }
    }
    
    func fetchTimeSlots(for date: Date) {
            let timeSlots = ShowTime.allCases.map { showTime in
                let ticketPriceCategory: TicketPriceCategory
                switch showTime {
                case .afternoon1:
                    ticketPriceCategory = .afternoon1
                case .afternoon2:
                    ticketPriceCategory = .afternoon2
                case .evening:
                    ticketPriceCategory = .evening
                case .night1:
                    ticketPriceCategory = .night1
                case .night2:
                    ticketPriceCategory = .night2
                }
                let ticketPrices = [TicketPrice(priceCategory: ticketPriceCategory, currency: "USD")]
                return TimeSlot(date: date, showTime: showTime, ticketPrices: ticketPrices)
            }
            delegate?.timeSlotsFetched(timeSlots)
        }
    }
