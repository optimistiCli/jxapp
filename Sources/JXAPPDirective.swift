import Foundation

enum JXAPPDirective: Int, CustomStringConvertible {
    var description: String {
        switch self {
            case .include:       return "include"
            case .include_once:  return "include_once"
            case .if_set:        return "if-set"
            case .if_unset:      return "if-unset"
            case .fi:            return "fi"
            case .else:          return "else"
            case .set:           return "set"
            case .unset:         return "unset"
            case .else_if_set:   return "else-if-set"
            case .else_if_unset: return "else-if-unset"
        }
    }

    case include       = 1
    case include_once  = 2
    case if_set        = 4
    case if_unset      = 8
    case fi            = 16
    case `else`        = 32
    case set           = 64
    case unset         = 128
    case else_if_set   = 256
    case else_if_unset = 512
}
