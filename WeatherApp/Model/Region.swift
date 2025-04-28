enum Region: CaseIterable {
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
}
