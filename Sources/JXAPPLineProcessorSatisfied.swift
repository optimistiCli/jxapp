import Foundation

/**
 * Waits while an inner parser goes thru a block. Basically it only
 * processes if-ending directives, anything else causes an error.
 */
class JXAPPLineProcessorSatisfied:
        JXAPPLineProcessorAbstractIfBranchWithResult {
    static var shared = JXAPPLineProcessorSatisfied()

    override /* protected */ func _cookResults() -> _Results {
        return (
                fi: .replace(with: JXAPPLineProcessorGeneral.shared),
                else: .push(
                        startingWith: JXAPPLineProcessorGeneralUnsatisfied.shared,
                        untilPoppers: JXAPPLineProcessorAbstractIfBranch.branchPoppers,
                        replacingWith: JXAPPLineProcessorUnsatisfiedTerminal.shared
                        ),
                else_if_set: nil,
                else_if_unset: nil
                )
    }
}
