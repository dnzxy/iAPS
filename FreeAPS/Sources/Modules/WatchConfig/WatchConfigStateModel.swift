import ConnectIQ
import SwiftUI

enum AwConfig: String, JSON, CaseIterable, Identifiable, Codable {
    var id: String { rawValue }
    case HR
    case BGTarget
    case steps
    case isf
    case override

    var displayName: String {
        switch self {
        case .BGTarget:
            return NSLocalizedString("Glucose Target", comment: "")
        case .HR:
            return NSLocalizedString("Heart Rate", comment: "")
        case .steps:
            return NSLocalizedString("Steps", comment: "")
        case .isf:
            return NSLocalizedString("ISF", comment: "")
        case .override:
            return NSLocalizedString("% Override", comment: "")
        }
    }
}

enum AwPresetButtonSelection: String, JSON, CaseIterable, Identifiable, Codable {
    var id: String { rawValue }
    case tempTarget
    case profileOverride

    var displayName: String {
        switch self {
        case .tempTarget:
            return NSLocalizedString("Temp Targets", comment: "")
        case .profileOverride:
            return NSLocalizedString("Profiles", comment: "")
        }
    }
}

extension WatchConfig {
    final class StateModel: BaseStateModel<Provider> {
        @Injected() private var garmin: GarminManager!
        @Published var devices: [IQDevice] = []
        @Published var selectedAwConfig: AwConfig = .HR
        @Published var displayFatAndProteinOnWatch = false
        @Published var selectedAwPresetButton: AwPresetButtonSelection = .tempTarget

        private(set) var preferences = Preferences()

        override func subscribe() {
            preferences = provider.preferences

            subscribeSetting(\.displayFatAndProteinOnWatch, on: $displayFatAndProteinOnWatch) { displayFatAndProteinOnWatch = $0 }
            subscribeSetting(\.displayOnWatch, on: $selectedAwConfig) { selectedAwConfig = $0 }
            didSet: { [weak self] value in
                // for compatibility with old displayHR
                switch value {
                case .HR:
                    self?.settingsManager.settings.displayHR = true
                default:
                    self?.settingsManager.settings.displayHR = false
                }
            }
            subscribeSetting(\.watchPresetButtonSelection, on: $selectedAwPresetButton) { selectedAwPresetButton = $0 }

            devices = garmin.devices
        }

        func selectGarminDevices() {
            garmin.selectDevices()
                .receive(on: DispatchQueue.main)
                .weakAssign(to: \.devices, on: self)
                .store(in: &lifetime)
        }

        func deleteGarminDevice() {
            garmin.updateListDevices(devices: devices)
        }
    }
}
