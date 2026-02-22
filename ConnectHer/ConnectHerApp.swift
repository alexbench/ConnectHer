import SwiftUI

@main
struct ConnectHerApp: App {
    @State private var authVM = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            RootView(authVM: authVM)
                .onAppear {
                    authVM.checkSession()
                }
        }
    }
}

struct RootView: View {
    @Bindable var authVM: AuthViewModel

    var body: some View {
        Group {
            if authVM.isAuthenticated && authVM.hasCompletedOnboarding {
                MainTabView(authVM: authVM)
            } else if authVM.currentUser != nil {
                // User authenticated but hasn't completed profile setup
                ProfileSetupView(authVM: authVM)
            } else {
                OnboardingView(authVM: authVM)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: authVM.isAuthenticated)
        .animation(.easeInOut(duration: 0.3), value: authVM.hasCompletedOnboarding)
    }
}
