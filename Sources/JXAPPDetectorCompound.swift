import Foundation
import Iwstb

class JXAPPDetectorCompound: JXAPPDetector {
    private let _subDetectors: Array<JXAPPDetectorAbstractComoundable>

    init(_ aDetectors: Array<JXAPPDetectorAbstractComoundable>) {
        _subDetectors = aDetectors
    }

    func detect(_ aLine: String) throws -> JXAPPDetection? {
        for subDetector in _subDetectors {
            guard let detection = try subDetector.detect(aLine) else {
                continue
            }
            return detection
        }
        return nil
    }
}

