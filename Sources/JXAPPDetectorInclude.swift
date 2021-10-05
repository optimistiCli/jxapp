import Foundation
import Iwstb

class JXAPPDetectorInclude: JXAPPDetectorAbstractComoundable {
    @JXAPPDetectorsRegistery.registered
    static var shared = JXAPPDetectorInclude()

    private static let _detects: Set<JXAPPDirective> = [
        .include,
        .include_once,
    ]

    override var detects: Set<JXAPPDirective> {
        return Self._detects
    }

    private static let _re: Regexer = Iwstb.cookRegexer(
            //                 1                            2          3      4     5       6
            #"^\s*//include(?:-(once))?(?:(?:\b(?:\s*(?:(?:"(.+)")|(?:'(.+)')|(\S+)|(.*))))|(.*))$"#)!
    override func detect(_ aLine: String) throws -> JXAPPDetection? {
        guard let matches = Self._re.search(aLine) else {
            return nil
        }
        let gotGoodWorkload: Bool = !(
                matches[4].isEmpty
                && matches[2].isEmpty
                && matches[3].isEmpty
                )
        let gotBadWorkload: Bool = !matches[5].isEmpty
        let gotConjointSuspect: Bool = !matches[6].isEmpty
        let gotOnce: Bool = !matches[1].isEmpty

        if gotGoodWorkload {
            return JXAPPDetection(
                    directive: gotOnce
                        ? .include_once
                        : .include,
                    workload: "\(matches[2])\(matches[3])\(matches[4])"
                    )
        } else if gotBadWorkload {
            throw JXAPPDetectorError(because:
                    "\(gotOnce ? "Include-once" : "Include") directive has strange path “\(aLine)”")
        } else if gotConjointSuspect {
            throw JXAPPDetectorWarning(because:
                    "Possibly missing a whitespace in an \(gotOnce ? "include-once" : "include") directive “\(aLine)”")
        } else {
            throw JXAPPDetectorError(because:
                    "\(gotOnce ? "Include-once" : "Include") directive without path “\(aLine)”")
        }
    }
}
