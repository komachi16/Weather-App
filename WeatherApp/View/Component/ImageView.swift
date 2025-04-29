import CachedAsyncImage
import SwiftUI

struct ImageView: View {
    let imageUrl: String

    var body: some View {
        CachedAsyncImage(url: URL(string: imageUrl))
    }
}

#Preview {
    ImageView(imageUrl: "https://openweathermap.org/img/wn/10d@2x.png")
}
