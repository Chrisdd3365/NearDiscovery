//
//  InterruptibleAnimatorOverlayContainerTransitionCoordinator.swift
//  OverlayContainer
//
//  Created by Gaétan Zanella on 28/11/2018.
//

import Foundation

class InterruptibleAnimatorOverlayContainerTransitionCoordinator: OverlayContainerTransitionCoordinator {

    var targetNotchIndex: Int {
        return context.targetNotchIndex
    }

    var targetNotchHeight: CGFloat {
        return context.targetNotchHeight
    }

    var overlayTranslationHeight: CGFloat {
        return context.overlayTranslationHeight
    }

    var notchIndexes: Range<Int> {
        return context.notchIndexes
    }

    private let animator: UIViewImplicitlyAnimating
    private let context: OverlayContainerTransitionCoordinatorContext

    init(animator: UIViewImplicitlyAnimating, context: OverlayContainerTransitionCoordinatorContext) {
        self.animator = animator
        self.context = context
    }

    func animate(alongsideTransition animation: ((OverlayContainerTransitionCoordinatorContext) -> Void)?,
                 completion: ((OverlayContainerTransitionCoordinatorContext) -> Void)?) {
        let context = self.context
        animator.addAnimations? {
            animation?(context)
        }
        animator.addCompletion? { _ in
            completion?(context)
        }
    }

    func height(forNotchAt index: Int) -> CGFloat {
        return context.height(forNotchAt: index)
    }
}
