//
//  Animator.swift
//  granular
//
//  Created by Dmitry Babenko on 2019-06-02.
//  Copyright © 2019 Decowareb. All rights reserved.
//

import UIKit

typealias Animation = (UITableViewCell, IndexPath, UITableView) -> Void
final class Animator {
    private var hasAnimatedAllCells = false
    private let animation: Animation
    var fakeLabel: UILabel?
    
    init(animation: @escaping Animation) {
        self.animation = animation
    }
    
    func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
        guard !hasAnimatedAllCells else {
            return
        }
        animation(cell, indexPath, tableView)
        hasAnimatedAllCells = tableView.isLastVisibleCell(at: indexPath)
    }
    
    func makeSlideMoveWithBounce(span: CGFloat, duration: TimeInterval, delayFactor: Double) -> Animation {
        return { cell, indexPath, tableView in
            cell.contentView.transform = CGAffineTransform(translationX: -span, y: 0)
            let labelW = CGFloat(100)
            let rect = CGRect(x: cell.frame.size.width - labelW, y: 0, width: labelW, height: cell.frame.size.height)
            self.fakeLabel = UILabel(frame: rect)
            self.fakeLabel?.text = "Delete   "
            self.fakeLabel?.backgroundColor = .green
            self.fakeLabel?.textColor = .white
            self.fakeLabel?.textAlignment = .right
//            cell.insertSubview(self.fakeLabel, at: 0)
            
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                usingSpringWithDamping: 0.4,
                initialSpringVelocity: 0.1,
                options: [.curveEaseInOut],
                animations: {
                    cell.contentView.transform = CGAffineTransform(translationX: 0, y: 0)
            }) { done in
                if done {
                    
                }
            }
        }
    }
}

enum AnimationFactory {
    
    static func makeSlideMoveWithBounce(span: CGFloat, duration: TimeInterval, delayFactor: Double) -> Animation {
        return { cell, indexPath, tableView in
            cell.contentView.transform = CGAffineTransform(translationX: -span, y: 0)
            let labelW = CGFloat(100)
            let rect = CGRect(x: cell.frame.size.width - labelW, y: 0, width: labelW, height: cell.frame.size.height)
//            self.fakeLabel = UILabel(frame: rect)
//            fakeLabel?.text = "Delete   "
//            fakeLabel?.backgroundColor = .green
//            fakeLabel?.textColor = .white
//            fakeLabel?.textAlignment = .right
//            cell.insertSubview(fakeLabel, at: 0)
            
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                usingSpringWithDamping: 0.4,
                initialSpringVelocity: 0.1,
                options: [.curveEaseInOut],
                animations: {
                    cell.contentView.transform = CGAffineTransform(translationX: 0, y: 0)
            }) { done in
                if done {
                    
                }
            }
        }
    }
}

extension UITableView {
    func isLastVisibleCell(at indexPath: IndexPath) -> Bool {
        guard let lastIndexPath = self.indexPathsForVisibleRows?.last else {
            return true
        }
        return lastIndexPath == indexPath
    }
}
