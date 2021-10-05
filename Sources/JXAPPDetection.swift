import Foundation

struct JXAPPDetection {
    let directive: JXAPPDirective
    let workload: [String]?

    init(directive aDirective: JXAPPDirective) {
        directive = aDirective
        workload = nil
    }

    init(directive aDirective: JXAPPDirective, workload aStr: String) {
        directive = aDirective
        workload = [aStr]
    }

    init(directive aDirective: JXAPPDirective, workload aStrArray: [String]) {
        directive = aDirective
        workload = aStrArray
    }
}
