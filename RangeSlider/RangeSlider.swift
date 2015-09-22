//
//  RangeSlider.swift
//  RangeSlider
//
//  Created by George Danikas on 9/21/15.
//  Copyright © 2015 Intelen Inc. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol RangeSliderDelegate {
    func didUpperValueChanged(value: CGFloat)
    func didLowerValueChanged(value: CGFloat)
}

@IBDesignable
class RangeSlider: UIControl {
    
    var delegate: RangeSliderDelegate?
    
    @IBInspectable var minValue: CGFloat = 0
    @IBInspectable var maxValue: CGFloat = 100 {
        didSet {
            barLength = bounds.height - (barMargin * 2)
        }
    }
    @IBInspectable var upperValue: CGFloat = 70 {
        didSet {
            if upperValue < minValue {
                upperValue = minValue
            }
            if upperValue > maxValue {
                upperValue = maxValue
            }
            
            setupView()
        }
    }
    
    @IBInspectable var lowerValue: CGFloat = 25 {
        didSet {
            if lowerValue < minValue {
                lowerValue = minValue
            }
            if lowerValue > maxValue {
                lowerValue = maxValue
            }
            if lowerValue > upperValue {
                lowerValue = upperValue - 5.0
            }
            
            setupView()
        }
    }
    
    let knobSize = CGSize(width: 31, height: 22)
    let barMargin:CGFloat = 18.0
    var knobRect: CGRect!
    var knobRect2: CGRect!
    var barUpperShape:CAShapeLayer!
    var barUpperGradient:CAGradientLayer!
    var barLowerShape:CAShapeLayer!
    var barLowerGradient:CAGradientLayer!
    var knobShape:CAShapeLayer!
    var knobShape2:CAShapeLayer!
    
    var barLength: CGFloat!
    let barWidth:CGFloat = 12.0
    var isUpperKnobSliding = false
    var isLowerKnobSliding = false
}

extension RangeSlider {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        knobRect = CGRect(x: 0, y: convertValueToY(upperValue) - (knobSize.height / 2), width: knobSize.width, height: knobSize.height)
        knobRect2 = CGRect(x: 0, y: convertValueToY(lowerValue) - (knobSize.height / 2), width: knobSize.width, height: knobSize.height)
        
