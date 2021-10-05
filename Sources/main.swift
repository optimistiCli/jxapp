import Foundation
import Iwstb

/**
 * There's currently no reflection to speak of in Swift, also there's no init 
 * for static entities like classes, structs etc.
 */
func init_static_stuff_that_swift_cannot_init() {
    // TODO: Move to toolbox
    _ = JXAPPDetectorInclude.shared
    _ = JXAPPDetectorIfSetUnset.shared
    _ = JXAPPDetectorFiElse.shared
    _ = JXAPPDetectorSetUnset.shared
}

fileprivate func main() -> Int32 {
    init_static_stuff_that_swift_cannot_init()

    Iwstb.updateUsage(with:
        """
        JXA pre-processor v.\(JXAPPVersion.string)

        Usage:
          $PROG [-h] [-c [-s | -S <shebang> | -k]] [-n|-N]
                [-e <name>[=[<value>]]] [-E <name>] <main JXA file>

        Implements basic pre-processor functionality like including source files
        and conditional processing of source code. All JXA files are expected to
        be in UTF-8 with Unix EOLs.\u{2702}

        Options:
          h - Show help and exit
          c - Compile mode, the resulting code is written to stdout
          e - Set the environment variable; if both equals sign and value are
              ommited then the variable is set to default value of “1”; if only the
              value is ommited the variable is set to an empty string, but it is
              still considered set by the directives; this option can be specified
              multiple times
          E - Unset the environment variable; this option can be specified multiple
              times
          N - Use strict rules for environment variable names, only capital leters,
              digits and “_” are allowed, first character must not be a digit;
              if ommited small letters are also allowed
          n - Use relaxed rules for environment variable names, all characters in
              the portable charset except for “=” and NUL are allowed
          s - Prepend compiled output with the default shebang:
                #!/usr/bin/env osascript -l JavaScript
          S - Prepend compiled output with specified shebang; the “#!” prefix can
              be ommited
          k - Keep shebang of the main JXA file; if it has no shebang then the
              default one is used

        Running mode:
          To run JXA file from command line just put the full path to the pre-
          processor in your script's shebang. Should look similar to this:
            #!/usr/local/bin/$PROG

          Now make you script executable and you're good to go.
            chmod a+x yourscript.js

          In running mode environment variable JXAPP_RUNNING is set and JXAPP_COMPILING
          is unset both while pre-processing and when the JXA script is run.

        Compiling mode:
          When run with the -c option pre-processor prints the “compiled” JXA script to
          STDOUT. It can then be packaged and / or distributed.

          In compiling mode environment variable JXAPP_COMPILING is set and
          JXAPP_RUNNING is unset while pre-processing. Neither is available to the
          running JXA script.

        Directives:
          Pre-processor directives consist of a double slash immedeately followed by
          directive name. Some directives require adiitional parameters. A directive can
          be preceded by blanks. Each directive must reside on a separate line.

          Include:
            The include directive includes another source file:
              //include some.js
              //include "yet/another.js"
              //include '../otherproject/other.js'

            The include-once variation does exactly the same but any prticular file
            will only get included once:
              //include-once lib/regex.js

            All paths are relative to the the JXA file that mentions them.

          If set / unset:
            The if-set directive lets the code through only if the specified
            environment variable is defined:
              //if-set DEBUG_CLI
                <code>
              //else-if-set DEBUG_GUI
                <code>
              //else
                <code>
              //fi

            The if-unset directive works the other way round. It lets the code through
            if the environment variable is undefined:
              //if-unset "$SHELL"
                <code>
              //else-if-unset "$BASH"
                <code>
              //else
                <code>
              //fi

          Set / unset:
            The set and unset directives can be used to manipulate the environment:
              //set SOME_VAR
              //if-set SOME_VAR
                <code>
              //fi
              <code>
              //unset SOME_VAR
              //if-unset SOME_VAR
                <code>
              //fi
              <code>
              //set SOME_VAR = I love JXA
              //if-set SOME_VAR
                <code>
              //fi

            The set directive assigns the environment variable with everithing after the
            equals sign sans leading and trailing blanks. If both equals sign and value
            are ommited then the variable is assigned the default value of “1”. If only
            the value is ommited then the variable is set to an empty string, but it is
            still considered set by any following directives.

            In the run mode all the environment manipulations persist during the
            script's execution. In compile mode they are all lost.

        Shebangs:
          By default all shebangs and following empty lines in processed files are
          discarded. To put or keep a shebang in the compiled output use one of the -s,
          -S and -k options. Those options have no effect in the runnung mode.
        """
    )

    do {
        let opts = JXAPPOptions.shared
        try opts.getCommandLineOptions()
        if opts.showHelpAndExit {
            Iwstb.log(Iwstb.usageLong)
            return 0
        }
        if opts.mainJxa == nil {
            return Iwstb.brag("No main JXA file in arguments")
        }
        let context = try JXAPPContextCooker.cookContext()
        try context.processJxa(URL.init(fileURLWithPath: opts.mainJxa!))
        return try context.wrapUp()
    } catch {
        return Iwstb.brag(error)
    }
}

exit(main())
