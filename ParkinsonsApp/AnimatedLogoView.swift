//
//  AnimatedLogoView.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 30/03/2026.
//

import SwiftUI
import CoreMotion

// MARK: - Logo Paths

/// The pink asterisk/tulip flower shape from the SVG
/// Original SVG coordinates (after transform +24, +20), viewBox 177.75 x 191.25
struct PinkFlowerPath: Shape {
    func path(in rect: CGRect) -> Path {
        let sx = rect.width / 177.75
        let sy = rect.height / 191.25

        var path = Path()

        // Translated path: all coordinates offset by (24, 20)
        path.move(to: CGPoint(x: (24 + 72.125) * sx, y: (20 + 10.156) * sy))
        path.addLine(to: CGPoint(x: (24 + 72.652) * sx, y: (20 + 41.285) * sy))
        path.addCurve(
            to: CGPoint(x: (24 + 75.664) * sx, y: (20 + 47.031) * sy),
            control1: CGPoint(x: (24 + 72.691) * sx, y: (20 + 43.570) * sy),
            control2: CGPoint(x: (24 + 73.809) * sx, y: (20 + 45.699) * sy)
        )
        path.addCurve(
            to: CGPoint(x: (24 + 82.070) * sx, y: (20 + 48.039) * sy),
            control1: CGPoint(x: (24 + 77.520) * sx, y: (20 + 48.359) * sy),
            control2: CGPoint(x: (24 + 79.895) * sx, y: (20 + 48.734) * sy)
        )
        path.addLine(to: CGPoint(x: (24 + 110.637) * sx, y: (20 + 38.910) * sy))
        path.addCurve(
            to: CGPoint(x: (24 + 123.195) * sx, y: (20 + 45.086) * sy),
            control1: CGPoint(x: (24 + 115.801) * sx, y: (20 + 37.262) * sy),
            control2: CGPoint(x: (24 + 121.348) * sx, y: (20 + 39.988) * sy)
        )
        path.addLine(to: CGPoint(x: (24 + 123.625) * sx, y: (20 + 46.281) * sy))
        path.addCurve(
            to: CGPoint(x: (24 + 123.234) * sx, y: (20 + 53.598) * sy),
            control1: CGPoint(x: (24 + 124.492) * sx, y: (20 + 48.672) * sy),
            control2: CGPoint(x: (24 + 124.352) * sx, y: (20 + 51.312) * sy)
        )
        path.addCurve(
            to: CGPoint(x: (24 + 117.695) * sx, y: (20 + 58.398) * sy),
            control1: CGPoint(x: (24 + 122.113) * sx, y: (20 + 55.883) * sy),
            control2: CGPoint(x: (24 + 120.113) * sx, y: (20 + 57.617) * sy)
        )
        path.addLine(to: CGPoint(x: (24 + 88.699) * sx, y: (20 + 67.770) * sy))
        path.addCurve(
            to: CGPoint(x: (24 + 84.191) * sx, y: (20 + 72.281) * sy),
            control1: CGPoint(x: (24 + 86.559) * sx, y: (20 + 68.461) * sy),
            control2: CGPoint(x: (24 + 84.883) * sx, y: (20 + 70.141) * sy)
        )
        path.addCurve(
            to: CGPoint(x: (24 + 85.215) * sx, y: (20 + 78.578) * sy),
            control1: CGPoint(x: (24 + 83.5) * sx, y: (20 + 74.422) * sy),
            control2: CGPoint(x: (24 + 83.883) * sx, y: (20 + 76.766) * sy)
        )
        path.addLine(to: CGPoint(x: (24 + 104.020) * sx, y: (20 + 104.133) * sy))
        path.addCurve(
            to: CGPoint(x: (24 + 101.949) * sx, y: (20 + 117.711) * sy),
            control1: CGPoint(x: (24 + 107.195) * sx, y: (20 + 108.453) * sy),
            control2: CGPoint(x: (24 + 106.270) * sx, y: (20 + 114.531) * sy)
        )
        path.addLine(to: CGPoint(x: (24 + 101.199) * sx, y: (20 + 118.266) * sy))
        path.addCurve(
            to: CGPoint(x: (24 + 87.621) * sx, y: (20 + 116.199) * sy),
            control1: CGPoint(x: (24 + 96.879) * sx, y: (20 + 121.445) * sy),
            control2: CGPoint(x: (24 + 90.797) * sx, y: (20 + 120.520) * sy)
        )
        path.addLine(to: CGPoint(x: (24 + 68.816) * sx, y: (20 + 90.645) * sy))
        path.addCurve(
            to: CGPoint(x: (24 + 63.109) * sx, y: (20 + 87.793) * sy),
            control1: CGPoint(x: (24 + 67.484) * sx, y: (20 + 88.832) * sy),
            control2: CGPoint(x: (24 + 65.359) * sx, y: (20 + 87.770) * sy)
        )
        path.addCurve(
            to: CGPoint(x: (24 + 57.461) * sx, y: (20 + 90.754) * sy),
            control1: CGPoint(x: (24 + 60.859) * sx, y: (20 + 87.816) * sy),
            control2: CGPoint(x: (24 + 58.758) * sx, y: (20 + 88.918) * sy)
        )
        path.addLine(to: CGPoint(x: (24 + 39.887) * sx, y: (20 + 115.648) * sy))
        path.addCurve(
            to: CGPoint(x: (24 + 33.621) * sx, y: (20 + 119.582) * sy),
            control1: CGPoint(x: (24 + 38.406) * sx, y: (20 + 117.742) * sy),
            control2: CGPoint(x: (24 + 36.152) * sx, y: (20 + 119.160) * sy)
        )
        path.addCurve(
            to: CGPoint(x: (24 + 26.418) * sx, y: (20 + 117.891) * sy),
            control1: CGPoint(x: (24 + 31.090) * sx, y: (20 + 120.004) * sy),
            control2: CGPoint(x: (24 + 28.496) * sx, y: (20 + 119.395) * sy)
        )
        path.addLine(to: CGPoint(x: (24 + 25.266) * sx, y: (20 + 117.055) * sy))
        path.addCurve(
            to: CGPoint(x: (24 + 23.0) * sx, y: (20 + 103.430) * sy),
            control1: CGPoint(x: (24 + 20.906) * sx, y: (20 + 113.902) * sy),
            control2: CGPoint(x: (24 + 19.895) * sx, y: (20 + 107.828) * sy)
        )
        path.addLine(to: CGPoint(x: (24 + 40.570) * sx, y: (20 + 78.539) * sy))
        path.addCurve(
            to: CGPoint(x: (24 + 41.527) * sx, y: (20 + 72.137) * sy),
            control1: CGPoint(x: (24 + 41.887) * sx, y: (20 + 76.676) * sy),
            control2: CGPoint(x: (24 + 42.242) * sx, y: (20 + 74.301) * sy)
        )
        path.addCurve(
            to: CGPoint(x: (24 + 36.949) * sx, y: (20 + 67.555) * sy),
            control1: CGPoint(x: (24 + 40.812) * sx, y: (20 + 69.969) * sy),
            control2: CGPoint(x: (24 + 39.117) * sx, y: (20 + 68.273) * sy)
        )
        path.addLine(to: CGPoint(x: (24 + 7.391) * sx, y: (20 + 57.789) * sy))
        path.addCurve(
            to: CGPoint(x: (24 + 0.949) * sx, y: (20 + 45.438) * sy),
            control1: CGPoint(x: (24 + 2.254) * sx, y: (20 + 56.090) * sy),
            control2: CGPoint(x: (24 + -0.598) * sx, y: (20 + 50.617) * sy)
        )
        path.addLine(to: CGPoint(x: (24 + 1.320) * sx, y: (20 + 44.199) * sy))
        path.addCurve(
            to: CGPoint(x: (24 + 6.0) * sx, y: (20 + 38.535) * sy),
            control1: CGPoint(x: (24 + 2.051) * sx, y: (20 + 41.758) * sy),
            control2: CGPoint(x: (24 + 3.738) * sx, y: (20 + 39.711) * sy)
        )
        path.addCurve(
            to: CGPoint(x: (24 + 13.324) * sx, y: (20 + 37.941) * sy),
            control1: CGPoint(x: (24 + 8.258) * sx, y: (20 + 37.355) * sy),
            control2: CGPoint(x: (24 + 10.902) * sx, y: (20 + 37.141) * sy)
        )
        path.addLine(to: CGPoint(x: (24 + 42.883) * sx, y: (20 + 47.711) * sy))
        path.addCurve(
            to: CGPoint(x: (24 + 49.133) * sx, y: (20 + 46.715) * sy),
            control1: CGPoint(x: (24 + 45.004) * sx, y: (20 + 48.410) * sy),
            control2: CGPoint(x: (24 + 47.336) * sx, y: (20 + 48.039) * sy)
        )
        path.addCurve(
            to: CGPoint(x: (24 + 51.941) * sx, y: (20 + 41.047) * sy),
            control1: CGPoint(x: (24 + 50.934) * sx, y: (20 + 45.391) * sy),
            control2: CGPoint(x: (24 + 51.980) * sx, y: (20 + 43.277) * sy)
        )
        path.addLine(to: CGPoint(x: (24 + 51.410) * sx, y: (20 + 9.918) * sy))
        path.addCurve(
            to: CGPoint(x: (24 + 54.156) * sx, y: (20 + 3.102) * sy),
            control1: CGPoint(x: (24 + 51.367) * sx, y: (20 + 7.367) * sy),
            control2: CGPoint(x: (24 + 52.359) * sx, y: (20 + 4.911) * sy)
        )
        path.addCurve(
            to: CGPoint(x: (24 + 60.957) * sx, y: (20 + 0.320) * sy),
            control1: CGPoint(x: (24 + 55.953) * sx, y: (20 + 1.293) * sy),
            control2: CGPoint(x: (24 + 58.406) * sx, y: (20 + 0.289) * sy)
        )
        path.addLine(to: CGPoint(x: (24 + 62.246) * sx, y: (20 + 0.332) * sy))
        path.addCurve(
            to: CGPoint(x: (24 + 72.125) * sx, y: (20 + 10.156) * sy),
            control1: CGPoint(x: (24 + 67.656) * sx, y: (20 + 0.398) * sy),
            control2: CGPoint(x: (24 + 72.031) * sx, y: (20 + 4.750) * sy)
        )
        path.closeSubpath()

        return path
    }
}

