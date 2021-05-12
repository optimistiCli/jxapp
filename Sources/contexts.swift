import Foundation

import Iwstb

protocol JxaPPContext {
    init() throws
    func out(_ aStr: String) throws
    func wrapUp() throws -> Int32
    func warning(_ aMessage: String)
    func pushUrl(_ aUrl: URL)
    func popUrl()
    func setCurrentLineNum(_ aLineNum: Int)
    func resetCurrentLineNum()
    func cookJxaUrl(_ aJxaFile: String) -> URL
    func wasOnceIncluded(_ aJxaURL: URL) -> Bool
    func declareOnceIncluded(_ aJxaURL: URL)
    func processJxa(_ aJxaURL: URL) throws
}

class AbstractContext: JxaPPContext {
    private lazy var _pp = JxaPP(self)
    private lazy var _processor: (URL) throws -> () = _processMainJxa
    private var _urlStack = [URL]()
    private var _currentLineNum: Int?
    private var _oncePaths = Set<String>()

    required init() throws {
        if Self.self === AbstractContext.self {
            preconditionFailure("Call to abstract method \(Self.self).\(#function)") 
        }
    }

    func out(_ aStr: String) throws {
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

    func pushUrl(_ aUrl: URL) {
        _urlStack.append(aUrl)
    }

    func popUrl() {
        _urlStack.removeLast()
    }

    func setCurrentLineNum(_ aLineNum: Int) {
        _currentLineNum = aLineNum
    }

    func resetCurrentLineNum() {
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

    private func _processMainJxa(_ aJxaURL: URL) throws {
        _processor = _processFurtherJxa
        do {
            try _pp.parse(aJxaURL)
        } catch let basicError as Iwstb.Error {
            if let aug = _cookMessageAugmentationSuffix() {
                basicError.augment(aug)
            }
            throw basicError
        }
    }

    private func _processFurtherJxa(_ aJxaURL: URL) throws {
        try _pp.parse(aJxaURL)
    }
}

class CompileContext: AbstractContext {
    required init() throws {}

    override func out(_ aStr: String) throws {
        print(aStr)
    }

    override func wrapUp() throws -> Int32 {
        return 0
    }
}

class ExecContextError: Iwstb.Error {}

class ExecContext: AbstractContext {
    private let _tempDirUrl: URL
    private let _ppDestUrl: URL
    private let _filePointer: UnsafeMutablePointer<FILE>

    required init() throws {
        let fm = FileManager.default

        do {
            _tempDirUrl = try fm.url(
                    for: .itemReplacementDirectory,
                    in: .userDomainMask,
                    appropriateFor: Iwstb.progUrl,
                    create: true
                    )
        } catch {
            throw ExecContextError(because:
                    "There was a problem while creating a temporary directory")
        }

        _ppDestUrl = URL(
                fileURLWithPath: "\(Iwstb.prog).js",
                relativeTo: _tempDirUrl
                )

        var isDir : ObjCBool = false
        guard !fm.fileExists(atPath: _ppDestUrl.path, isDirectory: &isDir) else {
            throw ExecContextError(because:
                    "Preprocessing destination already exists “\(_ppDestUrl.path)”")
        }

        guard let filePointer = fopen(_ppDestUrl.path, "w") else {
            throw ExecContextError(because:
                    "Can't open preprocessing destination for writing “\(_ppDestUrl.path)”")
        }
        _filePointer = filePointer
    }

    override func out(_ aStr: String) throws {
        let lineBuffer = Array("\(aStr)\n".utf8)
        let count = lineBuffer.count
        let written = fwrite(lineBuffer, 1, count, _filePointer)
        if written < count {
            throw ExecContextError(because:
                    "Preprocessing destination already exists “\(_ppDestUrl.path)”")
        }
    }

    override func wrapUp() throws -> Int32 {
        fclose(_filePointer)
        let args = ["-l", "JavaScript", _ppDestUrl.path]
        let retVal = try Iwstb.run(
                URL(fileURLWithPath: "/usr/bin/osascript"), 
                arguments: Options.shared.extraArgs == nil
                        ? args
                        : args + Options.shared.extraArgs!
                )
        do {
            try FileManager.default.removeItem(at: _tempDirUrl)
        } catch {
            warning("There was a problem while deleting the temporary directory “\(_tempDirUrl.path)”")
        }
        return retVal
    }
}
