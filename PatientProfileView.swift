import SwiftUI

struct PatientProfileView: View {
    var onBack: () -> Void
    var onViewExpedient: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                PatientHeaderCard(onViewExpedient: onViewExpedient)

                VStack(alignment: .leading, spacing: 15) {
                    Label("Signos vitales detallados", systemImage: "waveform.path.ecg")
                        .font(.headline)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        VitalSignBox(label: "Presión arterial", value: "138/88 mmHg", icon: "heart.fill", color: .red)
                        VitalSignBox(label: "Frecuencia cardíaca", value: "74 bpm", icon: "bolt.heart.fill", color: .green)
                        VitalSignBox(label: "Temperatura", value: "36.4 °C", icon: "thermometer.medium", color: .blue)
                    }
                }
                .padding()
                .cardStyle()

                HStack(alignment: .top, spacing: 20) {
                    InfoCard(title: "Información personal", icon: "person.circle") {
                        ContactRow(icon: "envelope", label: "Email", value: "carlos.mendoza@email.com")
                        ContactRow(icon: "cross.case", label: "Seguro", value: "IMSS — #482-91-7034")
                    }
                    
                    InfoCard(title: "Alergias", icon: "exclamationmark.triangle") {
                        HStack {
                            TagView(text: "Penicilina", color: .orange)
                            TagView(text: "Aspirina", color: .orange)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color.dtBackground)
    }
}
