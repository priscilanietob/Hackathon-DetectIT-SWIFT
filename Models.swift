import SwiftUI
import Combine 

// logica de Usuario
class AuthViewModel: ObservableObject {
    @Published var userEmail: String = "doctor@detectit.com"
    func logout() { print("Saliendo...") }
}

// logica del Chat
class ChatViewModel: ObservableObject {
    @Published var hasImage: Bool = false
}

struct ChatSidebarView: View {
    @ObservedObject var chatVM: ChatViewModel
    var hasImage: Bool
    
    var body: some View {
        VStack {
            if hasImage {
                Text("Análisis de imagen listo")
                    .font(.caption)
                    .foregroundColor(.green)
            }
            Text("Historial del Chat")
                .foregroundColor(.dtMutedFg)
            Spacer()
            Text("Escribe un mensaje...")
                .padding()
                .background(Color.dtSecondary)
                .cornerRadius(8)
        }
        .padding()
    }
}
