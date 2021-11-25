//
//  ChartMarkerView.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics

#if canImport(AppKit)
import AppKit
#endif

@objc(ChartMarkerView)
open class MarkerView: NSUIView, IMarker
{
    public var isPiePopup: Bool = false
    public var hasTail: Bool = false
    public var height: CGFloat {
        bounds.height
    }
    
    open var offset: CGPoint = CGPoint()
    
    @objc open weak var chartView: ChartViewBase?
    
    open func offsetForDrawing(atPoint point: CGPoint) -> CGPoint
    {
        guard let chart = chartView else { return self.offset }
                
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        let chartHeight = chart.bounds.height
        let chartWidth = chart.bounds.width

        var offset: CGPoint!
        if isPiePopup {
            if hasTail {
                offset = CGPoint(x: -width / 2, y: 0)
            } else {
                offset = CGPoint(x: -width / 2, y: 16 - point.y)
            }
        } else {
            offset = CGPoint(x: -width / 2, y: 16 - point.y)
        }
        
        if point.x + offset.x < 16 {
            offset.x = -point.x + 16
        } else if chartWidth - point.x < -offset.x + 16 {
            offset.x = -(width - (chartWidth - point.x)) - 16
        }
        
        return offset
    }
    
    open func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        // Do nothing here...
    }
    
    open func draw(context: CGContext, point: CGPoint)
    {
        let offset = self.offsetForDrawing(atPoint: point)
        
        context.saveGState()
        context.translateBy(x: point.x + offset.x,
                              y: point.y + offset.y)
        NSUIGraphicsPushContext(context)
        self.nsuiLayer?.render(in: context)
        NSUIGraphicsPopContext()
        context.restoreGState()
    }
    
    @objc
    open class func viewFromXib(in bundle: Bundle = .main) -> MarkerView?
    {
        #if !os(OSX)
        
        return bundle.loadNibNamed(
            String(describing: self),
            owner: nil,
            options: nil)?[0] as? MarkerView
        #else
        
        var loadedObjects = NSArray()
        let loadedObjectsPointer = AutoreleasingUnsafeMutablePointer<NSArray?>(&loadedObjects)
        
        if bundle.loadNibNamed(
            NSNib.Name(String(describing: self)),
            owner: nil,
            topLevelObjects: loadedObjectsPointer)
        {
            return loadedObjects[0] as? MarkerView
        }
        
        return nil
        #endif
    }
    
}
