//
//  FMSyntizer.swift
//  Quantum Frequency
//
//  Created by Karina on 26.07.16.
//  Copyright © 2016 Karina. All rights reserved.
//

import Foundation
import AVFoundation
import Foundation

// The maximum number of audio buffers in flight. Setting to two allows one
// buffer to be played while the next is being written.
private let kInFlightAudioBuffers: Int = 2

// The number of audio samples per buffer. A lower value reduces latency for
// changes but requires more processing but increases the risk of being unable
// to fill the buffers in time. A setting of 1024 represents about 23ms of
// samples.
private let kSamplesPerBuffer: AVAudioFrameCount = 2048

// The single FM synthesizer instance.
private let gFMSynthesizer: FMSynthesizer = FMSynthesizer()

open class FMSynthesizer {
    
    // The audio engine manages the sound system.
    fileprivate var audioEngine: AVAudioEngine = AVAudioEngine()
    
    // The player node schedules the playback of the audio buffers.
    fileprivate var playerNode: AVAudioPlayerNode = AVAudioPlayerNode()
    
    // Use standard non-interleaved PCM audio.
    let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 2)
    
    // A circular queue of audio buffers.
    fileprivate var audioBuffers: [AVAudioPCMBuffer] = [AVAudioPCMBuffer]()
    
    // The index of the next buffer to fill.
    fileprivate var bufferIndex: Int = 0
    
    // The dispatch queue to render audio samples.
    fileprivate let audioQueue: DispatchQueue = DispatchQueue(label: "FMSynthesizerQueue", attributes: [])
    
    // A semaphore to gate the number of buffers processed.
    fileprivate let audioSemaphore: DispatchSemaphore = DispatchSemaphore(value: kInFlightAudioBuffers)
    
    fileprivate var alreadyStarted: Bool = false
    
    fileprivate var carrierVelocity: Float = 0.0
    
    fileprivate var currentCarrierFrequacy: Float32 = 0.0
    
    open class func sharedSynth() -> FMSynthesizer {
        return gFMSynthesizer
    }
    
    fileprivate init() {
        // init the semaphore
        self.initializationFMSyntezire()
    }
    
    open func initializationFMSyntezire() {
        let b1 = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: UInt32(kSamplesPerBuffer))
        let b2 = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: UInt32(kSamplesPerBuffer))
        audioBuffers = [b1, b2]
        
        // Attach and connect the player node.
        audioEngine.attach(playerNode)
        audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: audioFormat)

        do {
            try audioEngine.start()
        } catch {
            print("AudioEngine didn't start")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(FMSynthesizer.audioEngineConfigurationChange(_:)), name: NSNotification.Name.AVAudioEngineConfigurationChange, object: audioEngine)
    }
    
    
    open func play(_ carrierFrequency: Float32) {
        
        self.currentCarrierFrequacy = carrierFrequency
        print ("Playing frequency: ", carrierFrequency)
        
        let unitVelocity = Float32(2.0 * M_PI / audioFormat.sampleRate)
        self.carrierVelocity = carrierFrequency * unitVelocity
        
        if !self.alreadyStarted {
            self.alreadyStarted = true
            print ("Starting a new async method...")
            audioQueue.async {
                print ("New async method started.")
                var sampleTime: Float32 = 0
                while self.playerNode.isPlaying {
                    // Wait for a buffer to become available.
                    _ = self.audioSemaphore.wait(timeout: DispatchTime.distantFuture)
                    
                    if !self.playerNode.isPlaying {
                        return
                    }
                    
                    // Fill the buffer with new samples.
                    let audioBuffer = self.audioBuffers[self.bufferIndex]
                    let leftChannel = audioBuffer.floatChannelData?[0]
                    let rightChannel = audioBuffer.floatChannelData?[1]
                    for sampleIndex in 0 ..< Int(kSamplesPerBuffer) {
                        let s = sin(Float32(sampleTime) * self.carrierVelocity)
                        var sample = Float32(s > 0.0 ? 0.5 : -0.5)
                        if s == 0 {
                            sample = 0.0
                        }
                        leftChannel?[sampleIndex] = sample
                        rightChannel?[sampleIndex] = sample
                        sampleTime += 1
                    }
                    audioBuffer.frameLength = kSamplesPerBuffer
                    
                    // Schedule the buffer for playback and release it for reuse after
                    // playback has finished.
                    self.playerNode.scheduleBuffer(audioBuffer) {
                        self.audioSemaphore.signal()
                        return
                    }
                    
                    self.bufferIndex = (self.bufferIndex + 1) % self.audioBuffers.count
                }
                
                print ("Stopped playing frequency: ", carrierFrequency)
                
            }
        }
    
        playerNode.pan = 0
        
        playerNode.play()
    }
    
    
    open func stop() {
        self.carrierVelocity = 0.0
        print ("Playing silence.")
    }

    
    @objc fileprivate func audioEngineConfigurationChange(_ notification: Notification) -> Void {
        NSLog("Audio engine configuration change: \(notification)")
        
        self.playerNode.stop()
        self.audioEngine.stop()
        self.audioEngine.disconnectNodeOutput(playerNode)
        self.audioEngine.detach(self.playerNode)
        
        let b1 = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: UInt32(kSamplesPerBuffer))
        let b2 = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: UInt32(kSamplesPerBuffer))
        audioBuffers = [b1, b2]
        
        audioEngine.attach(playerNode)
        audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: audioFormat)
        do {
            try audioEngine.start()
        } catch {
            print("AudioEngine didn't start")
        }

    }
    
}
