import Foundation
import Iwstb

class JXAPPLineProcessorShebangRemover: JXAPPLineProcessor {
    static var shared = JXAPPLineProcessorShebangRemover()

    private static let _re: Regexer
            = Iwstb.cookRegexer(#"^(#!.*?)?\s*$"#)!

    func process(
            _ aLine: String,
            in aContext: JXAPPContext,
            poppingOn aPoppers: Set<JXAPPDirective>?
            ) throws -> JXAPPLineProcessingResult {
        if let matches = Self._re.search(aLine) {
            if !matches[1].isEmpty {
                try aContext.out(shebang: String(matches[1]))
            }
            return .noop
        } else {
            return .retry(withReplacement: JXAPPLineProcessorGeneral.shared)
        }
    }
}
