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
        
        let _ = try await db.runTransaction { (tx, errorPointer) -> Any? in
            do {
                let snap = try tx.getDocument(chatMetadataRef)
                let last = (snap.data()?["lastSequence"] as? Int) ?? -1
                let next = last + 1

                tx.updateData(["lastSequence": next], forDocument: chatMetadataRef)

                let sequenced = event.setSequence(next)
                try tx.setData(from: sequenced, forDocument: newChatEventDoc)
            } catch {
                errorPointer?.pointee = error as NSError
            }
            return nil
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
