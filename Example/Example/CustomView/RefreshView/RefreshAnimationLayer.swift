//
//  RefreshAnimationLayer.swift
//  AIPhoto
//
//  Created by shiyu on 2023/9/11.
//

import UIKit

class RefreshAnimationLayer: CALayer {
    
    lazy var circleLayer: RefreshCircleLayer = RefreshCircleLayer()
    
    override init() {
        super.init()
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    private func commonInit() {
        addCircleLayer()
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        layoutCircleLayer(frame: bounds)
    }
    
    private func addCircleLayer() {
        addSublayer(circleLayer)
    }
    
    private func layoutCircleLayer(frame: CGRect) {
        circleLayer.frame = frame
    }
    
}
