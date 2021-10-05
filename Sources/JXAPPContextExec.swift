import Foundation
import Iwstb

class JXAPPContextExecError: IwstbError {}

class JXAPPContextExec: JXAPPContextAbstractBase {
    private let _tempDirUrl: URL
    private let _ppDestUrl: URL
    private let _filePointer: UnsafeMutablePointer<FILE>

    required init() throws {
        JXAPPOptions.shared.environment[Self.runningEnvVarName] = "1"
        JXAPPOptions.shared.environment.removeValue(forKey: Self.compilingEnvVarName)

        let fm = FileManager.default

        do {
            _tempDirUrl = try fm.url(
                    for: .itemReplacementDirectory,
                    in: .userDomainMask,
                    appropriateFor: Iwstb.progUrl,
                    create: true
                    )
        } catch {
            throw JXAPPContextExecError(because:
                    "There was a problem while creating a temporary directory")
        }

        _ppDestUrl = URL(
                fileURLWithPath: "\(Iwstb.prog).js",
                relativeTo: _tempDirUrl
                )

        var isDir : ObjCBool = false
        guard !fm.fileExists(atPath: _ppDestUrl.path, isDirectory: &isDir) else {
            throw JXAPPContextExecError(because:
                    "Preprocessing destination already exists “\(_ppDestUrl.path)”")
        }

        guard let filePointer = fopen(_ppDestUrl.path, "w") else {
            throw JXAPPContextExecError(because:
                    "Can't open preprocessing destination for writing “\(_ppDestUrl.path)”")
        }
        _filePointer = filePointer
    }

    @inlinable override func out(_ aStr: String) throws {
        let lineBuffer = Array("\(aStr)\n".utf8)
        let count = lineBuffer.count
        let written = fwrite(lineBuffer, 1, count, _filePointer)
        if written < count {
            throw JXAPPContextExecError(because:
                    "Preprocessing destination already exists “\(_ppDestUrl.path)”")
        }
    }

    @inlinable override func out(shebang aStr: String) throws {
        // Do nothing
    }

    override func wrapUp() throws -> Int32 {
        fclose(_filePointer)
        let args = ["-l", "JavaScript", _ppDestUrl.path]
        let retVal = try Iwstb.run(
                URL(fileURLWithPath: "/usr/bin/osascript"), 
                arguments: JXAPPOptions.shared.extraArgs == nil
                        ? args
                        : args + JXAPPOptions.shared.extraArgs!,
                environment: JXAPPOptions.shared.environment
                )
        do {
            try FileManager.default.removeItem(at: _tempDirUrl)
        } catch {
            warning("There was a problem while deleting the temporary directory “\(_tempDirUrl.path)”")
        }
        return retVal
    }
}
