//
//  MessageService.swift
//  DialoguePlayback
//
//  Created by Oleg Shamin on 19.09.2020.
//

import Foundation

protocol MessageServiceProtocol {
    func nextMessage() -> Message?
}

class MessageService: MessageServiceProtocol {
    
    // MARK: - Private properties
    
    private let decoder = JSONDecoder()
    private var messages: [Message] = []
    
    // MARK: - Initialization
    
    init() {
        messages = getMessages()
    }
    
    // MARK: - MessageServiceProtocol

    func nextMessage() -> Message? {
        guard !messages.isEmpty else {
            return nil
        }
        let message = messages.removeFirst()
        return message
    }
    
    // MARK: - Private helpers
    
    private func getMessages() -> [Message] {
        
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let messages = try decoder.decode([Message].self, from: data)
                self.messages = messages
                return messages
                
            } catch {
                print("Decode error: \(error.localizedDescription)")
                return []
            }
        }
        
        return []
    }
}
