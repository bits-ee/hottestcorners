//  Copyright © 2021 Baltic IT Solutions OÜ. All rights reserved.

import Foundation

final class ApplicationsList {

    static let shared = ApplicationsList()
    private init() {}

    private var listOfUrls: [URL] = []
    var listOfNames: [String] { listOfUrls.compactMap({ $0.fileName })}

    func update() {
        let directory = FileManager.default.urls(for: .applicationDirectory, in: .systemDomainMask)[0]

        listOfUrls = appsInDirectory(directory).sorted(by: {
            $0.absoluteString.lowercased() < $1.absoluteString.lowercased()
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
