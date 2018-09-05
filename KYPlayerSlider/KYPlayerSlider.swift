//
//  PlayerSlider.swift
//  xqapp_Demo
//
//  Created by kyang on 2018/9/4.
//  Copyright © 2018年 chinaxueqian. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class KYPlayerSlider: UIControl {

    /// 播放进度值
    @IBInspectable var playValue: Float = 0 {
        didSet{
            updateUI()
        }
    }
    /// 缓存进度
    @IBInspectable var bufferValue: Float = 0 {
        didSet {
            updateUI()
        }
    }
    /// 最小值
    @IBInspectable var minimumValue: Float = 0
    /// 最大值
    @IBInspectable var maximumValue: Float = 1

    /// 播放进度值
    private var playProgress: Float {
        return (playValue - minimumValue) / (maximumValue - minimumValue)
    }
    /// 缓存进度值
    private var bufferProgress: Float {
        return (bufferValue - minimumValue) / (maximumValue - minimumValue)
    }

    /// 是否在缓存
    public var beSliding: Bool = false

    /// thumbImage - normal
    public var thumbNormalImage: UIImage?
    /// thumbImage - hight
    public var thumbHightImage: UIImage?

    /// 颜色 缓存
    @IBInspectable public var bufferColor: UIColor {
        get { return progressView.bufferColor }
        set { progressView.bufferColor = newValue }
    }
    /// 颜色 播放
    @IBInspectable public var playColor: UIColor {
        get { return progressView.playColor }
        set { progressView.playColor = newValue}
    }
    /// 颜色 底色
    @IBInspectable public var wholeColor: UIColor {
        get { return progressView.wholeColor }
        set { progressView.wholeColor = newValue }
    }

    private var thumbNormalView: UIImageView!
    private var progressView: KYSlideProgressView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        self.beSliding = false

        self.isUserInteractionEnabled = true
        progressView = KYSlideProgressView(frame: CGRect(x: 0, y: (frame.height - 3) * 0.5, width: frame.width, height: 3))
        progressView.isUserInteractionEnabled = false
        addSubview(progressView)

        thumbNormalView = UIImageView(frame: CGRect(x: -8, y: (frame.height - 8) * 0.5, width: 16, height: 16))
        thumbNormalView.backgroundColor = UIColor.white
        thumbNormalView.layer.cornerRadius = 8
        thumbNormalView.layer.masksToBounds = true
        thumbNormalView.clipsToBounds = true
        thumbNormalView.isUserInteractionEnabled = false
        addSubview(thumbNormalView)

        layoutContainer()
    }


    private func layoutContainer() {
        progressView.snp.makeConstraints { (make) in
            make.left.equalTo(thumbNormalView.bounds.size.width * 0.5).priority(.high)
            make.centerY.equalToSuperview().offset(0)
            make.height.equalTo(3.0)
            make.right.equalToSuperview().offset(-thumbNormalView.bounds.size.width * 0.5).priority(.high)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }

    private func updateUI() {
        progressView.playProgress = self.playProgress
        progressView.bufferProgress = self.bufferProgress
        thumbNormalView.image = thumbNormalImage

        self.thumbNormalView.snp.remakeConstraints { (make) in
            make.size.equalTo(CGSize(width: 16, height: 16))
            make.centerX.equalTo(progressView.playProgressView.snp.right)
            make.centerY.equalTo(progressView.snp.centerY)
        }
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
//        let touchPoint = touch.location(in: self)
        let touchPoint = touch.location(in: self.progressView.wholeProgressView)

//        print("beginTracking")
        if self.slidePointImageRect().contains(touchPoint
            ) {
            self.beSliding = true
            self.thumbNormalView.image = thumbHightImage ?? UIImage(color: UIColor.white)
        }
        return true
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        var touchPoint = touch.location(in: self.progressView.wholeProgressView)
        let startX = self.progressView.wholeProgressView.bounds.minX
        let endX = self.progressView.wholeProgressView.bounds.maxX

        touchPoint.x = max(startX, touchPoint.x)
        touchPoint.x = min(endX, touchPoint.x)

        self.playValue = Float((touchPoint.x - startX) / (endX - startX)) * (maximumValue - minimumValue) + minimumValue
//        print("continueTracking\(self.playValue)")
        self.sendActions(for: .valueChanged)
        self.setNeedsLayout()
        self.beSliding = true
        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        self.beSliding = false
        self.thumbNormalView.image = thumbNormalImage ?? UIImage(color: UIColor.white)

    }
    private func slidePointImageRect() -> CGRect {
        var rect = thumbNormalView.frame
        rect.size.width += 8
        rect.size.height += 8
        return rect
    }
}

