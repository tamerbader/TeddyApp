//
//  TimerService.swift
//  Triage
//
//  Created by Tamer Bader on 4/11/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation

class TimerService {
    static var shared = TimerService()
    
    private var isRunning: Bool = false
    
    var delegate: TimerUpdateDelegate?
    
    var counter: Double = 0
    
    var timer: Timer = Timer()
    
    var minimumTime: Double = 0.25
    
    var child: Child!

    
    func isTimerRunning() -> Bool {
        return isRunning
    }
    
    func startTimer(minimumTime: Double, delegate: TimerUpdateDelegate) {
        // Set delegate
        self.delegate = delegate
        
        // Set minimum time needed to trigger finish
        self.minimumTime = minimumTime
        
        // Start the timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        isRunning = true
    }
    
    func stopTimer() {
        timer.invalidate()
        isRunning = false
    }
    
    func clearTimer() {
        self.counter = 0
    }
    
    func metMinimumTimeAmount() -> Bool {
        print("Counter is \(self.counter), Minimum Time is \(minimumTime * 60)")
        if (self.counter >= (minimumTime * 60)) {
            return true
        }
        return false
    }
    
    @objc func updateTimer() {
        self.counter = self.counter + 1.0
        print("\(String(format: "%.1f", counter))")
        
        // This is just temporary for testing. Will remove later because ideally we want timer to continue going even when we reach minimuim
        if (metMinimumTimeAmount()) {
            print("Done with timer")
            delegate?.timerDidMeetMinimumTimer(child: child)
        }
    }
    
    
}

protocol TimerUpdateDelegate {
    func timerDidMeetMinimumTimer(child: Child)
}
