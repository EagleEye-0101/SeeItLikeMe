import Foundation

enum AppFlow: Equatable {
    case onboarding(page: Int)
    case hub(HubState)
    case synthesis
}

enum HubState: Equatable {
    case idle
    case focused(ExperienceKind)
    case immersed(ExperienceKind)
    case integrating(ExperienceKind)
}

enum ExperienceKind: String, CaseIterable, Identifiable {
    case visualStrain = "Visual Strain"
    case colorPerception = "Color Perception"
    case focusTunnel = "Focus Tunnel"
    case readingStability = "Reading Stability"
    case memoryLoad = "Memory Load"
    case focusDistraction = "Focus & Distraction"
    case cognitiveLoad = "Cognitive Load"
    case interactionPrecision = "Interaction Precision"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .visualStrain: return "eye"
        case .colorPerception: return "paintpalette"
        case .focusTunnel: return "circle.hexagongrid"
        case .readingStability: return "text.alignleft"
        case .memoryLoad: return "brain"
        case .focusDistraction: return "sparkles"
        case .cognitiveLoad: return "cpu"
        case .interactionPrecision: return "cursorarrow.click"
        }
    }
    
    var shortLabel: String {
        switch self {
        case .visualStrain: return "Strain"
        case .colorPerception: return "Colors"
        case .focusTunnel: return "Focus"
        case .readingStability: return "Reading"
        case .memoryLoad: return "Memory"
        case .focusDistraction: return "Attention"
        case .cognitiveLoad: return "Thinking"
        case .interactionPrecision: return "Touch"
        }
    }
    
    var description: String {
        switch self {
        case .visualStrain: return "Notice how text appears on screen"
        case .colorPerception: return "Observe how colors interact and convey meaning"
        case .focusTunnel: return "Notice what lies beyond your direct focus"
        case .readingStability: return "Find your natural reading pace"
        case .memoryLoad: return "Observe and remember patterns"
        case .focusDistraction: return "Identify what deserves your attention"
        case .cognitiveLoad: return "Manage multiple cognitive tasks"
        case .interactionPrecision: return "Precise interactions require optimal sizing"
        }
    }
}