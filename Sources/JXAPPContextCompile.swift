import Foundation

class JXAPPContextCompile: JXAPPContextAbstractBase {
    required init() throws {
        JXAPPOptions.shared.environment[Self.compilingEnvVarName] = "1"
        JXAPPOptions.shared.environment.removeValue(forKey: Self.runningEnvVarName)
    }

    @inlinable override func out(_ aStr: String) throws {
        _outWorker(aStr)
    }

    private var _shebangOverride: String? = nil
    private var _willTakeShebang: Bool = true
    private lazy var _outWorker: (String)->() = _outShebang

    private func _outShebang(_ aStr: String) {
        if JXAPPOptions.shared.outputShebang {
            if JXAPPOptions.shared.keepShebang {
                if let shebang = _shebangOverride {
                    print(shebang)
                } else {
                    print(JXAPPOptions.shared.shebang)
                }
            } else {
                print(JXAPPOptions.shared.shebang)
            }
        }
        print(aStr)
        _outWorker = _outNorm
        _willTakeShebang = false
    }

    private func _outNorm(_ aStr: String) {
        print(aStr)
    }
    
    @inlinable override func out(shebang aStr: String) throws {
        if _willTakeShebang {
            _shebangOverride = aStr
            _willTakeShebang = false
        }
    }

    override func wrapUp() throws -> Int32 {
        return 0
    }
}
