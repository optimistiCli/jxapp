import Foundation

import Iwstb

class JxaPPParserError: Iwstb.Error {}

class JxaPPParser {
    private struct _DDRe {
        static let include: Regexer = Iwstb.cookRegexer(
                //                 1                            2          3      4     5       6
                #"^\s*//include(?:-(once))?(?:(?:\b(?:\s*(?:(?:"(.+)")|(?:'(.+)')|(\S+)|(.*))))|(.*))$"#)!
        static let ifSetUnset: Regexer = Iwstb.cookRegexer(
                //            1                                       2              3             4      5       6
                #"^\s*//if-(?:(set)|(?:unset))(?:(?:\b(?:\s+(?:(?:"\$?(\S+)")|(?:'\$?(\S+)')|(?:\$?(\S+))|(.*))))|(.*))$"#)!
        static let fiElse: Regexer = Iwstb.cookRegexer(
                //         1                2       3
                #"^\s*//(?:(fi)|(?:else))(?:(\s+\S)|(.))?"#)!
    }

    private enum _Directive {
        case include
        case include_once
        case if_set
        case if_unset
        case fi
        case elseDirective
    }

    private struct _Detection {
        let directive: _Directive
        let workload: String

        init(directive aDirective: _Directive, workload aWorkload: String = "") {
            directive = aDirective
            workload = aWorkload
        }
    }

    private class _ParserStack {
        private lazy var _array = [JxaPPParser]()

        func setTopmost(_ aParser: JxaPPParser) {
            push(aParser)
        }

        func push(_ aParser: JxaPPParser) {
            _array.append(aParser)
        }

        var innermost: JxaPPParser {
            return _array.last!
        }

        func pop() {
            _array.removeLast()
        }
    }

    /* ***
     * The wrapper object for contextual processor.
     * 
     * Should return false if the line was suffciently processed and parser
     * should proceed to the next line. If true is returned then pasrer will
     * call the processor with the same line again hence it's up to processor
     * to update this var before returning true.
     *
     * The whole wrapper object debarcle is needed since swift compiler, in its 
     * own words “cannot check reference equality of functions”, see onEof.
     */
    private class _Processor {
        let process: (String) throws -> Bool
        
        init(_ aProcess:@escaping (String) throws -> Bool) {
            process = aProcess
        }
    }
    private lazy var _general = _Processor(_processGeneral)
    private lazy var _satisfied = _Processor(_processSatisfied)
    private lazy var _unsatisfied = _Processor(_processUnsatisfied)
    private lazy var _processor = _general

    private let _context: JxaPPContext
    private let _selfStack: _ParserStack
    private let _poppers: Set<_Directive>?

    init(_ aContext: JxaPPContext) throws {
        _context = aContext
        _selfStack = _ParserStack()
        _poppers = nil

        _selfStack.setTopmost(self)
    }

    private init(
            within aEnclosing: JxaPPParser,
            poppers aPoppers: Set<_Directive>
            ) {
        _context = aEnclosing._context
        _selfStack = aEnclosing._selfStack
        _poppers = aPoppers
    }

    /* ****
     * aLine must be devoid of whitespaces on the right.
     */
    func process(_ aLine: String) throws {
        while try _selfStack.innermost._processor.process(aLine) {}
    }

    func onEof() throws {
        if _selfStack.innermost._processor !== _selfStack.innermost._general {
            throw JxaPPParserError(because: "A closing fi directive is missing")
        }
    }

    private func _detectInclude(_ aLine: String) throws -> _Detection? {
//        print("DEBUG: \(#function) aLine=\(aLine)")
        if let matches = _DDRe.include.search(aLine) {
//            print("DEBUG: \(matches)")
            let gotGoodWorkload: Bool = !(matches[4].isEmpty && matches[2].isEmpty && matches[3].isEmpty)
            let gotBadWorkload: Bool = !matches[5].isEmpty
            let gotConjointSuspect: Bool = !matches[6].isEmpty
            let gotOnce: Bool = !matches[1].isEmpty

            if gotGoodWorkload {
                return _Detection(
                        directive: gotOnce
                            ? .include_once
                            : .include,
                        workload: "\(matches[2])\(matches[3])\(matches[4])"
                        )
            } else if gotBadWorkload {
                throw JxaPPParserError(because:
                        "\(gotOnce ? "Include-once" : "Include") directive has strange path “\(aLine)”")
            } else if gotConjointSuspect {
                _context.warning(
                        "Possibly missing a whitespace in an \(gotOnce ? "include-once" : "include") directive “\(aLine)”")
                return nil
            } else {
                throw JxaPPParserError(because:
                        "\(gotOnce ? "Include-once" : "Include") directive without path “\(aLine)”")
            }
        } else {
            return nil
        }
    }

    private func _detectIfSetUnset(_ aLine: String) throws -> _Detection? {
        if let matches = _DDRe.ifSetUnset.search(aLine) {
            let isUnset: Bool = matches[1].isEmpty
            let gotGoodWorkload: Bool = !(matches[4].isEmpty && matches[2].isEmpty && matches[3].isEmpty)
            let gotBadWorkload: Bool = !matches[5].isEmpty
            let gotConjointSuspect: Bool = !matches[6].isEmpty

            if gotGoodWorkload {
                return _Detection(
                        directive: isUnset
                            ? .if_unset
                            : .if_set
                            ,
                        workload: "\(matches[2])\(matches[3])\(matches[4])"
                        )
            } else {
                let directiveName = isUnset
                        ? "If-unset"
                        : "If-set"
                if gotBadWorkload {
                    throw JxaPPParserError(because:
                            "\(directiveName) directive references strange variable “\(aLine)”")
                } else if gotConjointSuspect {
                    _context.warning(
                            "Possibly missing a whitespace in an \(directiveName) directive “\(aLine)”")
                    return nil
                } else {
                    throw JxaPPParserError(because:
                            "\(directiveName) directive without variable “\(aLine)”")
                }
            }
        } else {
            return nil
        }
    }

    private func _detectFiElse(_ aLine: String) throws -> _Detection? {
        if let matches = _DDRe.fiElse.search(aLine) {
            let isElse: Bool = matches[1].isEmpty
            let gotBadWorkload: Bool = !matches[2].isEmpty
            let gotConjointSuspect: Bool = !matches[3].isEmpty

            if gotBadWorkload {
                throw JxaPPParserError(because:
                        "\(isElse ? "Else" : "Fi") directive should have no parameters “\(aLine)”")
            } else if gotConjointSuspect {
                _context.warning(
                        "Possibly a misspelled \(isElse ? "else" : "fi") directive “\(aLine)”")
                return nil
            } else {
                return _Detection(directive: isElse
                    ? .elseDirective
                    : .fi
                    )
            }
        } else {
            return nil
        }
    }

    /* ***
     * Default context. Processes include, if-set and if-unset directives. Any
     * other directive should produce an error. All if* directives cause both
     * switching to another appropriate context and, if condition is satisfied,
     * andcreation of a sub-parser via the self stack machinery. When it finds
     * an if-closing directive a sub-parser pops itself from the self stack and
     * returns control to the enclosing parser, alowing it to process the same
     * line.
     */
    private func _processGeneral(_ aLine: String) throws -> Bool {
        if let detection = try _detectInclude(aLine)
                ?? _detectIfSetUnset(aLine)
                ?? _detectFiElse(aLine) {
            if let poppers = _poppers, poppers.contains(detection.directive) {
                // Time to pop self and hand back control to enclosing parser
                _selfStack.pop()
                return true
            }
            switch detection.directive {
                case .include:
                    let url = _context.cookJxaUrl(detection.workload)
                    try _context.processJxa(url)
                    return false
                case .include_once:
                    let url = _context.cookJxaUrl(detection.workload)
                    if !_context.wasOnceIncluded(url) {
                        _context.declareOnceIncluded(url)
                        try _context.processJxa(url)
                    }
                    return false
                case .if_set:
                    if ProcessInfo.processInfo.environment[detection.workload] == nil {
                        _processor = _unsatisfied
                        return false
                    } else {
                        _processor = _satisfied
                        _selfStack.push(JxaPPParser(within: self, poppers: [.elseDirective, .fi]))
                        return false
                    }
                case .if_unset:
                    if ProcessInfo.processInfo.environment[detection.workload] == nil {
                        _processor = _satisfied
                        _selfStack.push(JxaPPParser(within: self, poppers: [.elseDirective, .fi]))
                        return false
                    } else {
                        _processor = _unsatisfied
                        return false
                    }
                default:
                    throw JxaPPParserError(because:
                            "Unexpected directive in general context “\(aLine)”")
            }
        } else {
            try _context.out(aLine)
            return false
        }
    }

    /* ***
     * Waits while an inner parser goes thru a block. Basically it only
     * processes if-ending directives, anything else causes an error.
     */
    private func _processSatisfied(_ aLine: String) throws -> Bool {
        if let detection = try _detectFiElse(aLine) {
            switch detection.directive {
                case .fi:
                    _processor = _general
                    return false
                case .elseDirective:
                    _processor = _unsatisfied
                    return false
                default:
                    // We shouldn't ever get here so it's a programing error
                    throw JxaPPParserError(because:
                            "Unexpected directive in satisfied context “\(aLine)”")
            }
        } else {
            return false
        }
    }

    /* ***
     * Goes thru blocks that shouldn't get in the output. Basically does
     * nothing, just waits for an if-ending directive to switch to general
     * context
     */
    private func _processUnsatisfied(_ aLine: String) throws -> Bool {
        if let detection = try _detectFiElse(aLine) {
            switch detection.directive {
                case .fi:
                    _processor = _general
                    return false
                case .elseDirective:
                    _processor = _satisfied
                    _selfStack.push(JxaPPParser(within: self, poppers: [.elseDirective, .fi]))
                    return false
                default:
                    // We shouldn't ever get here so it's a programing error
                    throw JxaPPParserError(because:
                            "Unexpected directive in unsatisfied context “\(aLine)”")
            }
        } else {
            return false
        }
    }
}
