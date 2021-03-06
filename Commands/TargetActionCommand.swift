//
//  TargetActionCommand.swift
//  Commander
//
//  Created by Matthias Tretter on 05/05/2017.
//  Copyright © 2017 Matthias Tretter. All rights reserved.
//

import Foundation


/// A command that uses the target/action pattern
public final class TargetActionCommand {

    fileprivate weak var target: NSObject?
    fileprivate let action: Selector
    fileprivate let reverseAction: Selector

    // (from Invokeable) - Swift doesn't allow to move Properties to extensions (yet)
    public var state: State = .ready

    // MARK: - Lifecycle

    public init(target: NSObject, action: Selector, reverseAction: Selector) {
        self.target = target
        self.action = action
        self.reverseAction = reverseAction
    }
}

// MARK: - Command

extension TargetActionCommand: Command {

    public func invoke() {
        guard let target = self.target else { return }

        self.state = .executing
        target.perform(self.action)
        self.finish()
    }

    public func reverse() {
        guard let target = self.target else { return }

        self.state = .executing
        target.perform(self.reverseAction)
        self.state = .ready
    }
}
