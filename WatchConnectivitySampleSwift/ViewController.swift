//
//  ViewController.swift
//  WatchConnectivitySampleSwift
//
//  Created by 井川 雅央 on 2015/09/23.
//  Copyright © 2015年 Kosuke Ogawa. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController,WCSessionDelegate {
    
    @IBOutlet var resultTextView:UITextView?
    var applicationDic:NSDictionary?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        applicationDic = ["hoge":"huga"]

        if (WCSession.isSupported()) {
            let session=WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func applicationContextButtonTapped() {
        
        // Application Context
        do {
            try WCSession.defaultSession().updateApplicationContext(self.applicationDic as! [String : AnyObject])
        } catch let error {
            print("\(error)")
        }
    }
    
    @IBAction func userInfoTransferButtonTapped() {
        WCSession.defaultSession().transferUserInfo(self.applicationDic as! [String : AnyObject])
    }

    @IBAction func fileTransferButtonTapped() {
        let file=NSBundle.mainBundle().pathForResource("marimo", ofType: "png")!
        let url:NSURL = NSURL.fileURLWithPath(file)
        let fileTransfer:WCSessionFileTransfer = WCSession.defaultSession().transferFile(url, metadata: self.applicationDic as? [String : AnyObject])
        print("fileTransfer = %@", fileTransfer)
    }
    
    @IBAction func interactiveMessageButtonTapped() {
        if (WCSession.defaultSession().reachable) {
            WCSession.defaultSession().sendMessage(self.applicationDic as! [String : AnyObject],
                replyHandler: { (replyHandler) -> Void in
                print("replyHandler = %@", replyHandler)
                dispatch_async(dispatch_get_main_queue(), { () in
                    self.resultTextView!.text = String(format: "%@", arguments: [replyHandler] )
                })
                }, errorHandler: { (error) -> Void in
                    print("error = %@", error)
                    dispatch_async(dispatch_get_main_queue(), { () in
                        self.resultTextView!.text = String(format: "%@", arguments: [error] )
                    })
                })
        }
    }
    
    //MARK: - WCSession Delegate

    // Interactive Message
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        dispatch_async(dispatch_get_main_queue(), { () in
            self.resultTextView!.text = String(format: "%s: %@", arguments: [ __FUNCTION__, message])
        })
    }
    
}

