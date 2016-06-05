//
//  TodoViewController.swift
//  CalendarApp
//
//  Created by Scott Horsfall on 6/4/16.
//  Copyright © 2016 Scott Horsfall. All rights reserved.
//

import UIKit
import EventKit

class TodoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    let eventStore = EKEventStore()
    var calendars: [EKCalendar]?

    @IBOutlet weak var needPermissionView: UIView!
    @IBOutlet weak var calendarsTableView: UITableView!
    
    @IBOutlet weak var calendarCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //calendarsTableView.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        checkCalendarAuthorizationStatus()
    }
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event)
        
        switch (status) {
        case EKAuthorizationStatus.NotDetermined:
            // This happens on first-run
            requestAccessToCalendar()
        case EKAuthorizationStatus.Authorized:
            // Things are in line with being able to show the calendars in the table view
            loadCalendars()
            refreshTableView()
        case EKAuthorizationStatus.Restricted, EKAuthorizationStatus.Denied:
            // We need to help them give us permission
            
            UIView.animateWithDuration(0.4, animations: {
                self.needPermissionView.alpha = 1
            })
        }
    }
    
    @IBAction func onRequestTap(sender: AnyObject) {
        requestAccessToCalendar()
    }
    
    func requestAccessToCalendar() {
        eventStore.requestAccessToEntityType(EKEntityType.Event, completion: {
            (accessGranted: Bool, error: NSError?) in
            
            if accessGranted == true {
                dispatch_async(dispatch_get_main_queue(), {
                    self.loadCalendars()
                    self.refreshTableView()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    UIView.animateWithDuration(0.4, animations: {
                        self.needPermissionView.alpha = 1
                    })
                })
            }
        })
    }
    
    func loadCalendars() {
        self.calendars = eventStore.calendarsForEntityType(EKEntityType.Event)
    }
    
    func refreshTableView() {
        calendarsTableView.hidden = false
        calendarsTableView.reloadData()
        updateCalendarCountLabel()
    }
    
    func updateCalendarCountLabel() {
        let calendars = self.calendars
        let count = calendars!.count
        
        calendarCountLabel.text = "Calendars: \(count)"
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let calendars = self.calendars {
            return calendars.count
        }
        
        return 0
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("basicCell")!
        let title = cell.textLabel
        let detail = cell.detailTextLabel
        
        
        if let calendars = self.calendars {
            // return name of calendar
            let calendarName = calendars[indexPath.row].title
            // return calendar color from iOS
            let calendarColor = calendars[indexPath.row].CGColor
            
            //let today = NSDate(today)
            
            let oneMonthAgo = NSDate(timeIntervalSinceNow: -15*24*3600)
            let oneMonthAfter = NSDate(timeIntervalSinceNow: +15*24*3600)
            
            let predicate = eventStore.predicateForEventsWithStartDate(oneMonthAgo, endDate: oneMonthAfter, calendars: [calendars[indexPath.row]])
            var events = eventStore.eventsMatchingPredicate(predicate)
            
            title!.text = calendarName
            title!.textColor = UIColor(CGColor: calendarColor)
            detail?.text = "Events This Month: \(events.count)"
        } else {
            title!.text = "Unknown Calendar Name"
            detail?.text = "Unknown"
        }
        
        return cell
    }
    

}
