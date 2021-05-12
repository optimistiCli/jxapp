import Foundation

import Iwstb

class Options {
    static var shared = Options()

    var compiling: Bool = false
    var showHelpAndExit: Bool = false
    var mainJxa: String? = nil
    var extraArgs: [String]? = nil

    func getCommandLineOptions() {
        let getopter = Iwstb.cookGetopter("hc")

        for res in getopter {
            if res.option == "h" {
                showHelpAndExit = true
            } else if res.option == "c" {
                compiling = true
            }
        }

        guard let args = getopter.remaining else {
            return
        }
        mainJxa = args[0]
        if args.count > 1 {
            extraArgs = Array(args[1...])
        }
    }
}
