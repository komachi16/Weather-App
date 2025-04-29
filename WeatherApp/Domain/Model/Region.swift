import CoreLocation

enum Region: Hashable {
    static var allRegions: [Region] = [.tokyo, .hyogo, .oita, .hokkaido]

    case tokyo
    case hyogo
    case oita
    case hokkaido
    case current(location: CLLocation)

    var code: String {
        switch self {
        case .tokyo:
            return "Tokyo"
        case .hyogo:
            return "Hyogo"
        case .oita:
            return "Oita"
        case .hokkaido:
            return "Hokkaido"
        case .current:
            return ""
        }
    }

    var name: String {
        switch self {
        case .tokyo:
            return "東京"
        case .hyogo:
            return "兵庫"
        case .oita:
            return "大分"
        case .hokkaido:
            return "北海道"
        case .current:
            return "現在地"
        }
    }
}
