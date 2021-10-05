import Foundation
import Iwstb

/*
 *                                  *       [G]
 *                                  |        |
 *                                  v        |
 *                               SHEBANG     |
 *                                  |        |
 *               first line of code |        |
 *                                  |  +-----+
 *                                  |  |
 *                                  |  |
 *  +----------------------------+  |  |
 *  |                            |  |  |
 *  |                            v  v  v
 *  |      +-------------------->GENERAL<----------------+
 *  |      |                      |   |                  |
 *  |      |                      |   |                  |
 *  |      |            [G] <= if |   | if => [GU]       |
 *  |      |         +------------+   +--------------+   |
 *  |      |         |                               |   |
 *  |   fi |         |                               |   | fi
 *  |      |         v                               v   |
 *  |      +-------SATISFIED<---------------------UNSATISFIED_H
 *  |                    |        [G] <= else      |         ^
 *  |       else => [GU] |       [G] <= else-if    |         |
 *  |    else-if => [GU] |                         +---------+
 *  |                    |                       else-if => [GU]
 *  |                    |
 *  |         fi         v
 *  +-------------UNSATISFIED_T
 *                 |         ^
 *                 |         |
 *                 +---------+
 *                 else => [GU]
 *                else-if => [GU]
 *
 *                                                         
 *                 [GU]
 *                  |
 *                  v
 *              GENERAL_UNS
 *               /       ^
 *              /         \
 *  [GU] <= if +           + fi
 *              \         /
 *               v       /
 *             IRRELEVANT_UNS
 *                |     ^
 *                |     |
 *                +-----+
 *              else => [GU]
 *             else-if => [GU]
 */

class JXAPPLineProcessorError: IwstbError {}

protocol JXAPPLineProcessor {
    var id: String { get }
    func process(
            _ aLine: String,
            in aContext: JXAPPContext,
            poppingOn aPoppers: Set<JXAPPDirective>?
            ) throws -> JXAPPLineProcessingResult
}

extension JXAPPLineProcessor {
    var id: String {
        "\(Self.self)"
    }

    /* protected */ static func _detectorHelper(_ aDirectives: Set<JXAPPDirective>) -> JXAPPDetector {
        do {
            return try JXAPPDetectorsRegistery.shared
                    .getDetector(forDirectives: aDirectives)
        } catch {
            fatalError(String(describing: error))
        }
    }

    /* protected */ static func _detectorWarningHelper(
            _ aLine: String,
            detector aDetector: JXAPPDetector,
            messageHandler aHandler: ((String)->())
            ) throws -> JXAPPDetection? {
        do {
            guard let detection = try aDetector.detect(aLine) else {
                return nil
            }
            return detection
        } catch let error as JXAPPDetectorWarning {
            aHandler(error.reason)
        }
        return nil
    }

    /* protected */ func _ifHelper(
            detection aDetection: JXAPPDetection,
            ifSet aSet: JXAPPLineProcessingResult,
            ifUnset aUnet: JXAPPLineProcessingResult
            ) throws -> JXAPPLineProcessingResult {
        guard let name = aDetection.workload?[0] else {
            // This should never happen
            throw JXAPPLineProcessorError(because:
                    "Malformed directive detection result")
        }
        return JXAPPOptions.shared.environment[name] == nil
            ? aUnet
            : aSet
    }
}
