//
//  FooterAnimator.swift
//  ZhiXinBao
//
//  Created by shiyu on 2018/12/14.
//  Copyright © 2018 zhirong. All rights reserved.
//

import UIKit
import GSRefresh

class FooterAnimator: UIView {
    
    var loadingMoreDescription = "上拉加载更多"
    var noMoreDataDescription  = "已经全部加载完毕"
    var loadingDescription     = "正在加载更多的数据..."
    
    var view: UIView { return self }
    var duration: TimeInterval = 0.3
    var insets: UIEdgeInsets   = .zero
    var trigger: CGFloat       = 44.0
    var execute: CGFloat       = 44.0
    var endDelay: CGFloat      = 0
    var hold: CGFloat          = 44
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 11.0)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .gray)
        indicatorView.isHidden = true
        return indicatorView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = loadingMoreDescription
        addSubview(titleLabel)
        addSubview(indicatorView)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let s = self.bounds.size
        let w = s.width
        let h = s.height
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint.init(x: w / 2.0, y: h / 2.0 + insets.top)
        indicatorView.bounds = CGRect(x: 0.0, y: 0.0, width: 10.0, height: 10.0)
        indicatorView.center = CGPoint.init(x: titleLabel.frame.origin.x - 18.0, y: titleLabel.center.y)
    }
    
}

extension FooterAnimator: CustomLoadMore {
    func loadMoreStateChanged(previous: LoadMoreState, newState: LoadMoreState) {
        switch newState {
        case .initial:
            indicatorView.startAnimating()
            titleLabel.text = loadingDescription
            indicatorView.isHidden = false
        case .refreshing:
            titleLabel.text = loadingMoreDescription
        case .noMore:
            titleLabel.text = noMoreDataDescription
        }
        setNeedsLayout()
    }
}
