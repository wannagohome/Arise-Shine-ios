//
//  VIPSection.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/30.
//

import RxDataSources

struct VIPSection {
    var header: String
    var items: [VIP]
}

extension VIPSection: SectionModelType {
    typealias Item = VIP
    
    init(original: VIPSection, items: [VIP]) {
        self = original
        self.items = items
    }
}
