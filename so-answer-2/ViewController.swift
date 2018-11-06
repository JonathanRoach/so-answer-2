//
//  ViewController.swift
//  so-answer-2
//
//  Created by Framework Access Point on 05/11/2018.
//  Copyright © 2018 Framework Central. All rights reserved.
//

import UIKit
import ALTableViewHelper

// This extension means that .isAnimating can be assigned, and behaves as expected
extension UIActivityIndicatorView {
    @objc func setIsAnimating(_ isIt:Bool) {
        DispatchQueue.main.async {
            if self.isAnimating != isIt {
                if isIt {
                    self.startAnimating()
                } else {
                    self.stopAnimating()
                }
            }
        }
    }
}

// This fake conversation getter waits 3 seconds before the new conversations 'arrive'
// Need to use the singleton pattern so that changes to .busy can be observed
@objc class FakeConversationGetter: NSObject {
    @objc static let singleton = FakeConversationGetter()
    @objc dynamic var busy = false
    
    var timer = Timer()
    
    func fetchUpdate(block: @escaping (Any?) -> Void) {
        busy = true
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) {_ in
            self.busy = false
            block([["title":"Conversation 1", "update":NSDate()], ["title":"Conversation 2", "update":NSDate()]])
        }
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    @objc let dateFormat = DateFormatter()
    
    @objc dynamic var conversations: Any? = [["title":"Conversation 1", "update":NSDate()], ["title":"Conversation 2", "update":NSDate()]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormat.dateFormat = "hh:mm"
        
        // Do any additional setup after loading the view, typically from a nib.
        tableView.setHelperString("""
        section
            headertext "Conversation Status"
            body
                Conversation
                    $.viewWithTag(1).text <~ conversations[conversations.count-1]["title"]
                    $.viewWithTag(2).text <~ "At \\(dateFormat.stringFromDate(conversations[conversations.count-1]["update"]))"
                UpdateButton
                    $.viewWithTag(1).isAnimating <~ FakeConversationGetter.singleton.busy
        """, context: self)
    }

    @IBAction func startUpdate(_ sender: Any) {
        FakeConversationGetter.singleton.fetchUpdate {(data) in
            DispatchQueue.main.async {
                self.conversations = [["title":"Conversation 1", "update":"1-2-2018"], ["title":"Conversation 2", "update":NSDate()]]
            }
        }
    }
}

