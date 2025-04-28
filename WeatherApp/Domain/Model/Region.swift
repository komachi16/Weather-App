enum Region: CaseIterable, Hashable {
    case tokyo
    case hyogo
    case oita
    case hokkaido

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
        }
    }
}
