//
//  DartMessenger.swift
//  flutter_rtmp_streamer
//
//  Created by kuzalex on 5/10/22.
//

import Flutter
import Foundation
import UIKit

class DartMessenger: NSObject, FlutterStreamHandler {
    private var _eventSink: FlutterEventSink?

    init(messenger: FlutterBinaryMessenger, name: String) {
        super.init()

        let eventCnannel = FlutterEventChannel(name: name, binaryMessenger: messenger)

        eventCnannel.setStreamHandler(self)
    }

    func onListen(withArguments _: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        _eventSink = events
        return nil
    }

    func onCancel(withArguments _: Any?) -> FlutterError? {
        _eventSink = nil
        return nil
    }

    func send(eventType: String, args: [String: Any]) {
        guard let eventSink = _eventSink else {
            return
        }
        var data: [String: Any] = args
        data["eventType"] = eventType

        eventSink(data)
    }
}
