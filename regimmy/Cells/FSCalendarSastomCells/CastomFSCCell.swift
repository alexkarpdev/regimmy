//
//  CastomFSCCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 26.08.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class CastomFSCCell: FSCalendarCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clearSubviews() {
        for v in self.contentView.subviews {
            if v.tag == 999 {
                v.removeFromSuperview()
            }
        }
    }
    
    func configure(eventsType: [EventType]) {
        
        clearSubviews()
        
        guard eventsType.count > 0 else {
            return
        }
        
        var existedTypes = [EventType]()
        
        for type in eventsType {
            if !existedTypes.contains(type) {
                existedTypes.append(type)
            }
        }
        
        existedTypes.sort(){$0.order < $1.order}
        
        let size: CGFloat = 8.0
        let width = self.frame.width
        let count = existedTypes.count
        let delta = (self.frame.width - (4.0 * size )) / 7.0
        let dy = self.frame.height - size - delta * 2
        
        let lenght = CGFloat(count) * size + delta * (CGFloat(count) - 1.0)
        
        let startX = width / 2.0 - (lenght) / 2.0
        
        
        for i in 0 ..< count {
            let rect = CGRect(x: startX + CGFloat(i) * (delta + size), y: dy, width: size, height: size)
            let indicatorView = UIView(frame: rect)
            indicatorView.tag = 999
            indicatorView.backgroundColor = existedTypes[i].sectionColor.withAlphaComponent(0.6)
            indicatorView.layer.cornerRadius = size / 2
            indicatorView.clipsToBounds = true
            self.contentView.addSubview(indicatorView)
        }
    }
    
    
}
