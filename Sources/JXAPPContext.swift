import Foundation

protocol JXAPPContext {
    init() throws
    @inlinable func out(_ aStr: String) throws
    @inlinable func out(shebang aStr: String) throws
    func wrapUp() throws -> Int32
    func warning(_ aMessage: String)
    func cookJxaUrl(_ aJxaFile: String) -> URL
    func wasOnceIncluded(_ aJxaURL: URL) -> Bool
    func declareOnceIncluded(_ aJxaURL: URL)
    func processJxa(_ aJxaURL: URL) throws
    var currentUrl: URL? { get }
    var currentFile: String { get }
}
