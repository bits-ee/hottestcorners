import Foundation

final class ApplicationsList {

    static let shared = ApplicationsList()

    private var apps: [String] = []
    private var favoriteAppNames = [
        "Calculator",
        "Calendar",
        "Launchpad",
        "Mail",
        "Mission Control",
        "Notes",
        "Reminders",
        "Safari",
        "Screenshot",
        "Terminal"
    ]

    var appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
    var favoritesApps: [String] { apps.filter({ favoriteAppNames.contains($0) }) }
    var otherApps: [String] { apps.filter({ !favoriteAppNames.contains($0) && $0 != appName && !$0.contains("Uninstall")}) }

    private init() {}

    func update() {
        guard let systemAppDir = FileManager.default.urls(
            for: .applicationDirectory,
            in: .systemDomainMask
        ).first else {
            return
        }
        let systemApps = appsInDirectory(systemAppDir).compactMap({$0.fileName})
                
        guard let localAppDir = FileManager.default.urls(
            for: .applicationDirectory,
            in: .localDomainMask
        ).first else {
            return
        }
        let userApps = appsInDirectory(localAppDir).compactMap({$0.fileName})
        apps = []
        apps.append(contentsOf: systemApps)
        apps.append(contentsOf: userApps)
        apps.sort{$0.lowercased() < $1.lowercased()}
    }

    private func appsInDirectory(_ directory: URL) -> [URL] {
        guard let urls = try? FileManager.default.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: [],
            options: [
                .skipsHiddenFiles
            ]
        ) else {
            return []
        }

        var appUrls = urls.filter({ $0.pathExtension == "app" })
        for newDirectory in urls.filter({ $0.pathExtension.isEmpty }) {
            appUrls.append(contentsOf: appsInDirectory(newDirectory))
        }
        
        return appUrls
    }
}

extension URL {

    var fileName: String {
        deletingPathExtension().lastPathComponent
    }

}
