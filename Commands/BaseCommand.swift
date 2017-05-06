//
//  BaseCommand.swift
//  Commander
//
//  Created by Matthias Tretter on 20/04/2017.
//
//

import Foundation


/// a base (convenience) implementation of a Command
open class BaseCommand {

    public lazy var command: Command = self.makeCommand()

    // (from Command) - Swift doesn't allow to move Properties to extensions (yet)
    public var state: State = .ready
    public let isMutating: Bool

    // MARK: - Lifecycle

    public init(isMutating: Bool = true) {
        self.isMutating = isMutating
    }

    // MARK: - BaseCommand

    open func makeCommand() -> Command {
        fatalError("Subclasses must implement")
    }
}

// MARK: - Command

extension BaseCommand: Command {

    public func invoke() {
        self.state = .executing
        self.command.invoke()
        self.finish()
    }

    public func inverse() {
        self.state = .executing
        self.command.inverse()
        self.state = .ready
    }
}
