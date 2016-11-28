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
    
    let stackView = UIStackView()
    
    let simpleScribbleView = SimpleScribbleView(title: "")
    
    var touchOrigin: ScribbleView?
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func sendButton(_ sender: AnyObject) {
        simpleScribbleView.saveScribble()
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        
        simpleScribbleView.clearScribble()
        
    }
    @IBAction func startButton(_ sender: AnyObject) {
        
        clearButton.isHidden = false
        sendButton.isHidden = false
        startButton.isHidden = true
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(simpleScribbleView)
        
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
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