/// The green stem (vertical rounded pill) from the SVG
struct GreenStemPath: Shape {
    func path(in rect: CGRect) -> Path {
        let sx = rect.width / 177.75
        let sy = rect.height / 191.25

        // Rounded rect from (76.484, 105.004) to (96.898, 190.449), corner radius ~10.2
        let stemRect = CGRect(
            x: 76.484 * sx,
            y: 105.004 * sy,
            width: 20.414 * sx,
            height: 85.445 * sy
        )
        let cornerRadius = 10.207 * min(sx, sy)

        var path = Path()
        path.addRoundedRect(in: stemRect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
        return path
    }
}

// MARK: - Animated Logo View

struct AnimatedLogoView: View {
    let size: CGFloat
    @Binding var isAnimating: Bool
    @State private var rotation: Double = 0
    @State private var stemScale: CGFloat = 0
    @State private var flowerScale: CGFloat = 0
    @State private var flowerOpacity: Double = 0
    @State private var stemOpacity: Double = 0
    @State private var glowOpacity: Double = 0

    var body: some View {
        ZStack {
            // Glow behind flower
            PinkFlowerPath()
                .fill(Color(hex: 0xFF7AC2).opacity(0.3))
                .blur(radius: 20)
                .frame(width: size, height: size * (191.25 / 177.75))
                .rotationEffect(.degrees(rotation))
                .scaleEffect(flowerScale * 1.1)
                .opacity(glowOpacity)

            // Green stem (stays still)
            GreenStemPath()
                .fill(Color(hex: 0xB4FF48))
                .frame(width: size, height: size * (191.25 / 177.75))
                .scaleEffect(y: stemScale, anchor: .bottom)
                .opacity(stemOpacity)

            // Pink flower (rotates)
            PinkFlowerPath()
                .fill(Color(hex: 0xFF7AC2))
                .frame(width: size, height: size * (191.25 / 177.75))
                .rotationEffect(.degrees(rotation))
                .scaleEffect(flowerScale)
                .opacity(flowerOpacity)
        }
        .onChange(of: isAnimating) { _, animating in
            if animating {
                playAnimation()
            }
        }
        .onAppear {
            if isAnimating {
                playAnimation()
            }
        }
    }

