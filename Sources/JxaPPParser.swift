import Foundation
import Iwstb

class JXAPPParserError: IwstbError {}

class JXAPPParser {
    private class _CodeBlock {
        var processor: JXAPPLineProcessor
        let poppers: Set<JXAPPDirective>?

        init(
                processor aProcessor: JXAPPLineProcessor,
                poppers aPoppers: Set<JXAPPDirective>?
                ) {
            self.processor = aProcessor
            self.poppers = aPoppers
        }

        @inlinable func process(
                _ aLine: String,
                in aContext: JXAPPContext
                ) throws -> JXAPPLineProcessingResult {
            return try processor.process(
                    aLine,
                    in: aContext,
                    poppingOn: poppers
                    )
        }
    }

    private class _CodeBlockStack {
        private lazy var _array = [_CodeBlock]()

        @inlinable func push(_ aCodeBlock: _CodeBlock) {
            _array.append(aCodeBlock)
        }

        @inlinable var innermost: _CodeBlock {
            return _array.last!
        }

        @inlinable func pop() {
            _array.removeLast()
        }

        @inlinable var depth: Int {
            _array.count
        }
    }

    private let _context: JXAPPContext
    private let _codeBlockStack: _CodeBlockStack

    init(_ aContext: JXAPPContext) throws {
        _context = aContext
        _codeBlockStack = _CodeBlockStack()
        _codeBlockStack.push(_CodeBlock(
                processor: JXAPPLineProcessorShebangRemover.shared,
                poppers: nil
                ))
    }

    func process(_ aLine: String) throws {
        while try _processWorker(aLine) {}
    }

    /**
     * Returns true if the same line should be processed again
     */
    @inlinable /* private */ func _processWorker(_ aLine: String) throws -> Bool {
        let currentCodeBlock = _codeBlockStack.innermost
        switch try currentCodeBlock.process(aLine, in: _context) {
            case .noop:
                return false
            case .pop:
                _codeBlockStack.pop()
                return true
            case let .replace(with: newProcessor):
                currentCodeBlock.processor = newProcessor
                return false
            case let .retry(withReplacement: newProcessor):
                currentCodeBlock.processor = newProcessor
                return true
            case let .push(
                    startingWith: innerProcessor,
                    untilPoppers: newPoppers,
                    replacingWith: newProcessor
                    ):
                currentCodeBlock.processor = newProcessor
                _codeBlockStack.push(_CodeBlock(
                        processor: innerProcessor,
                        poppers: newPoppers
                        ))
                return false
            default:
                // This can only be a result of a programming error
                throw JXAPPParserError(because: "A closing fi directive is missing")
        }
    }

    func onEof() throws {
        if _codeBlockStack.innermost.processor.id != JXAPPLineProcessorGeneral.shared.id {
            throw JXAPPParserError(because: "A closing fi directive is missing")
        }
    }
}
