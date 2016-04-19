//
//  MHPhoneCommunicationManager.swift
//  Bucket Game
//
//  Created by Michael Hulet on 3/31/16.
//  Copyright © 2016 Michael Hulet. All rights reserved.
//

import Foundation
import WatchConnectivity

protocol MHPeripheralCommunicationDelegate{
    func applicationDidRecieveData(data: [String: AnyObject], responseHandler: (([String: AnyObject]) -> Void)?) -> Void
}

protocol MHSerializable{
    func serialize() -> [String: AnyObject]
}

private struct MHWaitingMessage{
    let data: [String: AnyObject]
    let replyHandler: (([String: AnyObject]) -> Void)
    let errorHandler: ((NSError) -> Void)?
    init(data: [String: AnyObject], replyHandler: (([String: AnyObject]) -> Void), errorHandler: ((NSError) -> Void)? = nil){
        self.data = data
        self.replyHandler = replyHandler
        self.errorHandler = errorHandler
    }
}

let MHDataQueueKey = "MHDataQueueKey"

class MHPeripheralCommunicationManager: NSObject, WCSessionDelegate{
    //MARK: - Properties
    static let mainCommunicator = MHPeripheralCommunicationManager()
    var delegate: MHPeripheralCommunicationDelegate? = nil
    var session: WCSession?{
        get{
            #if os(iOS)
                let condition = WCSession.defaultSession().paired && WCSession.defaultSession().watchAppInstalled
            #else
            #if os(watchOS)
                let condition = true
            #else
                let condition = false
            #endif
            #endif
            return WCSession.isSupported() && condition ? WCSession.defaultSession() : nil
        }
    }
    private var messageQueue: [MHWaitingMessage] = []
    //MARK: - Public Functions
    func connect() -> Void{
        session?.delegate = self
        session?.activateSession()
        if session?.applicationContext[MHDataQueueKey] == nil{
            do{
                try session?.updateApplicationContext([MHDataQueueKey: []])
            }
            catch let error{
                print(error)
            }
        }
        guard #available(iOS 9.3, watchOS 2.2, *) else{
            sendWaitingMessages()
            //FIXME: If I ever add more in the future, I need to go back to making this the else block of an if condition
            return
        }
    }
    func sendData(data: [String: AnyObject], replyHandler: (([String: AnyObject]) -> Void)? = nil, errorHandler: ((NSError) -> Void)? = nil) -> Void{
        guard let session = session else{
            return
        }
        if session.reachable{
            session.sendMessage(data, replyHandler: replyHandler, errorHandler: errorHandler)
        }
        else{
            if replyHandler != nil{
                messageQueue.append(MHWaitingMessage(data: data, replyHandler: replyHandler!, errorHandler: errorHandler))
            }
            else{
                do{
                    try session.updateApplicationContext([MHDataQueueKey: (session.applicationContext[MHDataQueueKey] as! [[String: AnyObject]]) + [data]])
                }
                catch let error{
                    print(error)
                }
            }
        }
    }
    func sendData(data: MHSerializable, replyHandler: (([String: AnyObject]) -> Void)? = nil, errorHandler: ((NSError) -> Void)? = nil) -> Void{
        sendData(data.serialize(), replyHandler: replyHandler, errorHandler: errorHandler)
    }
    //MARK: - Private Helpers
    private override init(){
        super.init()
        session?.delegate = self
    }
    private func sendWaitingMessages() -> Void{
        if !(session?.applicationContext[MHDataQueueKey] as! [[String: AnyObject]]).isEmpty{
            for message in (session?.applicationContext[MHDataQueueKey] as! [[String: AnyObject]]){
                let condition: Bool
                if #available(iOS 9.3, watchOS 2.2, *){
                    condition = session?.activationState == .Activated
                }
                else{
                    condition = true
                }
                if condition{
                    sendData(message)
                }
                else{
                    break
                }
            }
        }
    }
    //MARK: - WCSessionDelegate Methods
    func session(session: WCSession, didReceiveMessage message: [String: AnyObject]) -> Void{
        delegate?.applicationDidRecieveData(message, responseHandler: nil)
    }
    func session(session: WCSession, didReceiveMessage message: [String: AnyObject], replyHandler: ([String: AnyObject]) -> Void) -> Void{
        delegate?.applicationDidRecieveData(message, responseHandler: replyHandler)
    }
    func session(session: WCSession, didReceiveUserInfo userInfo: [String: AnyObject]) {
        delegate?.applicationDidRecieveData(userInfo, responseHandler: nil)
    }
    @available(iOS 9.3, watchOS 2.2, *) func session(session: WCSession, activationDidCompleteWithState activationState: WCSessionActivationState, error: NSError?) -> Void{
        if activationState == .Activated{
            sendWaitingMessages()
        }
    }
    @available(iOS 9.3, *) func sessionDidBecomeInactive(session: WCSession) -> Void{
        //Just have to implement it
    }
    @available(iOS 9.3, *) func sessionDidDeactivate(session: WCSession) {
        MHPeripheralCommunicationManager.mainCommunicator.connect()
    }
}