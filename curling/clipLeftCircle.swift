//
//  clipLeftCircle.swift
//  curling
//
//  Created by 武藤 颯汰 on 2023/03/18.
//

import SwiftUI

struct clipLeftCircle: View {
    var body: some View {
        Rectangle()
                    .overlay() {
                        Circle()
                            .frame(width: 500)
                            .blendMode(.destinationOut)
                    }
                    .compositingGroup()
    }
}

struct clipLeftCircle_Previews: PreviewProvider {
    static var previews: some View {
        clipLeftCircle()
    }
}