    private func playAnimation() {
        // Reset
        rotation = -90
        stemScale = 0
        flowerScale = 0
        flowerOpacity = 0
        stemOpacity = 0
        glowOpacity = 0

        // Step 1: Stem grows up
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
            stemScale = 1.0
            stemOpacity = 1.0
        }

        // Step 2: Flower appears and rotates in
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.5)) {
            flowerScale = 1.0
            flowerOpacity = 1.0
            rotation = 0
        }

        // Step 3: Glow pulse
        withAnimation(.easeInOut(duration: 0.6).delay(0.9)) {
            glowOpacity = 0.6
        }
        withAnimation(.easeInOut(duration: 0.8).delay(1.5)) {
            glowOpacity = 0
        }

        // Step 4: Gentle continuous rotation settles
        withAnimation(.spring(response: 1.0, dampingFraction: 0.5).delay(1.2)) {
            rotation = 10
        }
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(1.8)) {
            rotation = 0
        }
    }
}

// MARK: - Static Logo View (for header/icons)

struct LogoView: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            GreenStemPath()
                .fill(Color(hex: 0xB4FF48))
            PinkFlowerPath()
                .fill(Color(hex: 0xFF7AC2))
        }
        .frame(width: size, height: size * (191.25 / 177.75))
    }
}

