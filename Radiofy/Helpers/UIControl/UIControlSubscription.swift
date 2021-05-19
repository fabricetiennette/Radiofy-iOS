//
//  UIControlSubscription.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 10/05/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import UIKit
//import Combine
//final class UIControlSubscription<SubscriberType: Subscriber,
//                                  Control: UIControl>: Subscription
//                                  where SubscriberType.Input == Control {
//    private var subscriber: SubscriberType?
//    private let control: Control
//
//    init(subscriber: SubscriberType, control: Control, event: UIControl.Event) {
//        self.subscriber = subscriber
//        self.control = control
//        control.addTarget(self, action: #selector(eventHandler), for: event)
//    }
//
//    func request(_ demand: Subscribers.Demand) {
//        // We do nothing here as we only want to send events when they occur.
//        // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
//    }
//
//    func cancel() {
//        subscriber = nil
//    }
//
//    @objc private func eventHandler() {
//        _ = subscriber?.receive(control)
//    }
//}
