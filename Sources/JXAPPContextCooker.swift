import Foundation

class JXAPPContextCooker {
    static func cookContext() throws -> JXAPPContext {
        return JXAPPOptions.shared.compiling
            ? try JXAPPContextCompile()
            : try JXAPPContextExec()
    }
}
