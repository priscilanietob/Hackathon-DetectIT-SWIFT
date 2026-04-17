import SwiftUI

@main
struct DetectITApp: App {
    @StateObject var authVM = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environmentObject(authVM)
        }
    }
}

struct DashboardView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @StateObject private var xrayVM = XRayViewModel()
    @StateObject private var chatVM = ChatViewModel()
    
    @State private var currentPage: AppPage = .dashboard
    @State private var showMobileChat = false

    var body: some View {
        VStack(spacing: 0) {
            topBar
            Divider().background(Color.dtBorder)

            Group {
                switch currentPage {
                case .dashboard:
                    mainDashboardContent
                case .doctor:
                    DoctorProfileView(onBack: { currentPage = .dashboard })
                case .patient:
                    PatientProfileView(
                        onBack: { currentPage = .dashboard },
                        onViewExpedient: { currentPage = .expedient }
                    )
                case .expedient:
                    PatientExpedientView(onBack: { currentPage = .patient })
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.dtBackground)
    }

    var topBar: some View {
        HStack(spacing: 12) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.dtPrimary)
                        .frame(width: 36, height: 36)
                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text("DetectIT")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.dtForeground)
                    Text("X-Ray Analysis Platform")
                        .font(.system(size: 10))
                        .foregroundColor(.dtMutedFg)
                }
            }
            Spacer()
            navTabs
            Spacer()
            
            Button { authVM.logout() } label: {
                HStack(spacing: 6) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    Text("Salir")
                }
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.dtDestructive)
                .padding(.horizontal, 12).padding(.vertical, 6)
                .background(Color.dtDestructive.opacity(0.1))
                .cornerRadius(8)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal).padding(.vertical, 10)
        .background(Color.dtCard)
    }

    var navTabs: some View {
        HStack(spacing: 2) {
            ForEach(AppPage.allCases, id: \.self) { page in
                Button { currentPage = page } label: {
                    HStack(spacing: 6) {
                        Image(systemName: page.icon)
                        Text(page.rawValue)
                    }
                    .font(.system(size: 13, weight: .medium))
                    .padding(.horizontal, 12).padding(.vertical, 7)
                    .background(currentPage == page ? Color.dtCard : Color.clear)
                    .foregroundColor(currentPage == page ? .dtPrimary : .dtMutedFg)
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4).background(Color.dtSecondary.opacity(0.5)).cornerRadius(10)
    }

    @ViewBuilder
    var mainDashboardContent: some View {
        #if os(macOS)
        macLayout
        #else
        iosLayout
        #endif
    }

    var macLayout: some View {
        HStack(spacing: 0) {
            XRayViewerView(xrayVM: xrayVM).padding(16)
            Divider().background(Color.dtBorder)
            ChatSidebarView(chatVM: chatVM, hasImage: xrayVM.hasImage)
                .frame(width: 380).padding(16)
        }
    }

    var iosLayout: some View {
        ZStack(alignment: .bottomTrailing) {
            XRayViewerView(xrayVM: xrayVM).padding(12)
            Button { showMobileChat = true } label: {
                ZStack {
                    Circle().fill(Color.dtPrimary).frame(width: 60, height: 60)
                        .shadow(color: Color.dtPrimary.opacity(0.3), radius: 8, x: 0, y: 4)
                    Image(systemName: "message.fill").font(.title2).foregroundColor(.white)
                }
            }
            .padding(20)
        }
        .sheet(isPresented: $showMobileChat) {
            NavigationStack {
                ChatSidebarView(chatVM: chatVM, hasImage: xrayVM.hasImage)
                    .padding()
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Hecho") { showMobileChat = false }
                        }
                    }
            }
        }
    }
}

enum AppPage: String, CaseIterable {
    case dashboard = "Análisis"
    case doctor    = "Mi perfil"
    case patient   = "Paciente"
    case expedient = "Expediente"

    var icon: String {
        switch self {
        case .dashboard: return "square.grid.2x2.fill"
        case .doctor:    return "person.fill"
        case .patient:   return "person.2.fill"
        case .expedient: return "doc.text.fill"
        }
    }
}
