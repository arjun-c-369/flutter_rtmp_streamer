//
//  CameraView.swift
//  flutter_rtmp_streamer
//
//  Created by kuzalex on 5/10/22.
//

import AVFoundation
import Foundation

import HaishinKit
import Logboard
import MetalKit
import VideoToolbox

class CameraView: NSObject, FlutterPlatformView {
    private var _view: CameraEmbedView
    private var _rtpService: RtpService

    init(
        frame _: CGRect,
        viewIdentifier _: Int64,
        arguments _: Any?,
        rtpService: RtpService
    ) {
        _view = CameraEmbedView()
        _view.backgroundColor = UIColor.black
        _rtpService = rtpService

        _rtpService.startPreview(lfView: _view.glView!)
        _rtpService.sendCameraStatusToDart()

        super.init()
    }

    deinit {
        _rtpService.stopPreview()
        _rtpService.sendCameraStatusToDart()
    }

    func view() -> UIView {
        return _view
    }
}

class CameraEmbedView: UIView {
    private var _glView: MTHKView? // _x -> backingX
    var glView: MTHKView? { return _glView }

    override init(frame: CGRect) {
        super.init(frame: frame)
        _glView = MTHKView(frame: frame)
        _glView!.videoGravity = AVLayerVideoGravity.resizeAspect

        addSubview(_glView!)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        print("current frame: \(frame)")
        if _glView != nil {
            _glView!.frame = frame
        }
        super.layoutSubviews()
    }
}
