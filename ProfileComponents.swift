import SwiftUI

// 1. Cabecera del Paciente
struct PatientHeaderCard: View {
    var onViewExpedient: () -> Void
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Carlos Mendoza").font(.title.bold())
                Text("ID: #PAT-88291").font(.caption).foregroundColor(.dtMutedFg)
            }
            Spacer()
            Button(action: onViewExpedient) {
                Text("Ver Expediente").font(.caption).bold()
                    .padding(.horizontal, 12).padding(.vertical, 8)
                    .background(Color.dtPrimary).foregroundColor(.white).cornerRadius(8)
            }
        }
        .padding().cardStyle()
    }
}

// 2. Cabecera del Doctor
struct DoctorHeaderCard: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Dra. Claudia Ramírez").font(.title.bold())
                Text("Radiología Diagnóstica").font(.subheadline).foregroundColor(.dtPrimary)
            }
            Spacer()
        }
        .padding().cardStyle()
    }
}

// 3. Tarjeta de Signos Vitales
struct VitalSignBox: View {
    let label, value, icon: String
    let color: Color
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon).foregroundColor(color)
            Text(label).font(.caption).foregroundColor(.dtMutedFg)
            Text(value).font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding().background(Color.dtSecondary.opacity(0.3)).cornerRadius(10)
    }
}

// 4. Tarjeta Contenedora Genérica
struct InfoCard<Content: View>: View {
    let title, icon: String
    let content: Content
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Label(title, systemImage: icon).font(.headline)
            content
        }
        .padding().frame(maxWidth: .infinity, alignment: .leading).cardStyle()
    }
}

// 5. Filas de contacto y Etiquetas
struct ContactRow: View {
    let icon, label, value: String
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon).foregroundColor(.dtPrimary).frame(width: 20)
            VStack(alignment: .leading) {
                Text(label).font(.caption).foregroundColor(.dtMutedFg)
                Text(value).font(.system(size: 14, weight: .medium))
            }
        }
    }
}

struct TagView: View {
    let text: String
    let color: Color
    var body: some View {
        Text(text).font(.caption2).bold().padding(.horizontal, 8).padding(.vertical, 4)
            .background(color.opacity(0.1)).foregroundColor(color).cornerRadius(4)
    }
}

// 6. Tarjeta de Nota de Expediente
struct ExpedientNoteCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Estudio Radiológico").font(.caption).bold().foregroundColor(.dtPrimary)
            Text("Rx Tórax PA — Seguimiento").font(.headline)
            Text("Campos pulmonares sin condensaciones. Silueta cardíaca normal.").font(.subheadline).foregroundColor(.dtMutedFg)
        }
        .padding().cardStyle()
    }
}
