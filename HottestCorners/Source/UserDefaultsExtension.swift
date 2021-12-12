import Foundation

// MARK: - Values

extension UserDefaults {

    static var isPaused: Bool { userDefaults.bool(forKey: Keys.isPaused) }
    static func setPaused(_ paused: Bool) {
        userDefaults.setValue(paused, forKey: Keys.isPaused)
    }

    static var lowerLeftAppName: String? { userDefaults.string(forKey: Keys.lowerLeftApp)?.nilIfEmpty }
    static func setLowerLeftAppName(_ name: String) {
        userDefaults.setValue(name, forKey: Keys.lowerLeftApp)
    }
    static func removeLowerLeftAppName() {
        userDefaults.setValue(nil, forKey: Keys.lowerLeftApp)
    }

    static var lowerRightAppName: String? { userDefaults.string(forKey: Keys.lowerRightApp)?.nilIfEmpty }
    static func setLowerRightAppName(_ name: String) {
        userDefaults.setValue(name, forKey: Keys.lowerRightApp)
    }
    static func removeLowerRightAppName() {
        userDefaults.setValue(nil, forKey: Keys.lowerRightApp)
    }

    static var upperLeftAppName: String? { userDefaults.string(forKey: Keys.upperLeftApp)?.nilIfEmpty }
    static func setUpperLeftAppName(_ name: String) {
        userDefaults.setValue(name, forKey: Keys.upperLeftApp)
    }
    static func removeUpperLeftAppName() {
        userDefaults.setValue(nil, forKey: Keys.upperLeftApp)
    }

    static var upperRightAppName: String? { userDefaults.string(forKey: Keys.upperRightApp)?.nilIfEmpty }
    static func setUpperRightAppName(_ name: String) {
        userDefaults.setValue(name, forKey: Keys.upperRightApp)
    }
    static func removeUpperRightAppName() {
        userDefaults.setValue(nil, forKey: Keys.upperRightApp)
    }
}

// MARK: - Helper

private extension UserDefaults {

    enum Keys {
        static var isPaused: String { "isPaused" }
        static var lowerLeftApp: String { "llApp" }
        static var lowerRightApp: String { "lrApp" }
        static var upperLeftApp: String { "ulApp" }
        static var upperRightApp: String { "urApp" }
    }

    static var userDefaults: UserDefaults { UserDefaults.standard }

}

private extension String {

    var nilIfEmpty: String? { isEmpty ? nil : self }

}
