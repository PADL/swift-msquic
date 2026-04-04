// swift-tools-version: 5.9
import PackageDescription
import Foundation

let useDebugMsQuic = ProcessInfo.processInfo.environment["MSQUIC_DEBUG"] != nil
let msquicTargetName = useDebugMsQuic ? "MsQuicDebug" : "MsQuic"

let package = Package(
    name: "SwiftMsQuic",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .library(name: "SwiftMsQuic", type: .dynamic, targets: [msquicTargetName, "SwiftMsQuicHelper"]),
        .library(name: "SwiftMsQuicStatic", type: .static, targets: [msquicTargetName, "SwiftMsQuicHelper"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.3.0")
    ],
    targets: [
        .binaryTarget(
            name: "MsQuic",
            url: "https://github.com/team-unstablers/msquic/releases/download/v2.5.6-tuvariant%2B260331/MsQuic-2.5.6-tuvariant+260331-RELEASE-darwin-multiarch-static-unsigned.zip",
            checksum: "28596ea8cc7f2292b5841d89e4bf5006ee7f51822b1e560dcfdc4916e84c9f47",
        ),
        .binaryTarget(
            name: "MsQuicDebug",
            url: "https://github.com/team-unstablers/msquic/releases/download/v2.5.6-tuvariant%2B260331/MsQuic-2.5.6-tuvariant+260331-DEBUG-darwin-multiarch-static-unsigned.zip",
            checksum: "41842c565b5f9a714ce6a964216ad8486596abaf767bd49ea3294152b2a6edf7",
        ),
        .target(
            name: "SwiftMsQuicOpenSSLUtils",
            dependencies: [
                .target(name: msquicTargetName)
            ],
            path: "Sources/SwiftMsQuicOpenSSLUtils",
            publicHeadersPath: "Headers",
            cSettings: [
                .headerSearchPath("."),
            ],
        ),
        .target(
            name: "SwiftMsQuicHelper",
            dependencies: [
                .target(name: msquicTargetName),
                .target(name: "SwiftMsQuicOpenSSLUtils"),
            ],
            path: "Sources/SwiftMsQuicHelper",
            swiftSettings: []
        ),
        .executableTarget(
            name: "SwiftMsQuicExample",
            dependencies: ["SwiftMsQuicHelper"],
            path: "Sources/SwiftMsQuicExample",
            swiftSettings: [
                .interoperabilityMode(.Cxx)
            ]
        )
    ]
)
