//
//  ViewController.swift
//  EmojiTransmitter
//
//  Created by Amit Palo on 06/08/22.
//

import UIKit
import Starscream

final class ViewController: UIViewController {
    
    // MARK: - Properties
    var username = ""
    
    // MARK: - IBOutlets
    @IBOutlet var emojiLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    private var socket: WebSocket!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        socket = WebSocket(request: URLRequest(url: URL(string: "ws://localhost:1337/")!))
        socket.delegate = self
        socket.connect()
    }
    
    deinit {
        socket.disconnect()
        socket.delegate = nil
    }
}

// MARK: - IBActions
extension ViewController {
    
    @IBAction func selectedEmojiUnwind(unwindSegue: UIStoryboardSegue) {
        guard let viewController = unwindSegue.source as? CollectionViewController,
              let emoji = viewController.selectedEmoji() else{
            return
        }
        
        sendMessage(emoji)
    }
}

// MARK: - FilePrivate
fileprivate extension ViewController {
    
    func sendMessage(_ message: String) {
        print("NOOP - sendMessage: \(message)")
        socket.write(string: message)
    }
    
    func messageReceived(_ message: String, senderName: String) {
        emojiLabel.text = message
        usernameLabel.text = senderName
    }
}

// MARK: - WebSocketDelegate
extension ViewController : WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        
        switch event {
        case .connected(let dictionary):
            print(dictionary)
            socket.write(string: username)
        case .disconnected(let string, let uInt16):
            print("\(string) :: \(uInt16)")
            performSegue(withIdentifier: "websocketDisconnected", sender: self)
        case .text(let string):
            print("text \(string)")
            receivedMessage(string: string)
        case .binary(let data):
            print("binary \(data)")
        case .pong(let optional):
            print("pong \(String(describing: optional))")
        case .ping(let optional):
            print("ping \(String(describing: optional))")
        case .error(let optional):
            print("error \(String(describing: optional))")
        case .viabilityChanged(let bool):
            print("viabilityChanged \(bool)")
        case .reconnectSuggested(let bool):
            print("reconnectSuggested \(bool)")
        case .cancelled:
            print("cancelled")
        }
    }
    
    func receivedMessage(string: String) {
        guard let data = string.data(using: .utf16),
              let jsonData = try? JSONSerialization.jsonObject(with: data),
              let jsonDict = jsonData as? [String: Any],
              let messageType = jsonDict["type"] as? String else {
            return
        }
        
        if messageType == "message",
           let messageData = jsonDict["data"] as? [String: Any],
           let messageAuthor = messageData["author"] as? String,
           let messageText = messageData["text"] as? String {
            messageReceived(messageText, senderName: messageAuthor)
        }
    }
}
