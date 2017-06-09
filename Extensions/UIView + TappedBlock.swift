//
//  UIView + TappedBlock.swift
//  SwifterSwift
//
//  Created by 张阳浩 on 2017/6/9.
//  Copyright © 2017年 omaralbeik. All rights reserved.
//

import Foundation
import UIKit
let SingKey         = "CCSingleTapBlockKey"
let DoubleKey       = "CCDoubleTapBlockKey"
let DoubleFingerKey = "CCDoubleFingerTapBlockKey"
let TouchDowKey     = "CCTouchDownTapBlockKey"
let TouchUpKey      = "CCTouchUpTapBlcokKey"
let LongPressKey    = "CCLongPressBlockKey"

typealias tapBlock = (_ View:UIView)->()
 extension UIView{

    func makeBlockForKey(_ key:String) {
        let Key : UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: key.hashValue)
        let blocks  = objc_getAssociatedObject(self, Key) as? tapBlock
        if (blocks != nil) {
            blocks!(self)
        }
    }
   func setBlockForKey(_ key:String,_ block:tapBlock) {
        self.isUserInteractionEnabled = true
        let Key : UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: key.hashValue)
        objc_setAssociatedObject(self, Key, block, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    // TODO: - 解决手势冲突

    private func requireSingleTapsRecognizer(_ recognizer:UIGestureRecognizer,target:UIView){
        for gesture in target.gestureRecognizers! {
            if gesture .isKind(of: UITapGestureRecognizer.classForCoder()) {
                let tap = gesture as!UITapGestureRecognizer
                if tap.numberOfTouchesRequired == 1 && tap.numberOfTapsRequired == 1 {
                    tap.require(toFail: recognizer)
                }
            }
        }

    }

    private func requireDoubleTapsRecognizer(_ recognizer:UIGestureRecognizer,target:UIView){
        for gesture in target.gestureRecognizers! {
            if gesture .isKind(of: UITapGestureRecognizer.classForCoder()) {
                let tap = gesture as! UITapGestureRecognizer
                if tap.numberOfTapsRequired == 2&&tap.numberOfTouchesRequired == 1 {
                    tap.require(toFail: recognizer)
                }
                
            }
        }
    }
    
    
    private func requireLongPressTecognizer(_ recognizer:UIGestureRecognizer,target:UIView){
        for gesture in target.gestureRecognizers! {
            if gesture .isKind(of: UILongPressGestureRecognizer.classForCoder()) {
                let longPress = gesture as! UILongPressGestureRecognizer
                longPress.require(toFail: recognizer)
                
            }
        }
        
    }
    
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.makeBlockForKey(TouchDowKey)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.makeBlockForKey(TouchUpKey)
    }
    
    // TODO: - CallBacks
    func singleTap() {
        self.makeBlockForKey(SingKey)
    }

    func doubleTap() {
        self.makeBlockForKey(DoubleKey)
    }
    
    func doubleFingerTap() {
        self.makeBlockForKey(DoubleFingerKey)
    }
    func longPress(_ sender:UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            self.makeBlockForKey(LongPressKey)
        }
    }
    
    func whenTapped(_ block:tapBlock) {
        let tap = self.addTapRecognizerWithTaps(1, touchs: 1, #selector(singleTap))
        self.requireDoubleTapsRecognizer(tap, target: self)
        requireLongPressTecognizer(tap, target: self)
        self.setBlockForKey(SingKey, block)
    }
    func whenDoubleFingerTapped(_ block:tapBlock) {
        _=self.addTapRecognizerWithTaps(1, touchs: 2, #selector(doubleTap))
        self.setBlockForKey(DoubleKey, block)
    }
    func whenTouchDown(_ block:tapBlock) {
        self.setBlockForKey(TouchDowKey, block)
    }
    func whenTouchUp(_ block:tapBlock) {
        self.setBlockForKey(TouchUpKey, block)
    }
    // TODO: - add gesture
    
    func addTapRecognizerWithTaps(_ taps:Int,touchs:Int,_ sel:Selector) -> UITapGestureRecognizer {
        let tapGr = UITapGestureRecognizer.init(target: self, action: sel)
        tapGr.delegate = self as? UIGestureRecognizerDelegate
        tapGr.numberOfTapsRequired = taps
        tapGr.numberOfTouchesRequired = touchs
        self.addGestureRecognizer(tapGr)
        return tapGr
    }

    func addLongPressRecognizerWithTouches(_ touchs:Int,_ sel:Selector) -> UILongPressGestureRecognizer {
        let longPress = UILongPressGestureRecognizer.init(target: self, action: sel)
        longPress.numberOfTouchesRequired = touchs
        longPress.delegate = self as? UIGestureRecognizerDelegate
        self.addGestureRecognizer(longPress)
        return longPress
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
