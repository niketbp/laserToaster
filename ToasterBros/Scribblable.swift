//
//  Scribblable.swift
//  ToasterBros
//
//  Created by Niket Parikh on 10/25/16.
//  Copyright © 2016 Niket Parikh. All rights reserved.
//

import Foundation
import UIKit

// MARK: Scribblable protocol

protocol Scribblable {
    func beginScribble(_ point: CGPoint)
    func appendScribble(_ point: CGPoint)
    func endScribble()
    func clearScribble()
}

// MARK: ScribbleView base class

class ScribbleView: UIView {
    let backgroundLayer = CAShapeLayer()
    let drawingLayer = CAShapeLayer()
    
    let titleLabel = UILabel()
    
    required init(title: String) {
        super.init(frame: CGRect.zero)
        
        backgroundLayer.strokeColor = UIColor.darkGray.cgColor
        backgroundLayer.fillColor = nil
        backgroundLayer.lineWidth = 10
        
        drawingLayer.strokeColor = UIColor.black.cgColor
        drawingLayer.fillColor = nil
        drawingLayer.lineWidth = 10
        
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(drawingLayer)
        
        titleLabel.text = title
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.textColor = UIColor.blue
        addSubview(titleLabel)
        
        layer.borderColor = UIColor.blue.cgColor
        layer.borderWidth = 1
        
        layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        titleLabel.frame = CGRect(x: 0,
                                  y: frame.height - titleLabel.intrinsicContentSize.height - 2,
                                  width: frame.width,
                                  height: titleLabel.intrinsicContentSize.height)
    }
}

// MARK: Simple line drawing from point to point

class SimpleScribbleView: ScribbleView, Scribblable {
    let path = UIBezierPath()
    var interpolationPoints = [CGPoint]()
    
    func beginScribble(_ point: CGPoint) {
        interpolationPoints = [point]
    }
    
    func appendScribble(_ point: CGPoint) {
        interpolationPoints.append(point)
        
        path.removeAllPoints()
        path.interpolatePointsWithHermite(interpolationPoints: interpolationPoints)
        
        drawingLayer.path = path.cgPath
    }
    
    func endScribble() {
        if let backgroundPath = backgroundLayer.path {
            path.append(UIBezierPath(cgPath: backgroundPath))
        }
        
        backgroundLayer.path = path.cgPath
        
        path.removeAllPoints()
        
        drawingLayer.path = path.cgPath
    }
    
    func clearScribble() {
        backgroundLayer.path = nil
    }
    
    func saveScribble() {
        let pixelWidthCount = 150
        let pixelHeightCount = 150
        
        let pixelWidth = CGFloat(pixelWidthCount)
        let pixelHeight = CGFloat(pixelHeightCount)
        
        let frameWidth = layer.frame.width
        let frameHeight = layer.frame.height
        
        let widthIncrement = frameWidth/(pixelWidth - 1)
        let heightIncrement = frameHeight/(pixelHeight - 1)
        
        var m = 0
        var n = 0
        var i : CGFloat = 0
        var j : CGFloat = 0
        
        var image = [[Int]](repeating: [Int](repeating: 0, count: pixelHeightCount), count: pixelWidthCount)
        
        while (i < frameWidth){
            while (j < frameHeight){
                if (backgroundLayer.path!.contains(CGPoint(x: Int(i), y: Int(j)))){
                    image[m][n] = 1
                }
                print(image[m][n], terminator: "")
                n += 1
                j += heightIncrement
            }
            print("")
            m += 1
            n = 0
            i += widthIncrement
            j = 0
        }
        
        /*
        print(widthIncrement)
        print(heightIncrement)
        
        var image = [[Bool]](repeating: [Bool](repeating: false, count: pixelHeight), count: pixelWidth)
        image[99][99] = false
        for i in stride(from: 0, to: frameWidth-1, by: widthIncrement){
            for j in stride(from: 0, to: frameHeight-1, by: heightIncrement){
                image[m][n] = backgroundLayer.path!.contains(CGPoint(x: i, y: j))
                n += 1
                print(image[m][n-1])
            }
            m += 1
            n = 0
        }
        */
    }
    
}
