//
//  UIButton+Blocks.swift
//  testuiviewTap
//
//  Created by 张阳浩 on 2017/6/9.
//  Copyright © 2017年 张阳浩. All rights reserved.
//

import Foundation
import UIKit
typealias ActionBlock = (_ button:UIButton)->()
extension UIButton{
    func handleTouchUpInsideEventWithBlock(_ buttonClickEvent:ActionBlock) {
        self.handleEvent(.touchUpInside, withBlock: buttonClickEvent)
    }
    
   private func handleEvent(_ aEvent:UIControlEvents,withBlock:ActionBlock) {
        let Key : UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "BUTTONKEY".hashValue)
        objc_setAssociatedObject(self, Key, withBlock, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        self.addTarget(self, action: #selector(clik), for: .touchUpInside)
    }

  @objc private  func clik()  {
        let Key : UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "BUTTONKEY".hashValue)
        let block = objc_getAssociatedObject(self, Key) as?ActionBlock
        if block != nil {
            block!(self)
        }
   
    }
    
    
}
