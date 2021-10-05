import Foundation

/**
 * Goes thru blocks that shouldn't get in the output but there might be a firther block that will. Basically does
 * nothing, just waits for an if-ending directive to switch to general line processor.
 */
class JXAPPLineProcessorUnsatisfiedHopefull: JXAPPLineProcessorAbstractIfBranch {
    static var shared = JXAPPLineProcessorUnsatisfiedHopefull()

    override func process(
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
        switch detection.directive {
            case .fi:
                return .replace(with: JXAPPLineProcessorGeneral.shared)
            case .else:
                return .push(
                        startingWith: JXAPPLineProcessorGeneral.shared,
                        untilPoppers: JXAPPLineProcessorAbstractIfBranch.branchPoppers,
                        replacingWith: JXAPPLineProcessorSatisfied.shared
                        )
            case .else_if_set:
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
            case .else_if_unset:
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
            default:
                // We shouldn't ever get here so it's a programing error
                throw JXAPPLineProcessorError(because:
                        "Unexpected directive in \(Self.self) block “\(aLine)”")
        }
    }
}
