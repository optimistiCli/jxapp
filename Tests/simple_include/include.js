ObjC.import('Foundation')

function print(s) {
    $.NSFileHandle.fileHandleWithStandardOutput.writeData(
            $.NSString.alloc.initWithString(String(s) + "\n").dataUsingEncoding($.NSUTF8StringEncoding)
            )
}
