import Foundation
import Iwstb

/**
 * Default context. Processes include*, if* and [un]set directives. Any
 * other directive should produce an error. All if* directives cause both
 * switching to another appropriate context and, if condition is satisfied,
 * andcreation of a sub-parser via the self stack machinery. When it finds
 * an if-closing directive a sub-parser pops itself from the self stack and
 * returns control to the enclosing parser, alowing it to process the same
 * line.
 */
class JXAPPLineProcessorGeneral: JXAPPLineProcessor {
    static var shared = JXAPPLineProcessorGeneral()

    private let _detector: JXAPPDetector

    init() {
        _detector = Self._detectorHelper([
            .include,
            .include_once,
            .if_set,
            .if_unset,
            .set,
            .unset,
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
            try aContext.out(aLine)
            return .noop
        }
        if let poppers = aPoppers,
                poppers.contains(detection.directive) {
            return .pop
        }
        switch detection.directive {
            case .include:
                guard let jxa = detection.workload?[0] else {
                    // This should never happen
                    throw JXAPPLineProcessorError(because:
                            "Malformed include directive detection result while processing “\(aLine)”")
                }
                let url = aContext.cookJxaUrl(jxa)
                try aContext.processJxa(url)
                return .noop
            case .include_once:
                guard let jxa = detection.workload?[0] else {
                    // This should never happen
                    throw JXAPPLineProcessorError(because:
                            "Malformed include once directive detection result while processing “\(aLine)”")
                }
                let url = aContext.cookJxaUrl(jxa)
                if !aContext.wasOnceIncluded(url) {
                    aContext.declareOnceIncluded(url)
                    try aContext.processJxa(url)
                }
                return .noop
            case .if_set:
                return try _ifHelper(
                        detection: detection,
                        ifSet: .push(
                                startingWith: JXAPPLineProcessorGeneral.shared,
                                untilPoppers: JXAPPLineProcessorAbstractIfBranch.branchPoppers,
                                replacingWith: JXAPPLineProcessorSatisfied.shared
                                ),
                        ifUnset: .push(
                                startingWith: JXAPPLineProcessorGeneralUnsatisfied.shared,
                                untilPoppers: JXAPPLineProcessorAbstractIfBranch.branchPoppers,
                                replacingWith: JXAPPLineProcessorUnsatisfiedHopefull.shared
                                )
                        )
            case .if_unset:
                return try _ifHelper(
                        detection: detection,
                        ifSet: .push(
                                startingWith: JXAPPLineProcessorGeneralUnsatisfied.shared,
                                untilPoppers: JXAPPLineProcessorAbstractIfBranch.branchPoppers,
                                replacingWith: JXAPPLineProcessorUnsatisfiedHopefull.shared
                                ),
                        ifUnset: .push(
                                startingWith: JXAPPLineProcessorGeneral.shared,
                                untilPoppers: JXAPPLineProcessorAbstractIfBranch.branchPoppers,
                                replacingWith: JXAPPLineProcessorSatisfied.shared
                                )
                        )
            case .set:
                guard
                        let name = detection.workload?[0],
                        let value = detection.workload?[1]
                        else {
                    // This should never happen
                    throw JXAPPLineProcessorError(because:
                            "Malformed set directive detection result while processing “\(aLine)”")
                }
                JXAPPOptions.shared.environment[name] = value
                return .noop
            case .unset:
                guard let name = detection.workload?[0] else {
                    // This should never happen
                    throw JXAPPLineProcessorError(because:
                            "Malformed unset directive detection result while processing “\(aLine)”")
                }
                JXAPPOptions.shared.environment.removeValue(forKey: name)
                return .noop
            default:
                throw JXAPPLineProcessorError(because:
                        "Unexpected directive in general context “\(aLine)”")
        }
    }
}
