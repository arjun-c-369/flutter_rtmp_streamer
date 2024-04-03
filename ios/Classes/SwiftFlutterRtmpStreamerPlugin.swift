import Flutter
import UIKit

class CameraViewFactory: NSObject, FlutterPlatformViewFactory {
    private var _rtpService: RtpService

    init(registrar _: FlutterPluginRegistrar, rtpService: RtpService) {
        _rtpService = rtpService
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return CameraView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            rtpService: _rtpService
        )
    }
}

public class SwiftFlutterRtmpStreamerPlugin: NSObject, FlutterPlugin {
    private var _rtpService: RtpService

    init(rtpService: RtpService) {
        logger.info("init")
        _rtpService = rtpService

        super.init()
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_rtmp_streamer", binaryMessenger: registrar.messenger())

        let instance = SwiftFlutterRtmpStreamerPlugin(rtpService: RtpService(dartMessenger: DartMessenger(messenger: registrar.messenger(), name: "flutter_rtmp_streamer/events")))
        registrar.addMethodCallDelegate(instance, channel: channel)

        let nativeViewFactory = CameraViewFactory(registrar: registrar, rtpService: instance._rtpService)
        registrar.register(nativeViewFactory, withId: "flutter_rtmp_streamer_camera_view")
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        /*
         *
         *
         */
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)

        /*
         *
         *
         */
        case "init":

            guard let args0 = call.arguments else {
                result(FlutterError(code: call.method, message: "args is empty", details: nil))
                return
            }

            guard let args = args0 as? [String: Any] else {
                result(FlutterError(code: call.method, message: "args is empty", details: nil))
                return
            }

            if let streamingSettings = args["streamingSettings"] as? String {
                do {
                    try _rtpService.setStreamingSettings(newValue: JSONDecoder().decode(StreamingSettings.self, from: streamingSettings.data(using: .utf8)!))

                    result(true)

                    _rtpService.sendCameraStatusToDart()

                } catch {
                    result(FlutterError(code: "init", message: "\(error)", details: nil))
                }
            } else {
                result(FlutterError(code: "init", message: "initialParams empty", details: nil))
            }

        /*
         *
         *
         */
        case "getResolutions":

            let resolutions = BackAndFrontResolutions(back: _rtpService.getSupportedResolutions(), front: _rtpService.getSupportedResolutions())

            do {
                try result(String(decoding: JSONEncoder().encode(resolutions), as: UTF8.self))
            } catch {
                result(FlutterError(code: "getResolutions", message: "\(error)", details: nil))
            }

        /*
         *
         *
         */
        case "changeStreamingSettings":

            guard let args0 = call.arguments else {
                result(FlutterError(code: call.method, message: "args is empty", details: nil))
                return
            }

            guard let args = args0 as? [String: Any] else {
                result(FlutterError(code: call.method, message: "args is empty", details: nil))
                return
            }

            if let streamingSettings = args["streamingSettings"] as? String {
                do {
                    try _rtpService.setStreamingSettings(newValue: JSONDecoder().decode(StreamingSettings.self, from: streamingSettings.data(using: .utf8)!))

                    result(true)

                    _rtpService.sendCameraStatusToDart()

                } catch {
                    result(FlutterError(code: "changeStreamingSettings", message: "\(error)", details: nil))
                }
            } else {
                result(FlutterError(code: "changeStreamingSettings", message: "initialParams empty", details: nil))
            }

        /*
         *
         *
         */
        case "startStream":

            guard let args0 = call.arguments else {
                result(FlutterError(code: call.method, message: "args is empty", details: nil))
                return
            }

            guard let args = args0 as? [String: Any] else {
                result(FlutterError(code: call.method, message: "args is empty", details: nil))
                return
            }

            if let uri = args["uri"] as? String,
               let streamName = args["streamName"] as? String
            {
                let endpoint = "\(uri)/\(streamName)"

                do {
                    _rtpService.startStreaming(uri: uri, streamName: streamName)

                    result(true)

                    _rtpService.sendCameraStatusToDart()

                } catch {
                    result(FlutterError(code: "startStream", message: "\(error)", details: nil))
                }
            } else {
                result(FlutterError(code: "startStream", message: "initialParams empty", details: nil))
            }

        /*
         *
         *
         */
        case "stopStream":

            do {
                _rtpService.stopStreaming()

                result(true)

                _rtpService.sendCameraStatusToDart()

            } catch {
                result(FlutterError(code: "stopStream", message: "\(error)", details: nil))
            }

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
