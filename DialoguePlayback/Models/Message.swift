//
//  Message.swift
//  DialoguePlayback
//
//  Created by Oleg Shamin on 19.09.2020.
//

import Foundation

struct Message: Identifiable {
    
    // MARK: - Properties
    
    let id: String
    let line: String
    
    // MARK: - Initialization
    
    init(
        id: String,
        line: String
    ) {
        self.id = id
        self.line = line
    }
}

// MARK: - Decodable

extension Message: Decodable {
    
    enum Keys: String, CodingKey {
        case line
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let line = try container.decode(String.self, forKey: .line)
        
        self.init(
            id: UUID().uuidString,
            line: line
        )
    }
}
