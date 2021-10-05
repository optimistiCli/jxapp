import Foundation
import Iwstb

/* abstract */ class JXAPPLineProcessorAbstractIfBranch: JXAPPLineProcessor {
    public static var branchPoppers: Set<JXAPPDirective> = [
        .fi,
        .else,
        .else_if_set,
        .else_if_unset,
    ]
    /* protected */ let _detector: JXAPPDetector

    init() {
        if Self.self === JXAPPLineProcessorAbstractIfBranch.self {
            preconditionFailure("Call to abstract method \(Self.self).\(#function)")
        }
        _detector = Self._detectorHelper(Self.branchPoppers)
    }

    /* abstract */ func process(
            _ aLine: String,
            in aContext: JXAPPContext,
            poppingOn aPoppers: Set<JXAPPDirective>?
            ) throws -> JXAPPLineProcessingResult {
        preconditionFailure("Call to abstract method \(Self.self).\(#function)")
    }
}
