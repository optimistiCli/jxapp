import Foundation

/**
 * Goes thru blocks that shouldn't get in the output. Basically does
 * nothing, just waits for an block-ending directive to switch to return
 * control to enclosing block.
 */
class JXAPPLineProcessorGeneralUnsatisfied: JXAPPLineProcessor {
    static var shared = JXAPPLineProcessorGeneralUnsatisfied()

    private let _detector: JXAPPDetector

    init() {
        _detector = Self._detectorHelper([
            .if_set,
            .if_unset,
            .fi,
            .else,
        ])
    }

    func process(
            _ aLine: String,
            in aContext: JXAPPContext,
            poppingOn aPoppers: Set<JXAPPDirective>?
            ) throws -> JXAPPLineProcessingResult {
        guard let detection = try Self._detectorWarningHelper(
                aLine,
                detector: _detector,
                messageHandler: aContext.warning
                ) else {
            return .noop
        }
        if let poppers = aPoppers,
                poppers.contains(detection.directive) {
            return .pop
        }
        switch detection.directive {
            case .if_set, .if_unset:
                return .push(
                        startingWith: JXAPPLineProcessorGeneralUnsatisfied.shared,
                        untilPoppers: JXAPPLineProcessorAbstractIfBranch.branchPoppers,
                        replacingWith: JXAPPLineProcessorIrrelevantUnsatisfied.shared
                        )
            default:
                throw JXAPPLineProcessorError(because:
                        "Unexpected directive in general unsatisfied context “\(aLine)”")
        }
    }
}