class KYSlideProgressView: UIView {

    public var bufferColor: UIColor = UIColor(red: 204.0/255.0, green: 1, blue: 204.0/255.0, alpha: 1)
    public var playColor: UIColor = UIColor(red: 137.0/255.0, green: 21.0/255.0, blue: 214.0/255.0, alpha: 1)
    public var wholeColor: UIColor = UIColor(red: 164.0/255.0, green: 166.0/255.0, blue: 164.0/255.0, alpha: 1)

    var wholeProgressView: UIView!
    var playProgressView: UIView!
    var bufferProgressView: UIView!
    var playProgress: Float = 0 {
        didSet{
            updatePlayProgress()
        }
    }
    var bufferProgress: Float = 0 {
        didSet{
            updateBufferProgress()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        //创建界面
        setupUI()

        //添加约束
        layoutContainer()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        wholeProgressView.backgroundColor = wholeColor
        bufferProgressView.backgroundColor = bufferColor
        playProgressView.backgroundColor = playColor
        
        updatePlayProgress()
        updateBufferProgress()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        wholeProgressView = UIView(frame: bounds)
        wholeProgressView.isUserInteractionEnabled = false
        self.addSubview(wholeProgressView)

        bufferProgressView = UIView(frame: .zero)
        bufferProgressView.isUserInteractionEnabled = false
        addSubview(bufferProgressView)

        playProgressView = UIView(frame: .zero)
        playProgressView.isUserInteractionEnabled = false
        addSubview(playProgressView)

    }

    func layoutContainer() {
        self.wholeProgressView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.centerY.equalToSuperview().offset(0)
            make.height.equalTo(3.0)
        }
        self.playProgressView.snp.remakeConstraints { (make) in
            make.left.equalTo(wholeProgressView.snp.left).offset(0)
            make.top.equalTo(wholeProgressView.snp.top).offset(0)
            make.bottom.equalTo(wholeProgressView.snp.bottom).offset(0)
            make.width.equalTo(wholeProgressView.snp.width)
                .multipliedBy(self.playProgress)
                .priority(.high)
        }
        self.bufferProgressView.snp.remakeConstraints { (make) in
            make.left.equalTo(wholeProgressView.snp.left).offset(0)
            make.top.equalTo(wholeProgressView.snp.top).offset(0)
            make.bottom.equalTo(wholeProgressView.snp.bottom).offset(0)
            make.width.equalTo(wholeProgressView.snp.width)
                .multipliedBy(self.bufferProgress)
                .priority(.high)
        }
    }
    func updateBufferProgress() {
        self.bufferProgressView.snp.remakeConstraints { (make) in
            make.left.equalTo(wholeProgressView.snp.left).offset(0)
            make.top.equalTo(wholeProgressView.snp.top).offset(0)
            make.bottom.equalTo(wholeProgressView.snp.bottom).offset(0)
            make.width.equalTo(wholeProgressView.snp.width)
                .multipliedBy(self.bufferProgress)
                .priority(.high)
        }
    }
    func updatePlayProgress() {
        self.playProgressView.snp.remakeConstraints { (make) in
            make.left.equalTo(wholeProgressView.snp.left).offset(0)
            make.top.equalTo(wholeProgressView.snp.top).offset(0)
            make.bottom.equalTo(wholeProgressView.snp.bottom).offset(0)
            make.width.equalTo(wholeProgressView.snp.width)
                .multipliedBy(self.playProgress)
                .priority(.high)
        }
    }
}
