//
//  ScrollViewWithHeader.swift
//  Xprototype
//
//  Created by Nicolas Duc-Dodon on 11/22/25.
//

import SwiftUI
import UIKit

struct ScrollViewWithHeader<Content: View>: UIViewRepresentable {
    let content: Content
    @Binding var headerOffset: CGFloat
    let safeAreaTop: CGFloat
    let headerHeight: CGFloat
    
    init(headerOffset: Binding<CGFloat>, safeAreaTop: CGFloat, headerHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self._headerOffset = headerOffset
        self.safeAreaTop = safeAreaTop
        self.headerHeight = headerHeight
        self.content = content()
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.showsVerticalScrollIndicator = true
        scrollView.backgroundColor = .clear
        scrollView.contentInsetAdjustmentBehavior = .never
        
        let hostingController = UIHostingController(rootView: content)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            hostingController.view.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
        context.coordinator.hostingController = hostingController
        context.coordinator.scrollView = scrollView
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        context.coordinator.hostingController?.rootView = content
        
        // Set fixed content inset for header space
        let topInset = safeAreaTop + headerHeight
        if uiView.contentInset.top != topInset {
            uiView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
            uiView.scrollIndicatorInsets = uiView.contentInset
        }
        
        DispatchQueue.main.async {
            if let hostingView = context.coordinator.hostingController?.view {
                hostingView.setNeedsLayout()
                hostingView.layoutIfNeeded()
                let size = hostingView.systemLayoutSizeFitting(
                    CGSize(width: uiView.bounds.width, height: UIView.layoutFittingExpandedSize.height),
                    withHorizontalFittingPriority: .required,
                    verticalFittingPriority: .fittingSizeLevel
                )
                uiView.contentSize = CGSize(width: uiView.bounds.width, height: size.height)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(headerOffset: $headerOffset, safeAreaTop: safeAreaTop, headerHeight: headerHeight)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        @Binding var headerOffset: CGFloat
        let safeAreaTop: CGFloat
        let headerHeight: CGFloat
        var lastContentOffset: CGFloat = 0
        var hostingController: UIHostingController<Content>?
        var scrollView: UIScrollView?
        
        init(headerOffset: Binding<CGFloat>, safeAreaTop: CGFloat, headerHeight: CGFloat) {
            self._headerOffset = headerOffset
            self.safeAreaTop = safeAreaTop
            self.headerHeight = headerHeight
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let currentOffset = scrollView.contentOffset.y
            let delta = currentOffset - lastContentOffset
            let totalHeaderHeight = safeAreaTop + headerHeight
            
            // At the very top, always show header
            let adjustedOffset = currentOffset + scrollView.contentInset.top
            if adjustedOffset <= 0 {
                if headerOffset != 0 {
                    self.headerOffset = 0
                }
                lastContentOffset = currentOffset
                return
            }
            
            // Calculate new header offset based on scroll direction
            // Scrolling down (delta > 0): hide header
            // Scrolling up (delta < 0): show header
            var newOffset = headerOffset - delta
            
            // Clamp between -totalHeaderHeight (hidden) and 0 (visible)
            newOffset = min(0, max(-totalHeaderHeight, newOffset))
            
            // Update header offset
            if newOffset != headerOffset {
                self.headerOffset = newOffset
            }
            
            lastContentOffset = currentOffset
        }
    }
}

