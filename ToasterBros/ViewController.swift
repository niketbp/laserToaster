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

    @IBOutlet weak var label1: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var uiimage = UIImage(contentsOfFile: "harbaugh.jpg")
        var image = uiimage?.cgImage
        
        
        let width = image!.width
        let height = image!.height
        let colorspace = CGColorSpaceCreateDeviceRGB()
        let bytesPerRow = (4 * width);
        let bitsPerComponent :UInt = 8
        let pixels = UnsafeRawPointer(malloc(width*height*4))
        
        
       // var context = CGBitmapContextCreate(pixels, width, height, bitsPerComponent, bytesPerRow, colorspace,
        //                                    CGBitmapInfo());
        
       // CGContextDrawImage(context, CGRectMake(0, 0, CGFloat(width), CGFloat(height)), image)
        
        
        for x in 0..<width {
            for y in 0..<height {
                //Here is your raw pixels
                let offset = 4*((Int(width) * Int(y)) + Int(x))
                print(offset)
                let alpha = pixels?.load(fromByteOffset: offset, as: UInt8.self)
                print(alpha)
                let red = pixels?.load(fromByteOffset: offset+1, as: UInt8.self)
                print(red)
                let green = pixels?.load(fromByteOffset: offset+2, as: UInt8.self)
                print(green)
                let blue = pixels?.load(fromByteOffset: offset+3, as: UInt8.self)
                print(blue)
            }
        }
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   

}

