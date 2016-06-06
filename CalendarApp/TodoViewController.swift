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
    
    var allEvents: [EKEvent]?
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventsTableView.hidden = true
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
            
            print("need permission")
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
                    //need permission
                })
            }
        })
    }
    
    func loadCalendars() {
        self.calendars = eventStore.calendarsForEntityType(EKEntityType.Event)
        
        let oneMonthAgo = NSDate(timeIntervalSinceNow: 0*24*3600)
        let oneMonthAfter = NSDate(timeIntervalSinceNow: 1*24*3600)
        
        let predicate = eventStore.predicateForEventsWithStartDate(oneMonthAgo, endDate: oneMonthAfter, calendars: self.calendars)
        
        self.allEvents = eventStore.eventsMatchingPredicate(predicate)
        
    }
    
    func refreshTableView() {
        eventsTableView.hidden = false
        eventsTableView.reloadData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let events = self.allEvents {
            return events.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("basicCell")!
        let title = cell.textLabel
        let detail = cell.detailTextLabel
        
        if let events = self.allEvents {
            // return name and start/end dates (NSDate)
            let eventName = events[indexPath.row].title
            let eventStartDate = events[indexPath.row].startDate
            let eventEndDate = events[indexPath.row].endDate
            
            //format the dates to short time format
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale.currentLocale()
            
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            let convertedStartTime = dateFormatter.stringFromDate(eventStartDate)
            let convertedEndTime = dateFormatter.stringFromDate(eventEndDate)
            
            //add these to the view
            title!.text = eventName
            detail!.text = "\(String(convertedStartTime))  –  \(String(convertedEndTime))"
            
            //colorBox.backgroundColor = UIColor(CGColor: calendarColor)
        } else {
            title!.text = "Unknown Calendar Name"
            detail!.text = ""
        }
        
        
        return cell
    }
    
    
}