// MARK: - Splash Screen

struct SplashScreen: View {
    @Binding var isFinished: Bool
    @State private var isAnimating = false
    @State private var titleOpacity: Double = 0
    @State private var titleOffset: CGFloat = 20
    @State private var subtitleOpacity: Double = 0
    @State private var bgOpacity: Double = 1.0

    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                AnimatedLogoView(size: 120, isAnimating: $isAnimating)

                VStack(spacing: 8) {
                    Text("Stigma")
                        .logoStyle(size: 36)
                        .foregroundStyle(Theme.text)
                        .opacity(titleOpacity)
                        .offset(y: titleOffset)

                    Text("Your invisible challenge community")
                        .subheadlineStyle()
                        .foregroundStyle(Theme.text.opacity(0.6))
                        .opacity(subtitleOpacity)
                }

                Spacer()
                Spacer()
            }
        }
        .opacity(bgOpacity)
        .onAppear {
            isAnimating = true

            // Title fades in
            withAnimation(.easeOut(duration: 0.6).delay(1.0)) {
                titleOpacity = 1
                titleOffset = 0
            }
            withAnimation(.easeOut(duration: 0.6).delay(1.3)) {
                subtitleOpacity = 1
            }

            // Dismiss after animation
            withAnimation(.easeInOut(duration: 0.5).delay(2.5)) {
                bgOpacity = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                isFinished = true
            }
        }
    }
}

// MARK: - Motion Manager (Singleton for accelerometer data)

final class MotionManager: @unchecked Sendable {
    static let shared = MotionManager()
    let manager = CMMotionManager()

    private init() {}

