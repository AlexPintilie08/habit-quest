import AVFAudio
import SwiftUI
import UIKit

enum TemaAplicatie: String, CaseIterable, Identifiable {
    case sistem
    case light
    case dark

    var id: String { rawValue }

    var titlu: String {
        switch self {
        case .sistem: "Sistem"
        case .light: "Light"
        case .dark: "Dark"
        }
    }

    var schemaCulori: ColorScheme? {
        switch self {
        case .sistem: nil
        case .light: .light
        case .dark: .dark
        }
    }
}

struct EcranSetari: View {
    @AppStorage("efecteSonoreActive") private var efecteSonoreActive = true
    @AppStorage("vibratiiActive") private var vibratiiActive = true
    @AppStorage("temaAplicatie") private var temaAplicatie = TemaAplicatie.sistem.rawValue
    @AppStorage("animatiiActive") private var animatiiActive = true
    @State private var playerAudio: AVAudioPlayer?

    var body: some View {
        NavigationStack {
            Form {
                Section("Sunet si feedback") {
                    Toggle("Efecte sonore", isOn: $efecteSonoreActive)
                    Toggle("Vibratii", isOn: $vibratiiActive)

                    Button("Testeaza sunet", action: testeazaSunet)
                        .disabled(!efecteSonoreActive)

                    Button("Testeaza vibratia", action: testeazaVibratia)
                        .disabled(!vibratiiActive)
                }

                Section("Aspect") {
                    Picker("Tema", selection: $temaAplicatie) {
                        ForEach(TemaAplicatie.allCases) { tema in
                            Text(tema.titlu).tag(tema.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Animatii") {
                    Toggle("Animatii", isOn: $animatiiActive)
                }

                Section("Aplicatie") {
                    NavigationLink("Despre Habit Quest") {
                        EcranDespre()
                    }
                }
            }
            .navigationTitle("Setari")
        }
    }

    private func testeazaSunet() {
        guard efecteSonoreActive,
              let url = Bundle.main.url(forResource: "SunetTest", withExtension: "wav") else { return }

        do {
            let sesiune = AVAudioSession.sharedInstance()
            try sesiune.setCategory(.ambient, options: .mixWithOthers)
            try sesiune.setActive(true)

            playerAudio = try AVAudioPlayer(contentsOf: url)
            playerAudio?.volume = 0.24
            playerAudio?.play()
        } catch {
            playerAudio = nil
        }
    }

    private func testeazaVibratia() {
        guard vibratiiActive else { return }

        let feedback = UIImpactFeedbackGenerator(style: .light)
        feedback.prepare()
        feedback.impactOccurred()
    }
}

private struct EcranDespre: View {
    private var versiune: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    private var build: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }

    var body: some View {
        Form {
            Section("Aplicatie") {
                LabeledContent("Nume", value: "Habit Quest")

                if let versiune {
                    LabeledContent("Versiune", value: versiune)
                }

                if let build {
                    LabeledContent("Build", value: build)
                }
            }

            Section("Despre proiect") {
                Text("Habit Quest transforma formarea obiceiurilor intr-o aventura de zi cu zi.")
            }
        }
        .navigationTitle("Despre Habit Quest")
    }
}
