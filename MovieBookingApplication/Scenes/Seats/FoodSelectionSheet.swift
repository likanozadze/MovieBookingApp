//
//  FoodSelectionSheet.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/21/24.
//
import SwiftUI
import Lottie


protocol FoodSelectionDelegate: AnyObject {
  func didPressBuySnacks()
}
struct FoodSelectionSheet: View {
    @Environment(\.presentationMode) var presentationMode
    let animationName = "popCorn"

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                LottieView(animationName: animationName)
                    .frame(width: 150, height: 150)
            
                Text("Would you like to buy snacks before your movie?")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                    Button("Buy snacks") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.customAccentColor)
                    .cornerRadius(10)
                    
                    Button("Skip") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.gray)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                }
            }
            .padding()
            .presentationDetents([.fraction(0.5)])
        }
    }

