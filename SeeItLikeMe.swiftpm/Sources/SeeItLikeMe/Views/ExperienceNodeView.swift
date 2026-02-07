import SwiftUI

@available(iOS 15.0, macOS 10.15, *)
struct ExperienceNodeView: View {
    let experience: ExperienceKind
    let isCompleted: Bool
    let currentState: HubState
    let onTap: () -> Void
    
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.7
    
    private var isActive: Bool {
        switch currentState {
        case .focused(let exp) where exp == experience:
            return true
        case .immersed(let exp) where exp == experience:
            return true
        case .integrating(let exp) where exp == experience:
            return true
        default:
            return false
        }
    }
    
    private var isAvailable: Bool {
        switch currentState {
        case .idle:
            return true
        case .focused(let exp) where exp == experience:
            return true
        case .immersed(let exp) where exp == experience:
            return true
        case .integrating(let exp) where exp == experience:
            return true
        default:
            return false
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(isCompleted ? Color.green : Color.accentColor)
                        .frame(width: 60, height: 60)
                        .opacity(isActive ? 1.0 : 0.8)
                        .scaleEffect(isActive ? 1.1 : 1.0)
                    
                    Image(systemName: experience.icon)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
                
                Text(experience.shortLabel)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isActive ? .primary : .secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 80)
            }
        }
        .buttonStyle(.plain)
        .opacity(isAvailable ? 1.0 : 0.3)
        .scaleEffect(scale)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(Double.random(in: 0...1))) {
                opacity = 1.0
            }
        }
    }
}