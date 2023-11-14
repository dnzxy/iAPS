import SwiftUI

struct ProfilePresetsView: View {
    @EnvironmentObject var state: WatchStateModel

    var body: some View {
        List {
            if state.profileOverridePresets.isEmpty {
                Text("Set profile presets on iPhone first").padding()
            } else {
                ForEach(state.profileOverridePresets.filter({ $0.id != "" })) { preset in
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
                state.enactProfileOverridePreset(id: "cancel")
            } label: {
                Text("Cancel Profile")
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
        let percent = (preset.percentage ?? 100) / 100
        if preset.id != "" && preset.name != "" {
            VStack {
                Text(preset.name)
                    .font(.headline)
                Spacer()
                VStack(alignment: .leading, spacing: 2) {
                    if let targetFormatted = preset.targetFormatted, targetFormatted != "" {
                        Text(targetFormatted)
                    }

                    Text(
                        "\(percent.formatted(.percent.grouping(.never).rounded().precision(.fractionLength(0)))), \(preset.duration?.formatted() ?? "")min"
                    )

                    if preset.smbIsOff ?? false && preset.smbIsAlwaysOff ?? false {
                        Text("Scheduled SMBs")
                    }

                    if preset.smbIsOff ?? false && !(preset.smbIsAlwaysOff ?? false) {
                        Text("SMBs are off")
                    }

                    if preset.advancedSettings ?? false {
                        if let smbMinutes = preset.smbMinutes, let uamMinutes = preset.uamMinutes,
                           smbMinutes > 0 || uamMinutes > 0
                        {
                            if smbMinutes > 0 && uamMinutes > 0 {
                                Text("\(smbMinutes.formatted()) SMB, \(uamMinutes.formatted()) UAM")
                            } else if smbMinutes > 0 {
                                Text("\(smbMinutes.formatted()) SMB")
                            } else if uamMinutes > 0 {
                                Text("\(uamMinutes.formatted()) UAM")
                            }
                        }

                        if preset.isf ?? false && preset.cr ?? false {
                            Text("ISF/CR")
                        } else if preset.isf ?? false {
                            Text("ISF")
                        } else if preset.cr ?? false {
                            Text("CR")
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.secondary)
                .font(.caption)
            }
            .padding()
        }
    }
}

struct ProfilePresetsView_Previews: PreviewProvider {
    static var previews: some View {
        let model = WatchStateModel()
        model.profileOverridePresets = [
            ProfileOverrideWatchPreset(
                id: UUID().uuidString,
                name: "Test Profile",
                date: Date(),
                duration: 60,
                start: nil,
                end: nil,
                percentage: 100,
                target: 100,
                targetFormatted: "5.5 mmol/L",
                smbMinutes: 90,
                uamMinutes: 90,
                advancedSettings: false,
                cr: false,
                indefinite: false,
                isf: false,
                isfAndCr: false,
                smbIsAlwaysOff: false,
                smbIsOff: false
            )
        ]
        return ProfilePresetsView().environmentObject(model)
    }
}
