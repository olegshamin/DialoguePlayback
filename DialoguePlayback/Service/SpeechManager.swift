//
//  SpeechManager.swift
//  DialoguePlayback
//
//  Created by Oleg Shamin on 21.09.2020.
//

import Foundation
import AVFoundation

protocol SpeechManagerProtocol {
    func speak(_ message: Message, completion: @escaping (() -> Void))
}

class SpeechManager: AVSpeechSynthesizer, SpeechManagerProtocol {
    
    // MARK: - Private properties
    
    private var completion: (() -> Void)?
    private var readMessageIds: [String] = []
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        delegate = self
    }
    
    // MARK: - SpeechManagerProtocol
    
    func speak(_ message: Message, completion: @escaping (() -> Void)) {

        // Check if we have already spoken the message
        guard !readMessageIds.contains(message.id) else {
            return
        }
        
        self.completion = completion
        readMessageIds.append(message.id)
        
        let utterance = AVSpeechUtterance(string: message.line)
        utterance.voice = AVSpeechSynthesisVoice(language: Locale.current.languageCode)
        
        speak(utterance)
    }
}

// MARK: - AVSpeechSynthesizerDelegate

extension SpeechManager: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        stopSpeaking(at: .immediate)
        self.completion?()
    }
}
