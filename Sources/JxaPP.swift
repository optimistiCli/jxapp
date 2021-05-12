import Foundation

import Iwstb

class JxaPP {
    private let _context: JxaPPContext

    init(_ aContext: JxaPPContext) {
        _context = aContext
    }

    func parse(_ aJxaUrl: URL) throws {
        let lineReader = try Iwstb.cookLineReader(aJxaUrl)
        _context.pushUrl(lineReader.url)
        let parser = try JxaPPParser(_context)
        var lineNum: Int = 0
        for line in lineReader {
            lineNum += 1
            _context.setCurrentLineNum(lineNum)
            try parser.process(String(line))
        }
        _context.resetCurrentLineNum()
        try parser.onEof()
        _context.popUrl()
    }
}
