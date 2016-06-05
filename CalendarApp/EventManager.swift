//
//  EventManager.swift
//  CalendarApp
//
//  Created by Scott Horsfall on 6/4/16.
//  Copyright © 2016 Scott Horsfall. All rights reserved.
//

import UIKit

class EventManager: NSObject {
    
    @interface EventManager : NSObject
    
    @property (nonatomic, strong) EKEventStore *eventStore;
    
    @end

}
