import Foundation
import Iwstb

class JXAPPOptionsError: IwstbError {}

class JXAPPOptions {
    static var shared = JXAPPOptions()

    public enum VarNamesRule {
        case relaxed
        case normal
        case strict
    }

    var compiling: Bool = false
    var showHelpAndExit: Bool = false
    var mainJxa: String? = nil
    var extraArgs: [String]? = nil
    var environment: [String:String] = ProcessInfo.processInfo.environment
    var varNamesRule: VarNamesRule = .normal
    var shebang: String = "#!/usr/bin/env osascript -l JavaScript"
    var outputShebang: Bool = false
    var keepShebang: Bool = false

    private let _envNameValidatorRe
            = Iwstb.cookRegexer(#"^[a-zA-Z_][a-zA-Z_0-9]*$"#)!

    private func _validateEnvName(_ aName: String) throws {
        if _envNameValidatorRe.search(aName) == nil {
            throw JXAPPOptionsError(because:
                    "Name “\(aName)” is not valid for an environment variable")
        }
    }

    func getCommandLineOptions() throws {
        let getopter = Iwstb.cookGetopter(":hcnNksS:e:E:")

        for res in getopter {
            if res.option == "h" {
                showHelpAndExit = true
            } else if res.option == "c" {
                compiling = true
            } else if res.option == "n" {
                varNamesRule = .relaxed
            } else if res.option == "N" {
                varNamesRule = .strict
            } else if res.option == "k" {
                outputShebang = true
                keepShebang = true
            } else if res.option == "s" {
                outputShebang = true
            } else if res.option == "S" {
                guard let arg = res.argument else {
                    // This shouldn't happen unless there's an error in Getopter
                    throw JXAPPOptionsError(because: "No argument to the “-S” option")
                }
                let count = arg.count
                if count == 0 {
                    throw JXAPPOptionsError(because: "The shebang is empty")
                }
                if arg == "#" || arg == "!" || arg == "#!" {
                    throw JXAPPOptionsError(because: "The shebang is invalid")
                }
                let chars = [Character](arg)
                if count > 1 && (chars[0] == "#" || chars[0] == "!") {
                    if count > 2 && chars[1] == "!" {
                        shebang = arg
                    } else {
                        shebang = "#!\(String(chars[1...]))"
                    }
                } else if count > 0 {
                    shebang = "#!\(arg)"
                } else {
                    // This shouldn't happen unless there's an error in Getopter
                    throw JXAPPOptionsError(because: "Strange argument to the “-S” option")
                }
                outputShebang = true
                keepShebang = false
            } else if res.option == "e" {
                guard let arg = res.argument else {
                    // This shouldn't happen unless there's an error in Getopter
                    throw JXAPPOptionsError(because: "No argument to the “-e” option")
                }
                if let equalsIndex = arg.firstIndex(of: "=") {
                    let name = String(arg[..<equalsIndex])
                    try _validateEnvName(name)
                    environment[name]
                            = String(arg[arg.index(after: equalsIndex)...])
                } else {
                    try _validateEnvName(arg)
                    environment[arg] = "1"
                }
            } else if res.option == "E" {
                guard let arg = res.argument else {
                    // This shouldn't happen unless there's an error in Getopter
                    throw JXAPPOptionsError(because: "No argument to the “-E” option")
                }
                try _validateEnvName(arg)
                environment.removeValue(forKey: arg)
            }
        }

        if let args = getopter.remaining {
            mainJxa = args[0]
            if args.count > 1 {
                extraArgs = Array(args[1...])
            }
        }
    }
}
