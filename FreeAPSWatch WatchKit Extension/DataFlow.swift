import Foundation

struct WatchState: Codable {
    var glucose: String?
    var trend: String?
    var trendRaw: String?
    var delta: String?
    var glucoseDate: Date?
    var glucoseDateInterval: UInt64?
    var lastLoopDate: Date?
    var lastLoopDateInterval: UInt64?
    var bolusIncrement: Decimal?
    var maxCOB: Decimal?
    var maxBolus: Decimal?
    var carbsRequired: Decimal?
    var bolusRecommended: Decimal?
    var iob: Decimal?
    var cob: Decimal?
    var tempTargets: [TempTargetWatchPreset] = []
    var bolusAfterCarbs: Bool?
    var eventualBG: String?
    var eventualBGRaw: String?
    var displayOnWatch: AwConfig?
    var displayFatAndProteinOnWatch: Bool?
    var useNewCalc: Bool?
    var isf: Decimal?
    var override: String?
    var profileOverridePresets: [ProfileOverrideWatchPreset] = []
}

struct TempTargetWatchPreset: Codable, Identifiable {
    let name: String
    let id: String
    let description: String
    let until: Date?
}

struct ProfileOverrideWatchPreset: Codable, Identifiable {
    let id: String
    let name: String
    let date: Date
    let duration: Decimal?
    let start: Decimal?
    let end: Decimal?
    let percentage: Double?
    let target: Decimal?
    let targetFormatted: String?
    let smbMinutes: Decimal?
    let uamMinutes: Decimal?
    let advancedSettings: Bool?
    let cr: Bool?
    let indefinite: Bool?
    let isf: Bool?
    let isfAndCr: Bool?
    let smbIsAlwaysOff: Bool?
    let smbIsOff: Bool?
}
