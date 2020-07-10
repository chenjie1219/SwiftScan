//
//  UIImage+Extensions.swift
//  SwiftScanner
//
//  Created by Jason on 2018/12/3.
//  Copyright © 2018 Jason. All rights reserved.
//

import Foundation

extension UIImage{
    
    /// 更改图片颜色
    public func changeColor(_ color : UIColor) -> UIImage{
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        color.setFill()
        
        let bounds = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        UIRectFill(bounds)
        
        self.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1.0)
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let image = tintedImage else {
            return UIImage()
        }
        
        return image
    }
    
    
    ///生成二维码
    public class func generateQRCode(_ text: String,_ width:CGFloat,_ fillImage:UIImage? = nil, _ color:UIColor? = nil) -> UIImage? {
        
        //给滤镜设置内容
        guard let data = text.data(using: .utf8) else {
            return nil
        }
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            
            // 设置生成的二维码的容错率
            // value = @"L/M/Q/H"
            filter.setValue("H", forKey: "inputCorrectionLevel")
            
            //获取生成的二维码
            guard let outPutImage = filter.outputImage else {
                return nil
            }
            
            // 设置二维码颜色
            let colorFilter = CIFilter(name: "CIFalseColor", parameters: ["inputImage":outPutImage,"inputColor0":CIColor(cgColor: color?.cgColor ?? UIColor.black.cgColor),"inputColor1":CIColor(cgColor: UIColor.clear.cgColor)])
            
            //获取带颜色的二维码
            guard let newOutPutImage = colorFilter?.outputImage else {
                return nil
            }
            
            let scale = width/newOutPutImage.extent.width
            
            let transform = CGAffineTransform(scaleX: scale, y: scale)
            
            let output = newOutPutImage.transformed(by: transform)
            
            let QRCodeImage = UIImage(ciImage: output)
            
            guard let fillImage = fillImage else {
                return QRCodeImage
            }
            
            let imageSize = QRCodeImage.size
            
            UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale)
            
            QRCodeImage.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
            
            let fillRect = CGRect(x: (width - width/5)/2, y: (width - width/5)/2, width: width/5, height: width/5)
            
            fillImage.draw(in: fillRect)
            
            guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return QRCodeImage }
            
            UIGraphicsEndImageContext()
            
            return newImage
            
        }
        
        return nil
        
    }
    
    
    ///生成条形码
    public class func generateCode128(_ text:String, _ size:CGSize,_ color:UIColor? = nil ) -> UIImage?
    {
        //给滤镜设置内容
        guard let data = text.data(using: .utf8) else {
            return nil
        }
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            
            filter.setDefaults()
            
            filter.setValue(data, forKey: "inputMessage")
            
            //获取生成的条形码
            guard let outPutImage = filter.outputImage else {
                return nil
            }
            
            // 设置条形码颜色
            let colorFilter = CIFilter(name: "CIFalseColor", parameters: ["inputImage":outPutImage,"inputColor0":CIColor(cgColor: color?.cgColor ?? UIColor.black.cgColor),"inputColor1":CIColor(cgColor: UIColor.clear.cgColor)])
            
            //获取带颜色的条形码
            guard let newOutPutImage = colorFilter?.outputImage else {
                return nil
            }
            
            let scaleX:CGFloat = size.width/newOutPutImage.extent.width
            
            let scaleY:CGFloat = size.height/newOutPutImage.extent.height
            
            let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            
            let output = newOutPutImage.transformed(by: transform)
            
            let barCodeImage = UIImage(ciImage: output)
            
            return barCodeImage
            
        }
        
        return nil
    }
    
    
    
}
