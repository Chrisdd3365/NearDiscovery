//
//  OverlayScrollViewDelegateProxy.swift
//  OverlayContainer
//
//  Created by Gaétan Zanella on 20/11/2018.
//

import Foundation

class OverlayScrollViewDelegateProxy: NSObject, UIScrollViewDelegate {

    private var scrollViewObservation: NSKeyValueObservation?
    private weak var originalDelegate: UIScrollViewDelegate?
    private weak var delegate: OverlayScrollViewDelegate?

    // MARK: - Life Cycle

    deinit {
        scrollViewObservation?.invalidate()
    }

    // MARK: - NSObject

    override func responds(to aSelector: Selector!) -> Bool {
        let originalDelegateRespondsToSelector = originalDelegate?.responds(to: aSelector) ?? false
        return super.responds(to: aSelector) || originalDelegateRespondsToSelector
    }

    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if originalDelegate?.responds(to: aSelector) == true {
            return originalDelegate
        } else {
            return super.forwardingTarget(for: aSelector)
        }
    }

    // MARK: - Public

    func forward(to delegate: OverlayScrollViewDelegate, delegateInvocationsFrom scrollView: UIScrollView) {
        scrollViewObservation?.invalidate()
        self.delegate = delegate
        self.originalDelegate = scrollView.delegate
        scrollView.delegate = self
        scrollViewObservation = scrollView.observe(\.delegate) { [weak self] (scrollView, delegate) in
            guard !(scrollView.delegate === self) else { return }
            self?.originalDelegate = scrollView.delegate
            scrollView.delegate = self
        }
    }

    // MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.overlayScrollViewDidScroll(scrollView)
        originalDelegate?.scrollViewDidScroll?(scrollView)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.overlayScrollView(
            scrollView,
            willEndDraggingwithVelocity: velocity.multiply(by: -1000),
            targetContentOffset: targetContentOffset
        )
        originalDelegate?.scrollViewWillEndDragging?(
            scrollView,
            withVelocity: velocity,
            targetContentOffset: targetContentOffset
        )
    }
}
