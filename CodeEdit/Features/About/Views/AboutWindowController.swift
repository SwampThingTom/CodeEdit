//
//  AboutWindowController.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 18/01/2023.
//

import SwiftUI

final class AboutViewWindowController: NSWindowController {

    class CustomWindow: NSWindow {
        @objc var hasMainAppearance: Bool {
            true
        }

        @objc var hasKeyAppearance: Bool {
            true
        }
    }

    convenience init<T: View>(view: T, size: NSSize) {
        let hostingController = NSHostingController(rootView: view)
        // New window holding our SwiftUI view
        let window = CustomWindow(contentViewController: hostingController)
        self.init(window: window)
        window.styleMask = [.closable, .fullSizeContentView, .titled, .nonactivatingPanel]
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.backgroundColor = .gray.withAlphaComponent(0.15)
    }

    override func showWindow(_ sender: Any?) {
        window?.center()
        window?.alphaValue = 0.0

        super.showWindow(sender)

        window?.animator().alphaValue = 1.0

        // close the window when the escape key is pressed
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            guard event.keyCode == 53 else { return event }

            self.closeAnimated()

            return nil
        }

        window?.collectionBehavior = [.managed, .ignoresCycle]
        window?.isMovableByWindowBackground = true
        window?.titlebarAppearsTransparent = true
        window?.titleVisibility = .hidden
        window?.isExcludedFromWindowsMenu = true
    }

    func closeAnimated() {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 0.4
        NSAnimationContext.current.completionHandler = {
            self.close()
        }
        window?.animator().alphaValue = 0.0
        NSAnimationContext.endGrouping()
    }
}
