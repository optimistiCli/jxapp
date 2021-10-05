import Foundation

class JXAPPDetectorsRegistery {
    static var shared = JXAPPDetectorsRegistery()

    @propertyWrapper
    public struct registered<Detector: JXAPPDetectorAbstractComoundable> {
        private var _detector: Detector?
        public init() {}
        public init(wrappedValue: Detector) {
            do {
                try JXAPPDetectorsRegistery.shared.registerDetector(wrappedValue)
            } catch {
                fatalError(String(describing: error))
            }
            _detector = wrappedValue
        }
        public var wrappedValue: Detector {
            get {
                guard let detector = _detector else {
                    fatalError("Attempted access to a \(String(describing: Detector.self)) shared instance before it was set")
                }
                return detector
            }
            set(aDetector) {
                guard _detector == nil else {
                    fatalError("Attempted reset of a \(String(describing: Detector.self)) shared instance")
                }
                _detector = aDetector
            }
        }
    }

    private var _directiveToDetector
            = Dictionary<JXAPPDirective, JXAPPDetectorAbstractComoundable>()

    func registerDetector(_ aDetector:
            JXAPPDetectorAbstractComoundable) throws {
        for directive in aDetector.detects {
            guard _directiveToDetector[directive] == nil else {
                throw JXAPPDetectorError(because:
                        "Multiple detector claim to detect “\(directive)”")
            }
            _directiveToDetector[directive] = aDetector
        }
    }

    func getDetector(
            forDirectives aDirectives: Set<JXAPPDirective>
            ) throws -> JXAPPDetector {
        var detectors = Array<JXAPPDetectorAbstractComoundable>()
        for directive in aDirectives {
            guard let detector = _directiveToDetector[directive] else {
                throw JXAPPDetectorError(because:
                        "No registered detector for “\(directive)”")
            }
            guard !detectors.contains(detector) else {
                continue
            }
            detectors.append(detector)
        }
        guard detectors.count > 0 else {
            throw JXAPPDetectorError(because:
                    "Can not get detector for “\(aDirectives)”")
        }
        return detectors.count == 1
            ? detectors[0]
            : JXAPPDetectorCompound(detectors)
    }
}
