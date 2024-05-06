//
//  ConnectionView.swift
//  InMoovSwift
//
//  Created by Yannick Comte on 28/04/2024.
//

import SwiftUI
import Network
import AVFoundation
import OpenAI

struct BrainView: View {
    @ObservedObject var settingsManager = SettingsManager.shared
    @State private var messages: [ChatMessage] = []
    @State private var inputText: String = ""
    
    private static var openAI: OpenAI?
    private let useOpenAI = true
    private var speechSynthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        VStack {
            // Messages display area
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages) { message in
                        HStack {
                            if message.isFromUser {
                                Spacer()
                                Text(message.text)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: 300, alignment: .trailing)
                            } else {
                                Text(message.text)
                                    .padding()
                                    .background(Color.gray)
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: 300, alignment: .leading)
                                Spacer()  // Push bot messages to the left
                            }
                        }
                    }
                }
                .padding()
            }
            
            // Input text area
            HStack {
                TextField("Type a message...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: CGFloat(30))
                
                Button(action: {
                    
                }) {
                    Image(systemName: "mic.slash.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.gray)
                        .padding(.leading, 15)
                }
                
                Button(action: sendMessage) {
                    Text("Send")
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationBarTitle("Chatbot", displayMode: .inline)
    }
    
    private func sendMessage() {
        let newMessage = ChatMessage(text: inputText, isFromUser: true)
        messages.append(newMessage)
        inputText = ""  // Clear the input field
        
        if useOpenAI {
            let aiKey = settingsManager.globalSettings.openAIKey
            
            if BrainView.openAI == nil, !aiKey.isEmpty {
                BrainView.openAI = OpenAI(apiToken: aiKey)
            }
            
            Task {
                await SendToGPT(newMessage.text)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let reply = ChatMessage(text: "Echo: \(newMessage.text)", isFromUser: false)
                messages.append(reply)
                speak(newMessage.text)
            }
        }
    }
    
    private func SendToGPT(_ message: String) async {
        guard let ai = BrainView.openAI else {
            print("[Brain] OpenAI is not set")
            return
        }
        
        do {
            let query = ChatQuery(messages: [.init(role: .user, content: message)!], model: .gpt3_5Turbo)
            let response = try await ai.chats(query: query)
            if response.choices.count > 0 {
                if let responseMessage = response.choices[0].message.content?.string {
                    let reply = ChatMessage(text: "Robot: \(responseMessage)", isFromUser: false)
                    messages.append(reply)
                    speak("\(responseMessage)")
                } else {
                    print("[Brain] Empty response from GPT")
                }
            } else {
                print("[Brain] No response from GPT")
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }

    func speak(_ message: String) {
        let settings = SettingsManager.shared.globalSettings
        let selectedVoiceLanguage = settings.speechLang.rawValue
        let selectedGenderIndex = settings.speechGender
        let utterance = AVSpeechUtterance(string: message);
        utterance.voice = AVSpeechSynthesisVoice(language: selectedVoiceLanguage)

        if selectedGenderIndex == .male {
            utterance.voice = AVSpeechSynthesisVoice.speechVoices().first(where: { $0.language == selectedVoiceLanguage && $0.gender == .male })
        } else {
            utterance.voice = AVSpeechSynthesisVoice.speechVoices().first(where: { $0.language == selectedVoiceLanguage && $0.gender == .female })
        }
        
        speechSynthesizer.speak(utterance)
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isFromUser: Bool
}

#Preview {
    BrainView()
}
