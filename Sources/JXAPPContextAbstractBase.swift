import Foundation
import Iwstb

class JXAPPContextAbstractBase: JXAPPContext {
    static let runningEnvVarName = "JXAPP_RUNNING"
    static let compilingEnvVarName = "JXAPP_COMPILING"

    private lazy var _processor: (URL) throws -> () = _processMainJxa
    private var _urlStack = [URL]()
    private var _currentLineNum: Int?
    private var _oncePaths = Set<String>()

    required init() throws {
        if Self.self === JXAPPContextAbstractBase.self {
            preconditionFailure("Call to abstract method \(Self.self).\(#function)")
        }
    }

    func parse(_ aJxaUrl: URL) throws {
        let lineReader = try Iwstb.cookLineReader(aJxaUrl)
        _pushUrl(lineReader.url)
        let parser = try JXAPPParser(self)
        var lineNum: Int = 0
        for line in lineReader {
            lineNum += 1
            _setCurrentLineNum(lineNum)
            try parser.process(String(line))
        }
        _resetCurrentLineNum()
        try parser.onEof()
        _popUrl()
    }

    @inlinable func out(_ aStr: String) throws {
        preconditionFailure("Call to abstract method \(Self.self).\(#function)")
    }

    @inlinable func out(shebang aStr: String) throws {
        preconditionFailure("Call to abstract method \(Self.self).\(#function)")
    }

    func wrapUp() throws -> Int32 {
        preconditionFailure("Call to abstract method \(Self.self).\(#function)")
    }

    private func _cookMessageAugmentationSuffix() -> String? {
        if let path = _urlStack.last?.path {
            var buffer = " at \(path)"
            if let lineNum = _currentLineNum {
                buffer += ":\(lineNum)"
            }
            return buffer
        } else {
            return nil
        }
    }

    func warning(_ aMessage: String) {
        if let aug = _cookMessageAugmentationSuffix() {
            Iwstb.moan(aMessage + aug)
        } else {
            Iwstb.moan(aMessage)
        }
    }

    @inlinable func _pushUrl(_ aUrl: URL) {
        _urlStack.append(aUrl)
    }

    @inlinable func _popUrl() {
        _urlStack.removeLast()
    }

    @inlinable var currentUrl: URL? {
        _urlStack.last
    }

    @inlinable var currentFile: String {
        currentUrl?.path ?? "No Fule"
    }

    @inlinable func _setCurrentLineNum(_ aLineNum: Int) {
        _currentLineNum = aLineNum
    }

    @inlinable func _resetCurrentLineNum() {
        _currentLineNum = nil
    }

    func cookJxaUrl(_ aJxaFile: String) -> URL {
        return URL(fileURLWithPath: aJxaFile, relativeTo: _urlStack.last)
    }

    func wasOnceIncluded(_ aJxaURL: URL) -> Bool {
        return _oncePaths.contains(aJxaURL.path)
    }

    func declareOnceIncluded(_ aJxaURL: URL) {
        _oncePaths.insert(aJxaURL.path)
    }

    func processJxa(_ aJxaURL: URL) throws {
        try _processor(aJxaURL)
    }

    func processJxa(path aJxaFile: String) throws {
        try _processor(URL(fileURLWithPath: aJxaFile, relativeTo: _urlStack.last))
    }

    private func _processMainJxa(_ aJxaURL: URL) throws {
        _processor = _processFurtherJxa
        do {
            try parse(aJxaURL)
        } catch let error as AugmentableError {
            if let aug = _cookMessageAugmentationSuffix() {
                error.augment(aug)
            }
            throw error
        }
    }

    private func _processFurtherJxa(_ aJxaURL: URL) throws {
        try parse(aJxaURL)
    }
}
