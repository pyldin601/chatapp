//
//  FirebaseChatEventRepositoryImpl.swift
//  ChatApp
//
//  Created by Roman on 19/10/2025.
//

import FirebaseCore
import FirebaseFirestore

let CHAT_EVENTS_COLLECTION = "chat-events"
let CHAT_METADATA_COLLECTION = "chat-metadata"
let CHAT_METADATA_DOCUMENT_ID = "chat-metadata"

final class FirebaseChatEventRepositoryImpl: ChatEventRepository {
    
    private let db = Firestore.firestore()
    
    private var events: CollectionReference { db.collection(CHAT_EVENTS_COLLECTION) }
    private var meta: CollectionReference { db.collection(CHAT_METADATA_COLLECTION) }
    
    func publish(_ event: ChatEventDTO) async throws {
        let chatMetadataRef = self.meta.document(CHAT_METADATA_DOCUMENT_ID)
        let newChatEventDoc = self.events.document()
        
        var err: NSError? = nil
        
        let _ = try await db.runTransaction { (tx, _) in
            do {
                
                let chatMetadataSnap = try tx.getDocument(chatMetadataRef)
                let lastSequence = (chatMetadataSnap.data()?["lastSequence"] as? Int) ?? 0
                let nextSequence = lastSequence + 1
                tx.updateData(["lastSequence": nextSequence], forDocument: chatMetadataRef)
                
                let event = event.setSequence(nextSequence)
                
                try tx.setData(from: event, forDocument: newChatEventDoc)
                
                
            } catch {
                print("err", error.localizedDescription)
                err = error as NSError
            }
            
            return
        }
        
        if let err {
            throw err
        }
    }
    
    func subscribe() -> AsyncStream<ChatEventDTO> {
        AsyncStream { continuation in
            let query = events
                .order(by: "sequence", descending: false)
                .limit(to: 100)

            let listener = query.addSnapshotListener { snap, error in
                if let error {
                    // You may surface an error via another callback if needed
                    print("Listener error:", error.localizedDescription)
                    return
                }
                guard let snap else { return }
                
                for change in snap.documentChanges {
                    guard change.type == .added else { continue }
                    
                    do {
                        let doc = try change.document.data(as: ChatEventDTO.self)
                        continuation.yield(doc)
                    } catch {
                        print("Error:", error.localizedDescription)
                    }
                }
            }
            
            continuation.onTermination = { _ in
                listener.remove()
            }
        }
    }
}
