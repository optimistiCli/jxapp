import Foundation

class JXAPPLineProcessorIrrelevantUnsatisfied:
        JXAPPLineProcessorAbstractIfBranchWithResult {
    static var shared = JXAPPLineProcessorIrrelevantUnsatisfied()

    override /* protected */ func _cookResults() -> _Results {
        return (
                fi: .replace(with: JXAPPLineProcessorGeneralUnsatisfied.shared),
                else: .push(
                    startingWith: JXAPPLineProcessorGeneralUnsatisfied.shared,
                    untilPoppers: JXAPPLineProcessorAbstractIfBranch.branchPoppers,
                    replacingWith: JXAPPLineProcessorIrrelevantUnsatisfied.shared
                    ),
                else_if_set: nil,
                else_if_unset: nil
                )
    }
}
