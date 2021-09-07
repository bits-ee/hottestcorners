//  Copyright © 2021 Baltic IT Solutions OÜ. All rights reserved.

import Foundation

final class ApplicationsList {

    static let shared = ApplicationsList()

    private var apps: [String] = []
    private var favoriteApps = [
        "Calculator",
        "Calendar",
        "Mail",
        "Notes",
        "Reminders",
        "Safari",
        "Terminal",
    ]

    var favoritesAppName: [String] { favoriteApps.filter({ apps.contains($0) }) }
    var otherAppNames: [String] { apps.filter({ !favoriteApps.contains($0) && $0 != "HottestCorners" }) }

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
        
        apps.append(contentsOf: systemApps)
        apps.append(contentsOf: userApps)
        apps.sort()
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
