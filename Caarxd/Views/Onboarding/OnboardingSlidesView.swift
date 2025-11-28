//
//  OnboardingSlidesView.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI

struct OnboardingSlidesView: View {
    @State private var currentPage = 0
    @State private var showingLogin = false
    @State private var showingSignUp = false

    let slides = OnboardingSlide.allSlides

    var body: some View {
        ZStack {
            TabView(selection: $currentPage) {
                ForEach(0..<slides.count, id: \.self) { index in
                    SlideView(slide: slides[index])
                        .tag(index)
                }

                // Final slide - Login/Signup
                AuthChoiceView(
                    showingLogin: $showingLogin,
                    showingSignUp: $showingSignUp
                )
                .tag(slides.count)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
        .sheet(isPresented: $showingLogin) {
            LoginView()
        }
        .sheet(isPresented: $showingSignUp) {
            SignUpView()
        }
    }
}

struct SlideView: View {
    let slide: OnboardingSlide

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xxxl) {
            Spacer()

            Image(systemName: slide.iconName)
                .font(.system(size: 80))
                .foregroundColor(DesignSystem.Colors.accent)

            VStack(spacing: DesignSystem.Spacing.lg) {
                Text(slide.title)
                    .font(DesignSystem.Typography.displayMedium)
                    .foregroundColor(DesignSystem.Colors.text)
                    .multilineTextAlignment(.center)

                Text(slide.description)
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignSystem.Spacing.xxxl)
            }

            Spacer()
            Spacer()
        }
        .padding(DesignSystem.Spacing.lg)
    }
}

struct AuthChoiceView: View {
    @Binding var showingLogin: Bool
    @Binding var showingSignUp: Bool

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xxxl) {
            Spacer()

            Image(systemName: "rectangle.portrait.and.arrow.forward")
                .font(.system(size: 80))
                .foregroundColor(DesignSystem.Colors.accent)

            VStack(spacing: DesignSystem.Spacing.lg) {
                Text("Ready to Get Started?")
                    .font(DesignSystem.Typography.displayMedium)
                    .foregroundColor(DesignSystem.Colors.text)
                    .multilineTextAlignment(.center)

                Text("Create your account or sign in to access your digital business cards")
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignSystem.Spacing.xxxl)
            }

            VStack(spacing: DesignSystem.Spacing.md) {
                Button(action: { showingSignUp = true }) {
                    Text("Create Account")
                        .primaryButton()
                }

                Button(action: { showingLogin = true }) {
                    Text("Sign In")
                        .secondaryButton()
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.xxxl)

            Spacer()
        }
        .padding(DesignSystem.Spacing.lg)
    }
}

struct OnboardingSlide {
    let iconName: String
    let title: String
    let description: String

    static let allSlides = [
        OnboardingSlide(
            iconName: "person.crop.rectangle",
            title: "Create Digital Cards",
            description: "Design beautiful, professional business cards in seconds. No printing required."
        ),
        OnboardingSlide(
            iconName: "square.and.arrow.up",
            title: "Share Instantly",
            description: "Share your card via QR code, link, or direct contact. Fast and effortless."
        ),
        OnboardingSlide(
            iconName: "chart.line.uptrend.xyaxis",
            title: "Track Analytics",
            description: "See who views your card, track shares, and measure engagement in real-time."
        ),
        OnboardingSlide(
            iconName: "wallet.pass",
            title: "Your Digital Wallet",
            description: "Store all your cards in one place. Access them anytime, anywhere."
        )
    ]
}

#Preview {
    OnboardingSlidesView()
}
