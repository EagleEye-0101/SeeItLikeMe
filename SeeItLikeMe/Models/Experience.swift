import SwiftUI
import Foundation

struct Experience: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let iconName: String
    let destination: AnyView
}