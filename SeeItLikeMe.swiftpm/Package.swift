// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SeeItLikeMe",
    platforms: [.iOS(.v16)],
    products: [
        .executable(name: "SeeItLikeMe", targets: ["SeeItLikeMe"])
    ],
    targets: [
        .executableTarget(
            name: "SeeItLikeMe",
            path: "Sources/SeeItLikeMe"
        )
    ]
)