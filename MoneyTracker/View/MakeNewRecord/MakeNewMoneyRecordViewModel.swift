//
//  MakeNewMoneyRecordViewModel.swift
//  MoneyTracker
//
//  Created by Olha Bereziuk on 17.05.24.
//

import CoreData
import CoreHaptics

final class MakeNewMoneyRecordViewModel: ObservableObject {
    
    // MARK: - Properties -
    @Published var showCategoriesView = false
    @Published var newItem = MoneyModel(recordType: .expense, category: Category(name: "Select Category", iconName: "sun.min"), moneyAmount: "", description: "", currency: "EUR")
    @Published var engine: CHHapticEngine?
    
    // MARK: - Functions
    
    /// TODO: - FOR TESTING -> create records with past Date() -
    //let pastdate = Calendar.current.date(byAdding: .day, value: -2, to: .now)
    
    func saveNewRecord(_ context: NSManagedObjectContext) {
        
        if let intValue = Int64(self.newItem.moneyAmount),
           self.newItem.category.name != "Select Category" {
            
            Money.makeNewRecordWith(
                moneyAmount: intValue,
                currency: self.newItem.currency,
                isIncome: self.newItem.recordType == .income ? true : false,
                categoryName: self.newItem.category.name,
                categoryIcon: self.newItem.category.iconName,
                timestamp: Date(),
                notes: self.newItem.description,
                using: context
            )
        }
    }
}

// MARK: - Haptic Engine (Vibrations)
extension MakeNewMoneyRecordViewModel {
    
    func shortVibrate() {
        Constants.vibrate()
    }
    
    func prepareHaptics() {
        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("An error of creating the Haptics Engine: \(error.localizedDescription)")
        }
    }
    
    func longVibrate() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        var events = [CHHapticEvent]()
        
        // Create a continuous haptic event for a long vibration
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: 0.6)
        
        events.append(event)
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription)")
        }
    }
}
