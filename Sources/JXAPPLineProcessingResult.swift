import Foundation

enum JXAPPLineProcessingResult: Equatable {
    case noop
    case pop
    case replace(with: JXAPPLineProcessor)
    case retry(withReplacement: JXAPPLineProcessor)
    case push(
            startingWith: JXAPPLineProcessor,
            untilPoppers: Set<JXAPPDirective>,
            replacingWith: JXAPPLineProcessor
            )
    case error

    static func == (
            lhs: JXAPPLineProcessingResult,
            rhs: JXAPPLineProcessingResult) -> Bool
            {
        switch lhs {
            case .noop:
                switch rhs {
                    case .noop:
                        return true
                    case .pop:
                        return false
                    case .push:
                        return false
                    case .replace:
                        return false
                    case .retry:
                        return false
                    case .error:
                        return false
                }
            case .pop:
                switch rhs {
                    case .noop:
                        return false
                    case .pop:
                        return true
                    case .push:
                        return false
                    case .replace:
                        return false
                    case .retry:
                        return false
                    case .error:
                        return false
                }
            case let .push(
                    startingWith: leftInnerProcessor,
                    untilPoppers: leftPoppers,
                    replacingWith: leftProcessor
                    ):
                switch rhs {
                    case .noop:
                        return false
                    case .pop:
                        return false
                    case let .push(
                            startingWith: rightInnerProcessor,
                            untilPoppers: rightPoppers,
                            replacingWith: rightProcessor
                            ):
                        return leftInnerProcessor.id == rightInnerProcessor.id
                            && leftPoppers == rightPoppers
                            && leftProcessor.id == rightProcessor.id
                    case .replace:
                        return false
                    case .retry:
                        return false
                    case .error:
                        return false
                }
            case let .replace(with: leftProcessor):
                switch rhs {
                    case .noop:
                        return false
                    case .pop:
                        return false
                    case .push:
                        return false
                    case let .replace(with: rightProcessor):
                        return leftProcessor.id == rightProcessor.id
                    case .retry:
                        return false
                    case .error:
                        return false
                }
            case let .retry(withReplacement: leftProcessor):
                switch rhs {
                    case .noop:
                        return false
                    case .pop:
                        return false
                    case .push:
                        return false
                    case .replace:
                        return false
                    case let .retry(withReplacement: rightProcessor):
                        return leftProcessor.id == rightProcessor.id
                    case .error:
                        return false
                }
            case .error:
                switch rhs {
                    case .noop:
                        return false
                    case .pop:
                        return false
                    case .push:
                        return false
                    case .replace:
                        return false
                    case .retry:
                        return false
                    case .error:
                        return true
                }
        }
    }
}
