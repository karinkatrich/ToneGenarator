//
//  SequencePlayer.swift
//  Quantum Frequency
//
//  Created by Karina on 29.07.16.
//  Copyright © 2016 Karina. All rights reserved.
//

import UIKit


private let gPlayer = SequencePlayer(s:FMSynthesizer.sharedSynth())

class SequencePlayer {
    
    
    fileprivate var sequence: QFSequence?
    fileprivate var synthesizer : FMSynthesizer!
    fileprivate var timer: Timer?
    fileprivate var isPlaying : Bool
    fileprivate var currentToneIndex: Int
    weak var delegate: SPlayerDelegate?
    
    class func sharedPlayer() -> SequencePlayer {
        return gPlayer
    }
    
    init (s: FMSynthesizer!) {
        synthesizer = s
        isPlaying = false
        currentToneIndex = 0
    }
    
    func playing() -> Bool {
        return isPlaying
    }
    
    func stop() {
        synthesizer.stop()
        timer!.invalidate()
        currentToneIndex = 0
        isPlaying = false
        delegate?.didFinishPlaying()
    }
    
    
    func playSequence(_ s:QFSequence!, sPlayerDelegate:SPlayerDelegate!) {
        if isPlaying {
            stop()
            delegate?.didFinishPlaying()
        }
        sequence = s
        delegate = sPlayerDelegate
        playCurrentTone()
    }
    
    func playCurrentTone() {
        
        let currentTone = sequence!.tones[currentToneIndex]
        
        delegate?.didStartPlayTone(currentToneIndex, length: currentTone.length)
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(currentTone.length), target: self, selector: #selector(didRecieveTimerEvent), userInfo: nil, repeats: false)
        
        self.synthesizer!.play(Float32(currentTone.frequency))
        isPlaying = true
    }
    
    
    @objc func didRecieveTimerEvent() {
        synthesizer.stop()
        
        currentToneIndex += 1

        if currentToneIndex == sequence!.tones.count {
            stop()
            return
        }
        
        playCurrentTone()
    }
}


