import Foundation
import Iwstb

class JXAPPDetectorIfSetUnset: JXAPPDetectorAbstractComoundable {
    @JXAPPDetectorsRegistery.registered
    static var shared = JXAPPDetectorIfSetUnset()

    private static let _detects: Set<JXAPPDirective> = [
        .if_set,
        .if_unset,
        .else_if_set,
        .else_if_unset,
    ]

    override var detects: Set<JXAPPDirective> {
        return Self._detects
    }

    private static let _re: Regexer = Iwstb.cookRegexer(
            //      1             2                                       3              4             5      6       7
            #"^\s*//(else-)?if-(?:(set)|(?:unset))(?:(?:\b(?:\s+(?:(?:"\$?(\S+)")|(?:'\$?(\S+)')|(?:\$?(\S+))|(.*))))|(.*))$"#)!
    override func detect(_ aLine: String) throws -> JXAPPDetection? {
        guard let matches = Self._re.search(aLine) else {
            return nil
        }
        let isElseIf: Bool = !matches[1].isEmpty
        let isUnset: Bool = matches[2].isEmpty
        let gotGoodWorkload: Bool = !(matches[5].isEmpty && matches[3].isEmpty && matches[4].isEmpty)
        let gotBadWorkload: Bool = !matches[6].isEmpty
        let gotConjointSuspect: Bool = !matches[7].isEmpty

        if gotGoodWorkload {
            return JXAPPDetection(
                    directive: isUnset
                        ? isElseIf
                            ? .else_if_unset
                            : .if_unset
                        : isElseIf
                            ? .else_if_set
                            : .if_set,
                    workload: "\(matches[3])\(matches[4])\(matches[5])"
                    )
        } else {
            let directiveName = isUnset
                    ? isElseIf
                        ? "Else-if-inset"
                        : "If-unset"
                    : isElseIf
                        ? "Else-if-set"
                        : "If-set"
            if gotBadWorkload {
                throw JXAPPDetectorError(because:
                        "\(directiveName) directive references strange variable “\(aLine)”")
            } else if gotConjointSuspect {
                throw JXAPPDetectorWarning(because:
                        "Possibly missing a whitespace in an \(directiveName) directive “\(aLine)”")
            } else {
                throw JXAPPDetectorError(because:
                        "\(directiveName) directive without variable “\(aLine)”")
            }
        }
    }
}
