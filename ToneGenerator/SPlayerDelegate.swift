//
//  Protocol.swift
//  Quantum Frequency
//
//  Created by Karina on 29.07.16.
//  Copyright © 2016 Karina. All rights reserved.
//

import UIKit

protocol SPlayerDelegate: class {
/// Notify the delegate, that player did finish playing.
    func didFinishPlaying()
/// Notify the delegate, that player did start play tone
    func didStartPlayTone(_ index: Int, length: Int)
}
