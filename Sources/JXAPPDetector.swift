import Foundation
import Iwstb

class JXAPPDetectorError: IwstbError {}
class JXAPPDetectorWarning: IwstbError {}

protocol JXAPPDetector {
    func detect(_ aLine: String) throws -> JXAPPDetection?
}
