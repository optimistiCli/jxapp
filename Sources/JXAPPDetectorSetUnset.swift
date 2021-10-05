import Foundation
import Iwstb

class JXAPPDetectorSetUnset: JXAPPDetectorAbstractComoundable {
    @JXAPPDetectorsRegistery.registered
    static var shared = JXAPPDetectorSetUnset()

    private static let _detects: Set<JXAPPDirective> = [
        .set,
        .unset,
    ]

    override var detects: Set<JXAPPDirective> {
        return Self._detects
    }

    private static let _re: Regexer = Iwstb.cookRegexer(
            //         1                          2           3        4         5
            #"^\s*//(?:(set)|(?:unset))\b(?:(?:\s*(\S+?)(?:\s*(=)(?:\s*(.+?))?)?)|(.*?))?\s*$"#)!
            //      a        b       ba  c  d           e        f          f e d      c
    override func detect(_ aLine: String) throws -> JXAPPDetection? {
        guard let matches = Self._re.search(aLine) else {
            return nil
        }
        let isUnset: Bool = matches[1].isEmpty
        if matches[2].isEmpty {
            throw JXAPPDetectorError(because:
                    "\(isUnset ? "Unset" : "Set") directive has no variable name “\(aLine)”")
        }
        let varName = String(matches[2])
        if !_isGoodVarName(varName) {
            throw JXAPPDetectorError(because:
                    "\(isUnset ? "Unset" : "Set") directive has invalid variable name “\(aLine)”")
        }
        if !matches[5].isEmpty {
            throw JXAPPDetectorError(because:
                    "\(isUnset ? "Unset" : "Set") directive is invalid “\(aLine)”")
        }
        let hasValue: Bool = !matches[3].isEmpty
        if isUnset {
            if hasValue {
                throw JXAPPDetectorError(because:
                        "Unset directive can not set a value “\(aLine)”")
            }
            return JXAPPDetection(
                    directive: .unset,
                    workload: varName
                    )
        } else {
            return JXAPPDetection(
                    directive: .set,
                    workload: [
                            varName,
                            hasValue
                                ? String(matches[4])
                                : "1"
                            ])
        }
    }

    private func _isGoodVarName(_ aStr: String) -> Bool {
        switch JXAPPOptions.shared.varNamesRule {
            case .relaxed:
                return aStr.isAllowedEnvironmentVariableName
            case .normal:
                return aStr.isValidEnvironmentVariableName
            case .strict:
                return aStr.isStrictlyValidEnvironmentVariableName
        }
    }
}
