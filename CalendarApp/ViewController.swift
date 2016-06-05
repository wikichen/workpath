//
//  ViewController.swift
//  CalendarApp
//
//  Created by Scott Horsfall on 6/4/16.
//  Copyright © 2016 Scott Horsfall. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {
    
    let eventStore = EKEventStore()
    var calendars: [EKCalendar]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

