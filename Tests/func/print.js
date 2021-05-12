//include-once   '../fw/foundation.js'

function print(s) {
    $.NSFileHandle.fileHandleWithStandardOutput.writeData(
            $.NSString.alloc.initWithString(String(s)).dataUsingEncoding($.NSUTF8StringEncoding)
            )
}
