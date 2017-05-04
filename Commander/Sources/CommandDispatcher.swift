//
//  CommandDispatcher.swift
//  Commander
//
//  Created by Matthias Tretter on 02/04/2017.
//
//

import Foundation


public protocol CommandDispatcherDelegate: class {

    func commandDispatcher(_ commandDispatcher: CommandDispatcher, didInvokeCommand command: Command)
    func commandDispatcher(_ commandDispatcher: CommandDispatcher, didForbidCommand command: Command)
}


/// Controller class to invoke/dispatch commands
public final class CommandDispatcher {

    fileprivate let validator: CommandValidator?
    

    // MARK: - Properties

    weak var delegate: CommandDispatcherDelegate?
    var handlers: [CommandHandler] = []

    // MARK: - Lifecycle

    init(validator: CommandValidator? = nil) {
        self.validator = validator
    }

    // MARK: - CommandDispatcher

    public func canInvoke(_ command: Command) -> Bool {
        return self.validator?.validate(command: command) ?? true
    }

    public func invoke(_ command: Command) {
        guard self.canInvoke(command) else {
            command.state = .forbidden
            self.delegate?.commandDispatcher(self, didForbidCommand: command)
            return
        }

        command.invoke()
        self.handlers.forEach { $0.handleCommand(command) }

        self.delegate?.commandDispatcher(self, didInvokeCommand: command)
    }
}
