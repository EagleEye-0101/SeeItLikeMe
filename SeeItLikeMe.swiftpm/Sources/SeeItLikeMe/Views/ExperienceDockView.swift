import SwiftUI

@available(iOS 15.0, macOS 10.15, *)
struct ExperienceDockView: View {
    let hubState: HubState
    let completedCount: Int
    let onShiftPerspective: () -> Void
    
    private var iconForState: String {
        switch hubState {
        case .idle: return "location"
        case .focused: return "eye"
        case .immersed: return "waveform.path.ecg"
        case .integrating: return "lightbulb"
        }
    }
    
    private var labelForState: String {
        switch hubState {
        case .idle: return "Explore"
        case .focused: return "Focus"
        case .immersed: return "Experience"
        case .integrating: return "Reflect"
        }
    }
    
    var body: some View {
        HStack(spacing: 20) {
            // Context indicator
            HStack(spacing: 8) {
                Image(systemName: iconForState)
                    .font(.system(size: 16))
                    .foregroundColor(.accentColor)
                
                Text(labelForState)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            Spacer()
            
            // Progress ring
            ZStack {
                Circle()
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 2)
                    .frame(width: 30, height: 30)
                
                Circle()
                    .trim(from: 0, to: CGFloat(completedCount) / 8.0)
                    .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    .frame(width: 30, height: 30)
                    .rotationEffect(.degrees(-90))
            }
            
            Spacer()
            
            // Action button
            if case .integrating = hubState {
                Button("Reflect") {
                    onShiftPerspective()
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.accentColor)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}