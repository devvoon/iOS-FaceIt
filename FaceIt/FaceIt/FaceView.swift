//
//  FaceView.swift
//  FaceIt
//
//  Created by DAMA on 2017. 8. 30..
//  Copyright © 2017년 iamdawoonjeong. All rights reserved.
//

import UIKit

class FaceView: UIView
{
    
    var scale : CGFloat = 0.90
    
    var mouthCurvature : Double = 1.0 // 1 full smile -1 full frown
    
    private var skullRadius : CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2
    }

    private var skullCenter : CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }

    
    private struct Ratios{
        static let SkullRadiusToEyeOffset   : CGFloat = 3
        static let SkullRadiusToEyeRadios   : CGFloat = 10
        static let SkullRadiusToMouthWidth  : CGFloat = 1
        static let SkullRadiusToMouthHeight : CGFloat = 3
        static let SkullRadiusToMouthOffset : CGFloat = 3
        
    }
    
    private enum Eye{
        case Left
        case Right
        
    }
    
    private func pathForCircleCenterdAtPoint(midPoint : CGPoint, withRadius radius : CGFloat) ->UIBezierPath
    {
        let path =  UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: 2*CGFloat.pi,
            clockwise: false
        )
        
        path.lineWidth = 5.0
        
        return path
    }
    
    private func getEyeCenter(eye: Eye) -> CGPoint
    {
        var eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        switch eye {
        case .Left : eyeCenter.x -= eyeOffset
        case .Right : eyeCenter.x += eyeOffset
        }
        return eyeCenter
        
        
    }
    
    private func pathForEye(eye:Eye) -> UIBezierPath
    {
        
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadios
        let eyeCenter = getEyeCenter(eye: eye)
        
        return pathForCircleCenterdAtPoint(midPoint: eyeCenter, withRadius: eyeRadius)
    }
    
    
    private func pathForMouth() -> UIBezierPath
    {
        let mouthWitdth = skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
        
        let mouthRect = CGRect(x:skullCenter.x - mouthWitdth/2 , y: skullCenter.y + mouthOffset, width : mouthWitdth , height : mouthHeight
                    )
        
        let SmileOffset =  CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let start = CGPoint(x:mouthRect.minX , y:mouthRect.minY)
        let end = CGPoint(x:mouthRect.maxX , y:mouthRect.minY)
        let cp1 = CGPoint(x:mouthRect.minX  + mouthRect.width/3, y:mouthRect.minY + SmileOffset)
        let cp2 = CGPoint(x:mouthRect.maxX  - mouthRect.width/3,y:mouthRect.minY + SmileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to:end, controlPoint1: cp1 , controlPoint2: cp2)
        path.lineWidth = 5.0
        
        return path
        
        
    }
    
    override func draw(_ rect: CGRect)
    {
        UIColor.blue.set()
        pathForCircleCenterdAtPoint(midPoint: skullCenter, withRadius: skullRadius).stroke()
        pathForEye(eye : .Left).stroke()
        pathForEye(eye : .Right).stroke()

        pathForMouth().stroke()
        
    }
 

}
