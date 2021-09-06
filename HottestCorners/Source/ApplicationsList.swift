//  Copyright © 2021 Baltic IT Solutions OÜ. All rights reserved.

import Foundation

final class ApplicationsList {

    static let shared = ApplicationsList()

    private var apps: [String] = []
    private var favoriteApps = [
        "Calculator",
        "Terminal",
        "Safari"
    ]

    var favoritesAppName: [String] { favoriteApps.filter({ apps.contains($0) }) }
    var otherAppNames: [String] { apps.filter({ !favoriteApps.contains($0) }) }

    private init() {}

    func update() {
        let directory = FileManager.default.urls(for: .applicationDirectory, in: .systemDomainMask)[0]

        apps = appsInDirectory(directory).sorted(by: {
            $0.absoluteString.lowercased() < $1.absoluteString.lowercased()
        }).compactMap({
            $0.fileName
        })
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
