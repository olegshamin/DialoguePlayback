//
//  ContentView.swift
//  DialoguePlayback
//
//  Created by Oleg Shamin on 18.09.2020.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Private properties
    
    private let messageService: MessageServiceProtocol
    private let speechService: SpeechManagerProtocol
    @State private var messages: [Message] = []
    @State private var messageIdToSetVisible: String?
    
    // MARK: - Initialization
    
    init(
        messageService: MessageServiceProtocol,
        speechService: SpeechManagerProtocol
    ) {
        self.messageService = messageService
        self.speechService = speechService
    }
    
    // MARK: - Body
    
    var body: some View {
        
        NavigationView {
            GeometryReader { geo in
                ScrollViewReader { scrollView in
                    ScrollView {
                        LazyVStack(alignment: .leading) {
                            
                            ForEach(messages) { message in
                                
                                MessageView(text: message.line)
                                    .id(message.id)
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            readTheMessage(message)
                                        }
                                    }
                                
                            }
                            .padding(.bottom, 30)
                            .transition(.move(edge: .bottom))
                            .animation(.linear(duration: 0.5))
                        }
                        .padding(.top, 16)
                        .frame(
                            minWidth: geo.size.width,
                            minHeight: geo.size.height,
                            alignment: .bottomLeading
                        )
                    }
                    .onChange(of: messageIdToSetVisible) { id in
                        guard let id = id else { return }
                        withAnimation {
                            scrollView.scrollTo(id)
                        }
                    }
                }
                .navigationBarTitle("Dialogue")
            }
            .onAppear {
                guard let message = messageService.nextMessage() else {
                    return
                }
                messages.append(message)
            }
        }
    }
    
    private func readTheMessage(_ message: Message) {

        speechService.speak(message) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                guard let message = messageService.nextMessage() else {
                    return
                }
                messages.append(message)
                messageIdToSetVisible = message.id
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            messageService: MessageService(),
            speechService: SpeechManager()
        )
    }
}

extension String: Identifiable {
    public var id: String {
        return self
    }
}
