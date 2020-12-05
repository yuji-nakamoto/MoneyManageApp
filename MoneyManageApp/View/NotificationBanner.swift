//
//  NotificationBanner.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/12/03.
//

import Foundation
import SwiftEntryKit

struct NotificationBanner {
    static func show(title: String, body: String, image: UIImage) {
        var attributes = EKAttributes.topFloat
        attributes.entryBackground = .gradient(gradient: .init(colors: [EKColor(UIColor(named: O_WHITE)!), EKColor(UIColor(named: O_WHITE)!)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 3, offset: .zero))
        attributes.displayDuration = 10
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.bounds.width), height: .intrinsic)
        
        let title = EKProperty.LabelContent(text: title, style: .init(font: UIFont(name: "HiraMaruProN-W4", size: 15)!, color: EKColor(UIColor(named: O_BLACK)!)))
        let description = EKProperty.LabelContent(text: body, style: .init(font: UIFont(name: "HiraMaruProN-W4", size: 15)!, color: EKColor(UIColor(named: O_BLACK)!)))
        let image = EKProperty.ImageContent(image: image, size: CGSize(width: 35, height: 35))
        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}
