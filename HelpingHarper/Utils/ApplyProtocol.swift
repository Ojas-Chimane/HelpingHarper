//
//  ApplyProtocol.swift
//  HelpingHarper
//
//  Created by Ojas Chimane on 15/5/20.
//  Copyright © 2020 HelpingHarper. All rights reserved.
//

import Foundation

protocol ApplyProtocol { }
extension ApplyProtocol {
    @discardableResult
    func apply(closure: (Self) -> ()) -> Self {
        closure(self)
        return self
    }
}
