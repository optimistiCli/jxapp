import Foundation
import Iwstb

/* abstract */ class JXAPPLineProcessorAbstractIfBranchWithResult:
        JXAPPLineProcessorAbstractIfBranch {
    typealias _Results = (
            fi: JXAPPLineProcessingResult,
            else: JXAPPLineProcessingResult,
            else_if_set: JXAPPLineProcessingResult?,
            else_if_unset: JXAPPLineProcessingResult?
            )

    private var _savedResults: _Results? = nil
    @inlinable /* private */ var _results: _Results {
        if _savedResults == nil {
            _savedResults = _cookResults()
        }
        return _savedResults!
    }

    /* abstract */ /* protected */ func _cookResults() -> _Results {
        // Ancestors establish their links to each other here
        preconditionFailure("Call to abstract method \(Self.self).\(#function)")
    }

    override func process(
            _ aLine: String,
            in aContext: JXAPPContext,
            poppingOn aPoppers: Set<JXAPPDirective>?
            ) throws -> JXAPPLineProcessingResult {
        let results = _results
        guard let detection = try Self._detectorWarningHelper(
                aLine,
                detector: _detector,
                messageHandler: aContext.warning
                ) else {
            return .noop
        }
        switch detection.directive {
            case .fi:
                return results.fi
            case .else:
                return results.else
            case .else_if_set:
                return results.else_if_set ?? results.else
            case .else_if_unset:
                return results.else_if_unset ?? results.else
            default:
                // We shouldn't ever get here so it's a programing error
                throw JXAPPLineProcessorError(because:
                        "Unexpected directive in \(Self.self) block “\(aLine)”")
        }
    }
}
