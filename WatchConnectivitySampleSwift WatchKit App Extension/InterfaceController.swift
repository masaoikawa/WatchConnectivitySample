//
//  InterfaceController.swift
//  WatchConnectivitySampleSwift WatchKit App Extension
//
//  Created by 井川 雅央 on 2015/09/23.
//  Copyright © 2015年 Kosuke Ogawa. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController,WCSessionDelegate {
    
    @IBOutlet var resultLabel:WKInterfaceLabel?

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        if (WCSession.isSupported()) {
            let session:WCSession = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func sendMessageButtonTapped() {
        if (WCSession.defaultSession().reachable) {
            WCSession.defaultSession().sendMessage(["hoge": "huga"], replyHandler: { replyMessage -> Void in
                if let replyMessage:[String: AnyObject]? = replyMessage as [String: AnyObject]? {
                    dispatch_async(dispatch_get_main_queue(), { () in
                        var message:String=""
                        for (key,val) in replyMessage! {
                            message = message + "\(key): \(val)"
                        }
                        self.resultLabel?.setText(String(format: "replyHandler = %@", arguments: [message]))
                    })
                }
                }, errorHandler: { (error) -> Void  in
                    if let message:NSError? = error as NSError? {
                        dispatch_async(dispatch_get_main_queue(), { () in
                            self.resultLabel?.setText("Error = \(message?.description)")
                        })
                    }
                })
            
        }
    }

    //MARK: WCSessionDelegate
    
    func sessionWatchStateDidChange(session: WCSession) {
        print("%s: session = %@", __FUNCTION__, session)
    }

    // Application Context
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        dispatch_async(dispatch_get_main_queue(), { () in
            self.resultLabel?.setText(String("%s: %@",__FUNCTION__,applicationContext))
            })
    }
    
    // User Info Transfer
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        dispatch_async(dispatch_get_main_queue(), { () in
            self.resultLabel?.setText(String(format: "%s: %@", arguments: [__FUNCTION__,userInfo]))
        })
    }

    // File Transfer
    func session(session: WCSession, didReceiveFile file: WCSessionFile) {
        dispatch_async(dispatch_get_main_queue(), { () in
            resultLabel?.setText(String(format: "%s: %@", arguments: [__FUNCTION__, file]))
        })
    }
    
    // Interactive Message
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        dispatch_async(dispatch_get_main_queue(), { () in
            resultLabel?.setText(String(format: "%s: %@", arguments: [__FUNCTION__, message]))
        })
    }
}