//
//  DrawView.swift
//  TouchTracker
//
//  Created by Sangho Oh on 26/03/2019.
//  Copyright © 2019 Sangho Oh. All rights reserved.
//

import UIKit

class DrawView: UIView {
    var currentLines = [NSValue:Line]()
    var finishedLines = [Line]()
    var moveRecognizer: UIPanGestureRecognizer!
    var selectedLineIndex: Int? {
        didSet {
            // selected == nil일 때, menu 없애기...
            if selectedLineIndex == nil {
                let menu = UIMenuController.shared
                menu.setMenuVisible(false, animated: true)
            }
        }
    }
    
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    // @IBInspectable 키워드? 속성 인스펙터를 통해 설정하길 원하는 프로퍼티...
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // 메뉴 아이템 first responder에 대한 true..
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        // 더블탭 삭제 시, 한번 탭으로 생기는 빨간 점. 더블 탭 중 began 메소드 딜레이 시키기..
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        tapRecognizer.delaysTouchesBegan = true
        // tab 인식 메소드를 가로채서 실패로 만들고, 더블탭 인식 메소드 실행.
        tapRecognizer.require(toFail: doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)
        
        // longPress...
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        addGestureRecognizer(longPressRecognizer)
        
        moveRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveLine(_:)))
        // true일 경우, touch는 무시함..pan(moveRecognizer)만 수행함...
        moveRecognizer.cancelsTouchesInView = false
        moveRecognizer.delegate = self
        addGestureRecognizer(moveRecognizer)
    }
    
    @objc func moveLine(_ gestureRecognizer: UIPanGestureRecognizer) {
        print("Recognized a pan")
        
        // 선 선택되면..
        if let index = selectedLineIndex {
            
            // 팬 인식기 위치가 변하면...
            if gestureRecognizer.state == .changed {
                // 변화된 위치 받아오기
                let translation = gestureRecognizer.translation(in: self)
                
                // 위치 세팅
                finishedLines[index].begin.x += translation.x
                finishedLines[index].begin.y += translation.y
                finishedLines[index].end.x += translation.x
                finishedLines[index].end.y += translation.y
                
                // 이동 할때마다 위치가 반복적으로 더해져서, 이동할수록 더 많이 멀어지는 현상 발생...
                // 이동 후의 위치를 제로 포인트로 재설정.
                gestureRecognizer.setTranslation(CGPoint.zero, in: self)
                
                setNeedsDisplay()
            }
        } else {
            return
        }
    }
    
    @objc func tap(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a tap")
        
        let point = gestureRecognizer.location(in: self)
        selectedLineIndex = indexOfLineAtPoint(point: point)
        
        // 메뉴 컨트롤러...
        let menu = UIMenuController.shared
        
        if selectedLineIndex != nil {
            // DrawView를 메뉴 아이템 액션 메시지의 타깃으로..
            becomeFirstResponder()
            
            // delete item 생성..
            let deleteItem = UIMenuItem(title: "Delete", action: #selector(deleteLine(_:)))
            menu.menuItems = [deleteItem]
            
            // 메뉴가 나타날 영역을 정하고, 그 위치에 보이게 설정..
            menu.setTargetRect(CGRect(x: point.x, y: point.y, width: 2, height: 2), in: self)
            menu.setMenuVisible(true, animated: true)
        } else {
            // 선택된 선이 없으면 메뉴 히든...
            menu.setMenuVisible(false, animated: true)
        }
        
        setNeedsDisplay()
    }
    
    @objc func longPress(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a long press")
        
        if gestureRecognizer.state == .began {
            let point = gestureRecognizer.location(in: self)
            selectedLineIndex = indexOfLineAtPoint(point: point)
            
            if selectedLineIndex != nil {
                currentLines.removeAll(keepingCapacity: false)
            }
        } else if gestureRecognizer.state == .ended {
            selectedLineIndex = nil
        }
        setNeedsDisplay()
    }
    
    @objc func deleteLine(_ sender: AnyObject) {
        // finishedLines 에서 선택한 선 제거..
        if let index = selectedLineIndex {
            finishedLines.remove(at: index)
            selectedLineIndex = nil
            
            setNeedsDisplay()
        }
    }
    
    @objc func doubleTap(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a double tap")
        
        selectedLineIndex = nil
        currentLines.removeAll(keepingCapacity: false)
        finishedLines.removeAll(keepingCapacity: false)
        setNeedsDisplay()
    }
    
    func strokeLine(line: Line) {
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = CGLineCap.round
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
        
    }
    
    override func draw(_ rect: CGRect) {
        // 완성된 선은 검은 색...
        finishedLineColor.setStroke()
        for line in finishedLines {
            strokeLine(line: line)
        }
        
        // 그리는 중인 선은 빨간 색...
        currentLineColor.setStroke()
        for (_, line) in currentLines {
            strokeLine(line: line)
        }
        
        if let index = selectedLineIndex {
            UIColor.green.setStroke()
            let selectedLine = finishedLines[index]
            strokeLine(line: selectedLine)
        }
    }
    
    func indexOfLineAtPoint(point: CGPoint) -> Int? {
        // point와 가장 가까운 선을 찾음...
        for (index, line) in finishedLines.enumerated() {
            let begin = line.begin
            let end = line.end
            
            // 선 위의 포인트를 확인
            for t in stride(from: CGFloat(0), to: 1.0, by: 0.05) {
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                
                // 탭한 지점이 선과 20 포인트 이내라면 해당 index의 선을 return..
                if hypot(x - point.x, y - point.y) < 20.0 {
                    return index
                }
            }
        }
        // 탭한 지점과 가까운 선(20포인트)이 없으면 선을 선택하지 않음...
        return nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        for touch in touches {
            let location = touch.location(in: self)
            
            let newLine = Line(begin: location, end: location)
            
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.location(in: self)
        }
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.location(in: self)
                
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        currentLines.removeAll()
        setNeedsDisplay()
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension DrawView: UIGestureRecognizerDelegate {
    // 동시에 다른 제스쳐를 인식하기 위한 메소드...
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
