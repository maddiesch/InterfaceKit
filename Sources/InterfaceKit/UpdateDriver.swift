//
//  UpdateDriver.swift
//  
//
//  Created by Maddie Schipper on 3/4/21.
//

import Foundation
import Combine

fileprivate class UpdateDriverPublisher : Publisher {
    typealias Output = Date
    
    typealias Failure = Never
    
    fileprivate let repeating: Double
    
    fileprivate class TimerSubscription<Target : Subscriber> : Subscription where Target.Input == Date {
        private var timer: DispatchSourceTimer?
        
        var demand: Subscribers.Demand = .unlimited
        
        var target: Target?
        
        init(_ repeating: Double) {
            self.timer = DispatchSource.makeTimerSource()
            self.timer!.schedule(deadline: .now(), repeating: repeating)
            self.timer!.setEventHandler { [weak self] in
                self?.fire()
            }
            self.timer!.resume()
        }
        
        func request(_ demand: Subscribers.Demand) {
            self.demand = demand
        }
        
        deinit {
            self.cancel()
        }
        
        func cancel() {
            self.timer?.cancel()
            self.timer = nil
            self.target = nil
        }
        
        fileprivate func fire() {
            if let demand = self.target?.receive(Date()) {
                self.demand = demand
            }
        }
    }
    
    init(repeating: Double) {
        self.repeating = repeating
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, UpdateDriverPublisher.Failure == S.Failure, UpdateDriverPublisher.Output == S.Input {
        let subscription = TimerSubscription<S>(self.repeating)
        subscription.target = subscriber
        
        subscriber.receive(subscription: subscription)
    }
}

public func UpdateDriver(repeating: TimeInterval) -> AnyPublisher<Date, Never> {
    return UpdateDriverPublisher(repeating: Double(repeating)).eraseToAnyPublisher()
}
