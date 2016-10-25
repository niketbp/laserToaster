//
//  ViewController.swift
//  ToasterBros
//
//  Created by Niket Parikh on 9/25/16.
//  Copyright © 2016 Niket Parikh. All rights reserved.
//

import UIKit
import CoreGraphics

class ViewController: UIViewController {

    /*@IBOutlet weak var label1: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let image = UIImage(named: "harbaugh.png")
        let data = UIImageJPEGRepresentation(image!, 1.0);
        let array = getArrayOfBytesFromImage(imageData: data!)
        
        let imageWidth = (image?.size.width)! * (image?.scale)!
        let imageHeight = (image?.size.height)! * (image?.scale)!

        let w:Int = Int(imageWidth)
        let h:Int = Int(imageHeight)
        
        var twoDeeArray = Array(repeating: Array(repeating: 0, count: w), count: h)

        
        for i in 0..<h{
            for j in 0..<w{
                twoDeeArray[i][j] = array[j + i*w] as! Int
            }
        }
        
        for i in 0..<h{
            for j in 0..<w{
                print(twoDeeArray[i][j], terminator: "")
                print(", ", terminator: "")
            }
            print()
            print()
        }
        
        //do some shit with twoDeeArray
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getArrayOfBytesFromImage(imageData:Data) -> NSMutableArray
    {
        
        // the number of elements:
        let count = imageData.count / MemoryLayout<UInt8>.size
        
        // create array of appropriate length:
        var bytes = [UInt8](repeating: 0, count: count)
        
        // copy bytes into array
        imageData.copyBytes(to: &bytes, count:count * MemoryLayout<UInt8>.size)
        
        let byteArray:NSMutableArray = NSMutableArray()
        
        for i in 0..<count {
            byteArray.add(NSNumber(value: bytes[i]))
        }
        
        return byteArray
        
        
    }*/
    
    
    
    let stackView = UIStackView()
    
    let simpleScribbleView = SimpleScribbleView(title: "")
    
    
    var touchOrigin: ScribbleView?
    
    @IBAction func clearButton(_ sender: UIButton) {
        
        simpleScribbleView.clearScribble()
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(simpleScribbleView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let
            location = touches.first?.location(in: self.view) else
        {
            return
        }
        
        if (simpleScribbleView.frame.contains(location))
        {
            touchOrigin = simpleScribbleView
        }
        else
        {
            touchOrigin = nil
            return
        }
        
        if let adjustedLocationInView = touches.first?.location(in: touchOrigin)
        {
            simpleScribbleView.beginScribble(adjustedLocationInView)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let
            touch = touches.first,
            let coalescedTouches = event?.coalescedTouches(for: touch),
            let touchOrigin = touchOrigin
            else
        {
            return
        }
        
        coalescedTouches.forEach
            {
                simpleScribbleView.appendScribble($0.location(in: touchOrigin))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        simpleScribbleView.endScribble()
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?)
    {
        if motion == UIEventSubtype.motionShake
        {
            simpleScribbleView.clearScribble()
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        stackView.frame = CGRect(x: 0,
                                 y: topLayoutGuide.length,
                                 width: view.frame.width,
                                 height: view.frame.height/2).insetBy(dx: 10, dy: 10)
        
        stackView.axis = view.frame.width > view.frame.height
            ? UILayoutConstraintAxis.horizontal
            : UILayoutConstraintAxis.vertical
        
        stackView.spacing = 40
        
        stackView.distribution = UIStackViewDistribution.fillEqually
    }

}

