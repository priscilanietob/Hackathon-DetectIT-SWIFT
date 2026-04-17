import SwiftUI

struct DoctorProfileView: View {
    var onBack: () -> Void
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header con información básica
                DoctorHeaderCard()

                // Tabs de información (General, Actividad, Formación)
                HStack(spacing: 20) {
                    InfoCard(title: "Información de contacto", icon: "person.text.rectangle") {
                        ContactRow(icon: "envelope", label: "Email", value: authVM.userEmail)
                        ContactRow(icon: "phone", label: "Teléfono", value: "+52 664 210 3847")
                        ContactRow(icon: "mappin.and.ellipse", label: "Ubicación", value: "Tijuana, Baja California")
                    }
                    
                    InfoCard(title: "Acerca del médico", icon: "book") {
                        Text("Especialista en radiodiagnóstico con enfoque en detección temprana de enfermedades pulmonares. Formada en el IMSS con subespecialidad en imagen de tórax.")
                            .font(.system(size: 14))
                            .foregroundColor(.dtMutedFg)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color.dtBackground)
    }
}
