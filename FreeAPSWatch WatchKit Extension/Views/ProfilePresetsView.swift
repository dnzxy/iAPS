import SwiftUI

struct ProfilePresetsView: View {
    @EnvironmentObject var state: WatchStateModel

    var body: some View {
        List {
            if state.profileOverridePresets.isEmpty {
                Text("Set profile presets on iPhone first").padding()
            } else {
                ForEach(state.profileOverridePresets) { preset in
                    Button {
                        WKInterfaceDevice.current().play(.click)
                        state.enactProfileOverridePreset(id: preset.id)
                    } label: {
                        profileOverridePresetView(preset)
                    }
                }
            }

            Button {
                WKInterfaceDevice.current().play(.click)
                state.enactTempTarget(id: "cancel")
            } label: {
                Text("Cancel Profile Override")
            }
        }
        .navigationTitle("Profiles")
    }

    private var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }

    @ViewBuilder private func profileOverridePresetView(_ preset: ProfileOverrideWatchPreset) -> some View {
//                let target = state.units == .mmolL ? (((preset.target ?? 0) as NSDecimalNumber) as Decimal)
//                    .asMmolL : (preset.target ?? 0) as Decimal
        let duration = (preset.duration ?? 0) as Decimal
        let percent = (preset.percentage ?? 100) / 100
        let perpetual = preset.indefinite ?? false
        let durationString = perpetual ? "" : "\(formatter.string(from: duration as NSNumber)!)"
        let scheduledSMBstring = (preset.smbIsOff ?? false && preset.smbIsAlwaysOff ?? false) ? "Scheduled SMBs" : ""
        let smbString = (preset.smbIsOff ?? false && scheduledSMBstring == "") ? "SMBs are off" : ""
//                let targetString = target != 0 ? "\(glucoseFormatter.string(from: target as NSNumber)!)" : ""
        let maxMinutesSMB = (preset.smbMinutes as Decimal?) != nil ? (preset.smbMinutes ?? 0) as Decimal : 0
        let maxMinutesUAM = (preset.uamMinutes as Decimal?) != nil ? (preset.uamMinutes ?? 0) as Decimal : 0
        let isfString = preset.isf ?? false ? "ISF" : ""
        let crString = preset.cr ?? false ? "CR" : ""
        let dash = crString != "" ? "/" : ""
        let isfAndCRstring = isfString + dash + crString

        if preset.name != "" {
            HStack {
                VStack {
                    HStack {
                        Text(preset.name)
                        Spacer()
                    }
                    HStack(spacing: 5) {
                        Text(percent.formatted(.percent.grouping(.never).rounded().precision(.fractionLength(0))))
//                                if targetString != "" {
//                                    Text(targetString)
//                                    Text(targetString != "" ? state.units.rawValue : "")
//                                }
                        if durationString != "" { Text(durationString + (perpetual ? "" : "min")) }
                        if smbString != "" { Text(smbString).foregroundColor(.secondary).font(.caption) }
                        if scheduledSMBstring != "" { Text(scheduledSMBstring) }
                        if preset.advancedSettings ?? false {
                            Text(maxMinutesSMB == 0 ? "" : maxMinutesSMB.formatted() + " SMB")
                            Text(maxMinutesUAM == 0 ? "" : maxMinutesUAM.formatted() + " UAM")
                            Text(isfAndCRstring)
                        }
                        Spacer()
                    }
                    .padding(.top, 2)
                    .foregroundColor(.secondary)
                    .font(.caption)
                }
//                        .contentShape(Rectangle())
//                        .onTapGesture {
//                            state.selectProfile(id_: preset.id ?? "")
//                            state.hideModal()
//                        }
            }
        }
    }
}
