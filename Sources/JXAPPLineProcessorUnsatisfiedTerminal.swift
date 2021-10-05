import Foundation

/**
 * Goes thru blocks that shouldn't get in the output and no firther block in this if will. Basically does
 * nothing, just waits for an if-ending directive to switch to general line processor.
 */
class JXAPPLineProcessorUnsatisfiedTerminal:
        JXAPPLineProcessorAbstractIfBranchWithResult {
    static var shared = JXAPPLineProcessorUnsatisfiedTerminal()

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
