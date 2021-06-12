import Foundation

public struct Appify {

    @discardableResult
    public static func run() -> Bool {
        let arguments = CommandLine.arguments
        guard arguments.count > 1, arguments[1] == "appify" else { return false }
        do {
            let fm = FileManager.default
            let executablePath = URL(fileURLWithPath: arguments[0])
            let appPath = executablePath.appendingPathExtension("app")
            if fm.fileExists(atPath: appPath.lastPathComponent, isDirectory: nil) {
                try fm.removeItem(at: appPath)
            }
            let macOSPath = appPath.appendingPathComponent("Contents").appendingPathComponent("MacOS")
            try fm.createDirectory(at: macOSPath, withIntermediateDirectories: true, attributes: nil)

            try fm.copyItem(at: executablePath, to: macOSPath.appendingPathComponent(executablePath.lastPathComponent))

            let bundles = try fm.contentsOfDirectory(at: executablePath.deletingLastPathComponent(), includingPropertiesForKeys: nil, options: [])
                .filter({ $0.pathExtension == "bundle" && $0.lastPathComponent.starts(with: executablePath.lastPathComponent) })

            let resourcesPath = appPath.appendingPathComponent("Contents").appendingPathComponent("Resources")
            try fm.createDirectory(at: resourcesPath, withIntermediateDirectories: true, attributes: nil)
            for bundle in bundles {
                try fm.copyItem(at: bundle, to: resourcesPath.appendingPathComponent(bundle.lastPathComponent))
            }

            print("✅ \(appPath.path)")
            exit(0)
        } catch {
            print("❌ \(error)")
            exit(1)
        }
        return true
    }

}
