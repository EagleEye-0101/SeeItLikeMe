import SwiftUI

@available(iOS 15.0, macOS 10.15, *)
enum AnimationHelpers {
    static let spring = Animation.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0)
    static let smooth = Animation.easeInOut(duration: 0.4)
    static let quick = Animation.easeOut(duration: 0.25)
    static let hero = Animation.interpolatingSpring(stiffness: 200, damping: 20)
    static let bounce = Animation.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0)
    static let decay = Animation.interpolatingSpring(stiffness: 50, damping: 15)
}
