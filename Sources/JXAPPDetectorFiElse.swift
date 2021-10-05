import Foundation
import Iwstb

class JXAPPDetectorFiElse: JXAPPDetectorAbstractComoundable {
    @JXAPPDetectorsRegistery.registered
    static var shared = JXAPPDetectorFiElse()

    private static let _detects: Set<JXAPPDirective> = [
        .fi,
        .else,
    ]

    override var detects: Set<JXAPPDirective> {
        return Self._detects
    }

    private static let _re: Regexer = Iwstb.cookRegexer(
            //         1                                  2       3
            #"^\s*//(?:(fi)|(?:else(?!-if-(?:un)?set)))(?:(\s+\S)|(.))?"#)!
            //      a       b      c      d    d    cbae             e
    override func detect(_ aLine: String) throws -> JXAPPDetection? {
        guard let matches = Self._re.search(aLine) else {
            return nil
        }
        let isElse: Bool = matches[1].isEmpty
        let gotBadWorkload: Bool = !matches[2].isEmpty
        let gotConjointSuspect: Bool = !matches[3].isEmpty

        if gotBadWorkload {
            throw JXAPPDetectorError(because:
                    "\(isElse ? "Else" : "Fi") directive should have no parameters “\(aLine)”")
        } else if gotConjointSuspect {
            throw JXAPPDetectorWarning(because:
                    "Possibly a misspelled \(isElse ? "else" : "fi") directive “\(aLine)”")
        } else {
            return JXAPPDetection(directive: isElse
                ? .else
                : .fi
                )
        }
    }
}