        barLength = bounds.height - (barMargin * 2)
    }
    
    func drawVerticalSlider(controlFrame: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        // Color Declarations
        let onColor = UIColor(red:91.0/255.0, green:143.0/255.0, blue:37.0/255.0, alpha:1.000)
        let upperColor = UIColor(red:235.0/255.0, green:78.0/255.0, blue:26.0/255.0, alpha:1.000)
        let lowerColor = UIColor(red:23.0/255.0, green:121.0/255.0, blue:194.0/255.0, alpha:1.000)
        //let offColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.000)
        
        let handleColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        let strokeColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.000)
        
        // Shadow Declarations
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.blackColor()
        shadow.shadowOffset = CGSizeMake(0.1, 3.1)
        shadow.shadowBlurRadius = 5
        
        // Frames
        let knobFrame = CGRectMake(knobRect.origin.x, knobRect.origin.y, knobRect.size.width, knobRect.size.height)
        let knobFrame2 = CGRectMake(knobRect2.origin.x, knobRect2.origin.y, knobRect2.size.width, knobRect2.size.height)
        
        // Bar Off Drawing
        /*
        var barOffPath = UIBezierPath()
        barOffPath.moveToPoint(CGPointMake(controlFrame.minX + 19, controlFrame.minY + 15))
        barOffPath.addLineToPoint(CGPointMake(controlFrame.minX + 18.5, controlFrame.maxY - 16))
        barOffPath.lineCapStyle = kCGLineCapRound;
        
        offColor.setStroke()
        barOffPath.lineWidth = barWidth
        barOffPath.stroke()
        */
        
        // Bar Normal Drawing
        let barOnPath = UIBezierPath()
        barOnPath.moveToPoint(CGPointMake(knobFrame.minX + 0.51389 * knobFrame.width, knobFrame.minY + 13.5))
        barOnPath.addLineToPoint(CGPointMake(knobFrame.minX + 0.51389 * knobFrame.width, knobFrame2.minY + 13.5))
        
        //barOnPath.lineCapStyle = kCGLineCapRound;
        onColor.setStroke()
        barOnPath.lineWidth = barWidth
        barOnPath.stroke()
        
        // ------------------
        // Bar Upper Gradient
        let barUpperLoc: [CGFloat] = [0.0, 1.0]
        let barUpperColors = [UIColor.whiteColor().CGColor, upperColor.CGColor]
        let barUpperGradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), barUpperColors, barUpperLoc)
        
        // Bar Upper Drawing
        let barUpperPath = UIBezierPath()
        barUpperPath.moveToPoint(CGPointMake(knobFrame.minX + 0.51389 * knobFrame.width, knobFrame.minY + 13.5))
        barUpperPath.addLineToPoint(CGPointMake(knobFrame.minX + 0.51389 * knobFrame.width, controlFrame.minY + 15))
        barUpperPath.lineCapStyle = .Round;
        
        UIColor.whiteColor().setStroke()
        barUpperPath.lineWidth = barWidth
        barUpperPath.stroke()
        
        // Apply Bar Upper Gradient
        CGContextSaveGState(context)
        
        CGContextAddPath(context, barUpperPath.CGPath)
        CGContextSetLineWidth(context, barWidth);
        CGContextSetLineCap(context, .Round);
        CGContextReplacePathWithStrokedPath(context)
        CGContextClip(context)
        
        let barUpperBounds = CGPathGetPathBoundingBox(barUpperPath.CGPath)
        CGContextDrawLinearGradient(context, barUpperGradient, CGPointMake(CGRectGetMidX(barUpperBounds), CGRectGetMinY(barUpperBounds)), CGPointMake(CGRectGetMidX(barUpperBounds), CGRectGetMaxY(barUpperBounds)), [.DrawsAfterEndLocation, .DrawsBeforeStartLocation])
        
        CGContextRestoreGState(context)
        // ------------------
        
        // ------------------
        // Bar Lower Gradient
        let barLowerLoc: [CGFloat] = [0.0, 1.0]
        let barLowerColors = [lowerColor.CGColor, UIColor.whiteColor().CGColor]
        let barLowerGradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), barLowerColors, barLowerLoc)
        
        // Bar Lower Drawing
        let barLowerPath = UIBezierPath()
        barLowerPath.moveToPoint(CGPointMake(knobFrame2.minX + 0.51389 * knobFrame2.width, knobFrame2.minY + 13.5))
        barLowerPath.addLineToPoint(CGPointMake(knobFrame2.minX + 0.51389 * knobFrame2.width, controlFrame.maxY - 16))
        barLowerPath.lineCapStyle = .Round;
        
        lowerColor.setStroke()
        barLowerPath.lineWidth = barWidth
        barLowerPath.stroke()
        
        // Apply Bar Lower Gradient
        CGContextSaveGState(context)
        
        CGContextAddPath(context, barLowerPath.CGPath)
        CGContextSetLineWidth(context, barWidth);
        CGContextSetLineCap(context, .Round);
        CGContextReplacePathWithStrokedPath(context)
        CGContextClip(context)
        
        let barLowerBounds = CGPathGetPathBoundingBox(barLowerPath.CGPath)
        CGContextDrawLinearGradient(context, barLowerGradient, CGPointMake(CGRectGetMidX(barLowerBounds), CGRectGetMinY(barLowerBounds)), CGPointMake(CGRectGetMidX(barLowerBounds), CGRectGetMaxY(barLowerBounds)), [.DrawsAfterEndLocation, .DrawsBeforeStartLocation])
        
        CGContextRestoreGState(context)
        // ------------------
        
        
        // Knob Oval Drawing
        let knobOvalPath = UIBezierPath(ovalInRect: CGRectMake(knobFrame.minX + floor((knobFrame.width - 25) * 0.5 + 0.5), knobFrame.minY + floor((knobFrame.height - 25) * 0.3 + 0.5), 25, 25))
        
        CGContextSaveGState(context)
        CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, (shadow.shadowColor as! UIColor).CGColor)
        handleColor.setFill()
        knobOvalPath.fill()
        CGContextRestoreGState(context)
        
        strokeColor.setStroke()
        knobOvalPath.lineWidth = 2
        knobOvalPath.stroke()
        
        // Knob Oval Drawing 2
        let knobOvalPath2 = UIBezierPath(ovalInRect: CGRectMake(knobFrame2.minX + floor((knobFrame2.width - 25) * 0.5 + 0.5), knobFrame2.minY + floor((knobFrame2.height - 25) * 0.3 + 0.5), 25, 25))
        CGContextSaveGState(context)
        CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, (shadow.shadowColor as! UIColor).CGColor)
        handleColor.setFill()
        knobOvalPath2.fill()
        CGContextRestoreGState(context)
        
        strokeColor.setStroke()
        knobOvalPath2.lineWidth = 2
        knobOvalPath2.stroke()
    }
    
    override func drawRect(rect: CGRect) {
        drawVerticalSlider(CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
}

// MARK: - Helpers
extension RangeSlider {
    func convertYToValue(y: CGFloat) -> CGFloat {
        let offsetY = bounds.height - barMargin - y
        let value = round((offsetY * (maxValue - minValue)) / barLength) + minValue
        return value
    }
    func convertValueToY(value: CGFloat) -> CGFloat {
        let rawY = ((value - minValue) * barLength) / (maxValue - minValue)
        let offsetY = bounds.height - barMargin - rawY
        return offsetY
    }
}

// MARK: - Control Touch Handling
extension RangeSlider {
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        if CGRectContainsPoint(knobRect, touch.locationInView(self)) {
            isUpperKnobSliding = true
        }
        
        if CGRectContainsPoint(knobRect2, touch.locationInView(self)) {
            isLowerKnobSliding = true
        }
        
        return true
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let rawY = touch.locationInView(self).y
        
        if isUpperKnobSliding {
            let value = convertYToValue(rawY)
            if round(rawY) < round(knobRect2.minY - 13.5) && (value != minValue || value != maxValue) {
                upperValue = value
                delegate?.didUpperValueChanged(upperValue)
                
                //println(upperValue)
                setNeedsDisplay()
            }
        }
        
        if isLowerKnobSliding {
            let value = convertYToValue(rawY)
            if round(rawY) > round(knobRect.maxY + 13.5) && (value != minValue || value != maxValue || value != upperValue) {
                lowerValue = value
                delegate?.didLowerValueChanged(lowerValue)
                
                //println(lowerValue)
                setNeedsDisplay()
            }
        }
        
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        isUpperKnobSliding = false
        isLowerKnobSliding = false
    }
}
