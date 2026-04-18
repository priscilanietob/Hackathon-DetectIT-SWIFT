import SwiftUI

struct PatientExpedientView: View {
    var onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // barra superior
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                    Text("Volver al perfil")
                }
                Spacer()
                Text("Expediente: Carlos Mendoza").bold()
                Spacer()
            }
            .padding()
            .background(Color.dtCard)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ExpedientNoteCard()
                }
                .padding()
            }
        }
        .background(Color.dtBackground)
    }
}
