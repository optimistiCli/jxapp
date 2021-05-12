import Foundation

import Iwstb

fileprivate func main() -> Int32 {
    Iwstb.updateUsage(with:
        """
        Usage:
          $PROG [-h] [-c] <main JXA file>

          JXA pre-processor. All JXA files must be in UTF-8 with Unix EOLs.\u{2702}

        Options:
          h - Show help and exit
          c - Compile mode, the resulting code is written to stdout

        To run JXA file from command line just put the full path to the pre-
        processor in your script's shebang. Shuld look similar to this:
          #!/usr/local/bin/$PROG

        Now make you script executable and you're good to go.
          chmod a+x yourscript.js

        The include directive includes another source file:
          //include some.js
          //include "yet/another.js"
          //include '../otherproject/other.js'

        The include-once variation does exactly the same but any prticular file will 
        only get included once:
          //include-once lib/regex.js

        The if-set directive lets the code through only if the specified environment 
        variable is defined:
          //if-set DEBUG
            <code>
          //else
            <code>
          //fi

        The if-unset directive works the other way round. It lets the code through if 
        the environment variable is undefined:
          //if-unset "$COMPILE"
            <code>
          //else
            <code>
          //fi

        All paths are relative to the the JXA file that mentions them. Directives must 
        reside on separate lines.
        """
    )

    let opts = Options.shared
    opts.getCommandLineOptions()

    if opts.showHelpAndExit {
        Iwstb.log(Iwstb.usageLong)
        return 0
    }

    if opts.mainJxa == nil {
        return Iwstb.brag("No main JXA file in arguments")
    }

    var retVal: Int32 = 0
    do {
        let context: JxaPPContext = opts.compiling
            ? try CompileContext()
            : try ExecContext()
        try context.processJxa(URL.init(fileURLWithPath: opts.mainJxa!))
        retVal = try context.wrapUp()
    } catch {
        return Iwstb.brag(error)
    }

    return retVal
}

exit(main())
