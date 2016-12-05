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
        
        backgroundLayer.strokeColor = UIColor.yellow.cgColor
        backgroundLayer.fillColor = nil
        backgroundLayer.lineWidth = 20
        
        drawingLayer.strokeColor = UIColor.gray.cgColor
        drawingLayer.fillColor = nil
        drawingLayer.lineWidth = 20
        
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(drawingLayer)
        
        titleLabel.text = title
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.textColor = UIColor.blue
        addSubview(titleLabel)
        
        layer.borderColor = UIColor.white.cgColor
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
        /*let pixelWidthCount = 100
        let pixelHeightCount = 100
        
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
        
        while (i < frameHeight){
            while (j < frameWidth){
                if (backgroundLayer.path!.contains(CGPoint(x: Int(j), y: Int(i)))){
                    image[m][n] = 1
                }
                //print(image[m][n], terminator: "")
                n += 1
                j += widthIncrement
            }
            //print("")
            m += 1
            n = 0
            i += heightIncrement
            j = 0
        }*/
        
        
        let pixelWidth = Int(layer.frame.width)
        let pixelHeight = Int(layer.frame.height)
        
        let imageWidth = 360
        let imageHeight = 360
        
        var image = [[Int]](repeating: [Int](repeating: 0, count: imageHeight), count: imageWidth)
        var startingI: Int = Int(imageWidth-pixelWidth)/2
        var startingJ: Int = (imageHeight-pixelHeight)/2
        
        for i in 0..<pixelHeight{
            for j in 0..<pixelWidth{
                if (backgroundLayer.path!.contains(CGPoint(x: j, y: i))){
                    image[startingJ][startingI] = 1
                }
                startingJ += 1
            }
            startingI += 1
            startingJ = 0
        }
        
        
        for x in 0..<imageHeight{
            for y in 0..<imageWidth{
                print(image[y][x], terminator: "")
            }
            print("")
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
