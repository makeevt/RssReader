import Foundation

extension FileManager {
    public func createDirectoryIfNecessary(_ url: URL) throws {
        let fileManager = FileManager.default
        let directory = url.deletingLastPathComponent()
        try fileManager.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
    }
}