    func startUpdates(handler: @escaping (CMAccelerometerData) -> Void) {
        guard manager.isAccelerometerAvailable else { return }
        manager.accelerometerUpdateInterval = 1.0 / 60.0
        manager.startAccelerometerUpdates(to: .main) { data, _ in
            if let data { handler(data) }
        }
    }

    func stopUpdates() {
        manager.stopAccelerometerUpdates()
    }
}

// MARK: - Motion-Responsive Logo (for Welcome/Onboarding)

/// A large SVG logo with no background that responds to device motion.
/// The pink flower bends/rotates based on accelerometer data;
/// the green stem stays anchored, bending slightly.
struct MotionResponsiveLogoView: View {
    let size: CGFloat

    // Motion state
    @State private var tiltX: CGFloat = 0  // side-to-side
    @State private var tiltY: CGFloat = 0  // front-to-back
    @State private var flowerRotation: Double = 0
    @State private var flowerOffsetX: CGFloat = 0
    @State private var flowerOffsetY: CGFloat = 0
    @State private var stemSkew: CGFloat = 0
    @State private var isActive = false

    // Entry animation
    @State private var appeared = false

    private let aspect: CGFloat = 191.25 / 177.75

    var body: some View {
        ZStack {
            // Soft glow behind flower
            PinkFlowerPath()
                .fill(Color(hex: 0xFF7AC2).opacity(0.15))
                .blur(radius: 24)
                .frame(width: size, height: size * aspect)
                .rotationEffect(.degrees(flowerRotation))
                .offset(x: flowerOffsetX * 0.5, y: flowerOffsetY * 0.5)

            // Green stem — stays mostly still, slight lean
            GreenStemPath()
                .fill(Color(hex: 0xB4FF48))
                .frame(width: size, height: size * aspect)
                .transformEffect(CGAffineTransform(a: 1, b: 0, c: stemSkew * 0.15, d: 1, tx: 0, ty: 0))
                .scaleEffect(appeared ? 1 : 0, anchor: .bottom)

            // Pink flower — reacts to motion
            PinkFlowerPath()
                .fill(Color(hex: 0xFF7AC2))
                .frame(width: size, height: size * aspect)
                .rotationEffect(.degrees(flowerRotation))
                .offset(x: flowerOffsetX, y: flowerOffsetY)
                .scaleEffect(appeared ? 1 : 0.3)
                .opacity(appeared ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.65).delay(0.2)) {
                appeared = true
            }
            startMotion()
        }
        .onDisappear {
            stopMotion()
        }
    }

    private func startMotion() {
        isActive = true
        MotionManager.shared.startUpdates { data in
            guard isActive else { return }
            let ax = CGFloat(data.acceleration.x)  // left/right tilt
            let ay = CGFloat(data.acceleration.y)  // forward/back tilt

            // Smooth the values
            withAnimation(.interactiveSpring(response: 0.15, dampingFraction: 0.6)) {
                tiltX = ax
                tiltY = ay

                // Flower bends in direction of tilt
                flowerRotation = Double(ax * 25)         // up to ±25° rotation
                flowerOffsetX = ax * size * 0.08          // slight horizontal shift
                flowerOffsetY = ay * size * 0.06           // slight vertical shift

                // Stem leans slightly
                stemSkew = ax * 0.3
            }
        }
    }

    private func stopMotion() {
        isActive = false
        MotionManager.shared.stopUpdates()
    }
}

#Preview("Motion Logo") {
    ZStack {
        Color(hex: 0xFAF5EB).ignoresSafeArea()
        MotionResponsiveLogoView(size: 180)
    }
}

#Preview("Animated Logo") {
    ZStack {
        Color(hex: 0xFAF8F5).ignoresSafeArea()
        AnimatedLogoView(size: 150, isAnimating: .constant(true))
    }
}

#Preview("Static Logo") {
    LogoView(size: 60)
}

#Preview("Splash Screen") {
    SplashScreen(isFinished: .constant(false))
}
