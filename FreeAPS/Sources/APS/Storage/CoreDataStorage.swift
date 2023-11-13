import CoreData
import Foundation
import SwiftDate
import Swinject

final class CoreDataStorage {
    let coredataContext = CoreDataStack.shared.persistentContainer.viewContext // newBackgroundContext()

    func fetchGlucose(interval: NSDate) -> [Readings] {
        var fetchGlucose = [Readings]()
        coredataContext.performAndWait {
            let requestReadings = Readings.fetchRequest() as NSFetchRequest<Readings>
            let sort = NSSortDescriptor(key: "date", ascending: false)
            requestReadings.sortDescriptors = [sort]
            requestReadings.predicate = NSPredicate(
                format: "glucose > 0 AND date > %@", interval
            )
            try? fetchGlucose = self.coredataContext.fetch(requestReadings)
        }
        return fetchGlucose
    }

    func fetchLatestOverride() -> [Override] {
        var overrideArray = [Override]()
        coredataContext.performAndWait {
            let requestOverrides = Override.fetchRequest() as NSFetchRequest<Override>
            let sortOverride = NSSortDescriptor(key: "date", ascending: false)
            requestOverrides.sortDescriptors = [sortOverride]
            requestOverrides.fetchLimit = 1
            try? overrideArray = self.coredataContext.fetch(requestOverrides)
        }
        return overrideArray
    }

    func fetchProfileOverridePresets() -> [OverridePresets] {
        var profileOverridePresets = [OverridePresets]()
        coredataContext.performAndWait {
            let overridePresets = OverridePresets.fetchRequest() as NSFetchRequest<OverridePresets>
            try? profileOverridePresets = self.coredataContext.fetch(overridePresets)
        }
        return profileOverridePresets
    }
}
