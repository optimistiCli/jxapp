import Foundation

class JXAPPDetectorAbstractComoundable: JXAPPDetector, Equatable {
    /* abstract */ var detects: Set<JXAPPDirective> {
        preconditionFailure("Call to abstract method \(Self.self).\(#function)")
    }

    static func == (
            lhs: JXAPPDetectorAbstractComoundable,
            rhs: JXAPPDetectorAbstractComoundable
            ) -> Bool {
        return lhs.detects == rhs.detects
    }

    /* abstract */ func detect(_ aLine: String) throws -> JXAPPDetection? {
        // Descendants do their work here
        preconditionFailure("Call to abstract method \(Self.self).\(#function)")
    }
}
