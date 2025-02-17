//
//  Models.swift
//  flutter_rtmp_streamer
//
//  Created by kuzalex on 5/10/22.
//

import AVFoundation
import Foundation

struct Resolution: Codable {
    let width: Int
    let height: Int

    static func fromPreset(preset: AVCaptureSession.Preset) -> Resolution {
        switch preset {
        case AVCaptureSession.Preset.hd4K3840x2160:
            return Resolution(width: 3840, height: 2160)
        case AVCaptureSession.Preset.hd1920x1080:
            return Resolution(width: 1920, height: 1080)
        case AVCaptureSession.Preset.hd1280x720:
            return Resolution(width: 1280, height: 720)
        case AVCaptureSession.Preset.iFrame960x540:
            return Resolution(width: 960, height: 540)
        case AVCaptureSession.Preset.vga640x480:
            return Resolution(width: 640, height: 480)
        case AVCaptureSession.Preset.cif352x288:
            return Resolution(width: 352, height: 288)

        default:
            print("Invalid AVCaptureSession.Preset \(preset)")
            return Resolution(width: 640, height: 480)
        }
    }

    func toString() -> String {
        return "\(width)x\(height)"
    }

    func toPreset() -> AVCaptureSession.Preset {
        if width == 3840 && height == 2160 {
            return AVCaptureSession.Preset.hd4K3840x2160
        }
        if width == 1920 && height == 1080 {
            return AVCaptureSession.Preset.hd1920x1080
        }
        if width == 1280 && height == 720 {
            return AVCaptureSession.Preset.hd1280x720
        }
        if width == 960 && height == 540 {
            return AVCaptureSession.Preset.iFrame960x540
        }
        if width == 640 && height == 480 {
            return AVCaptureSession.Preset.vga640x480
        }
        if width == 352 && height == 288 {
            return AVCaptureSession.Preset.cif352x288
        }

        print("toPreset failed: \(toString())")
        return AVCaptureSession.Preset.vga640x480
    }
}

func == (lhs: Resolution, rhs: Resolution) -> Bool {
    return lhs.width == rhs.width && lhs.height == rhs.height
}

func != (lhs: Resolution, rhs: Resolution) -> Bool {
    return !(lhs == rhs)
}

struct StreamingSettings: Codable {
    let serviceInBackground: Bool // not used
    var resolution: Resolution
    var videoFps: Int
    var videoBitrate: Int
    var h264profile: String
    var stabilizationMode: String
    var audioBitrate: Int
    var audioSampleRate: Int
    var audioChannelCount: Int // not used
    var cameraFacing: String

    var muteAudio: Bool
}

func == (lhs: StreamingSettings, rhs: StreamingSettings) -> Bool {
    return lhs.resolution == rhs.resolution
        && lhs.videoFps == rhs.videoFps
        && lhs.serviceInBackground == rhs.serviceInBackground
        && lhs.videoBitrate == rhs.videoBitrate
        && lhs.h264profile == rhs.h264profile
        && lhs.stabilizationMode == rhs.stabilizationMode
        && lhs.audioBitrate == rhs.audioBitrate
        && lhs.audioSampleRate == rhs.audioSampleRate
        && lhs.audioChannelCount == rhs.audioChannelCount
        && lhs.cameraFacing == rhs.cameraFacing
        && lhs.muteAudio == rhs.muteAudio
}

func != (lhs: StreamingSettings, rhs: StreamingSettings) -> Bool {
    return !(lhs == rhs)
}

struct StreamingState: Codable {
    var isStreaming: Bool
    var isOnPreview: Bool
    var isAudioMuted: Bool
    var isRtmpConnected: Bool
    var streamResolution: Resolution
    var resolution: Resolution
    var cameraOrientation: Int
    var streamingSettings: StreamingSettings
}

//
struct BackAndFrontResolutions: Codable {
    let back: [Resolution]
    let front: [Resolution]
}

extension String: Error {}
