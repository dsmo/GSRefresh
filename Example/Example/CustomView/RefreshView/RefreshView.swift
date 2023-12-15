//
//  RefreshView.swift
//  AIPhoto
//
//  Created by shiyu on 2023/9/11.
//

import UIKit
import GSRefresh

class RefreshView: UIView {
    
    static let circleRotationAnimationDuration: CFTimeInterval = 0.4
    
    private lazy var animationLayer: RefreshAnimationLayer = RefreshAnimationLayer()
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.text = "Pull down to refresh..."
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    var backgroundType: BackgroundType = .clear {
        didSet {
            switch backgroundType {
            case .clear:
                backgroundView?.removeFromSuperview()
                backgroundView = nil
            case .extend(let color):
                configureBackgroundView(color: color)
                setNeedsLayout()
            }
        }
    }
    /// 背景衬色View，个人中心首页下拉刷新背景色是白色
    private var backgroundView: UIView?
    
    enum BackgroundType {
        case clear
        case extend(UIColor)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        containerView.layer.addSublayer(animationLayer)
        containerView.addSubview(label)
        addSubview(containerView)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let viewWidth = self.frame.size.width
        let viewHeight = self.frame.size.height
        
        label.sizeToFit()
        let animationSideWidth: CGFloat = 16
        let labelWidth = label.bounds.width
        let labelHeight = label.bounds.height
        let labelPadding: CGFloat = 4
        
        // container
        let containerInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        let containerWidth = animationSideWidth + labelWidth + labelPadding + containerInsets.left + containerInsets.right
        let containerHeight = max(labelHeight, animationSideWidth) + containerInsets.top + containerInsets.bottom
        let containerOriginX = (viewWidth - containerWidth) / 2
        let containerOriginY = (viewHeight - containerHeight) / 2
        containerView.frame = CGRect(
            x: containerOriginX,
            y: containerOriginY,
            width: containerWidth,
            height: containerHeight
        ).integral
        containerView.layer.cornerRadius = containerHeight / 2
        
        // animation layer
        let animationOriginY = (containerHeight - animationSideWidth) / 2.0
        animationLayer.frame = CGRect(
            x: containerInsets.left,
            y: animationOriginY,
            width: animationSideWidth,
            height: animationSideWidth
        ).integral
        
        // label
        let labelOriginX = animationLayer.frame.maxX + labelPadding
        let labelOriginY = (containerHeight - labelHeight) / 2.0
        label.frame = CGRect(
            x: labelOriginX,
            y: labelOriginY,
            width: labelWidth,
            height: labelHeight
        ).integral
        
        // background
        switch backgroundType {
        case .extend:
            backgroundView?.frame = CGRect(x: 0.0, y: viewHeight - 1000.0, width: viewWidth, height: 1000.0)
        default:
            break
        }
    }
    
    // MARK: - Private
    
    private func configureBackgroundView(color: UIColor) {
        if let view = backgroundView {
            view.backgroundColor = color
        } else {
            let view = UIView()
            view.backgroundColor = color
            insertSubview(view, at: 0)
            backgroundView = view
        }
    }
}

extension RefreshView: CustomRefresh {
    public func refreshStateChanged(previous: RefreshState, newState: RefreshState) {
        switch newState {
        case .initial:
            animationLayer.circleLayer.endAnimation()
        case .pulling(let fraction):
            label.text = "Pull down to refresh..."
            layoutIfNeeded()
            setNeedsLayout()
            animationLayer.circleLayer.progress = fraction
        case .refreshing:
            label.text = "Refreshing"
            setNeedsLayout()
            layoutIfNeeded()
            animationLayer.circleLayer.startAnimation()
        }
    }
}
