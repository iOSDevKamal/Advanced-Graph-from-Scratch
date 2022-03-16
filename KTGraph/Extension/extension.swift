import UIKit

let mainView = UIView()
let scrollView = UIScrollView()
let hightlightView = UIView()
var indicateLimitArr = [Int]()
var startPoint = CGFloat()
var endPoint = CGFloat()

extension UIViewController : UIScrollViewDelegate {
    
    func displayGraph(frame : CGRect, dateArr : [Date], stepsArr : [Int], targetSteps : Int) {
        mainView.frame = frame
        mainView.backgroundColor = UIColor.black
        
        let max = stepsArr.max()!
        let part = max/(targetSteps/2)
        print(stepsArr)
        print(part)
        
        let halfTarget = targetSteps/2
        for k in 0..<part {
            let av = ((Int(frame.height) - 60)/(part + 1))
            let targetHalfWidth = UILabel.textWidth(font: UIFont.systemFont(ofSize: 15), text: "\(Int(targetSteps/2))") + 32
            let targetHalf = UILabel.init(frame: CGRect.init(x: frame.width - targetHalfWidth, y: CGFloat((av * (part - k)) - 10), width: targetHalfWidth, height: 20))
            targetHalf.textColor = UIColor.white
            targetHalf.textAlignment = .center
            targetHalf.font = UIFont.systemFont(ofSize: 15)
            targetHalf.text = "\(Int(halfTarget * (k + 1)))"
            mainView.addSubview(targetHalf)
        }
        
        let indicateView = UIView.init(frame: CGRect.init(x: (frame.width/2) - 0.5, y: 0, width: 1, height: frame.height - 50))
        indicateView.backgroundColor = UIColor.orange
        mainView.addSubview(indicateView)
        
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        scrollView.bounces = false
        scrollView.backgroundColor = UIColor.clear
        
        var labelXPoint = 0
        
        for i in 0..<dateArr.count {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd"
            let dateStr = formatter.string(from: dateArr[i])
            
            let width = UILabel.textWidth(font: UIFont.systemFont(ofSize: 17), text: dateStr)
            
            let btn = UIButton.init(frame: CGRect(x: CGFloat(labelXPoint), y: frame.height - 50, width: width + 30, height: 50))
            
            if i < 5 || i > dateArr.count - 6 {
                btn.isEnabled = false
                btn.setTitleColor(UIColor.init(white: 1, alpha: 0.5), for: .normal)
            }
            else {
                
                if i == 5 {
                    startPoint = btn.center.x
                }
                
                if i == dateArr.count - 6 {
                    endPoint = btn.center.x
                }
                
                btn.setTitleColor(UIColor.white, for: .normal)
                
                //Steps Indicator
                
                let stepCount = stepsArr[i]
                let canvasViewHeight = frame.height - 60
                let stepHeight = ((Int(canvasViewHeight)/(part + 1)) * 2 * stepCount)/targetSteps
                
                let stepIndicateView = UIView.init(frame: CGRect.init(x: btn.center.x - 4, y: canvasViewHeight - CGFloat(stepHeight), width: 8, height: CGFloat(stepHeight)))
                stepIndicateView.layer.cornerRadius = 4
                
                let bc = canvasViewHeight/CGFloat((part + 1))
                if CGFloat(stepHeight) > (bc * 2) {
                stepIndicateView.backgroundColor = UIColor.green
                }
                else {
                    stepIndicateView.backgroundColor = UIColor.lightGray
                }
                scrollView.addSubview(stepIndicateView)
            }
            
            btn.addTarget(self, action: #selector(dateAction(_:)), for: .touchUpInside)
            
            btn.setTitle(dateStr, for: .normal)
            btn.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.00)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            scrollView.addSubview(btn)
            
            labelXPoint += Int(width) + 30
            
            scrollView.contentSize = CGSize.init(width: CGFloat(labelXPoint), height: frame.height)
        }
        
        mainView.addSubview(scrollView)
        
        //For hightlight view
        hightlightView.backgroundColor = UIColor.init(white: 0, alpha: 0.2)
        hightlightView.layer.cornerRadius = 20
        hightlightView.frame = CGRect.init(x: (frame.width/2) - 20, y: frame.height - 45, width: 40, height: 40)
        mainView.addSubview(hightlightView)
        
        self.view.addSubview(mainView)
        
        // set to current date
        scrollView.setContentOffset(CGPoint.init(x: endPoint - (mainView.frame.width/2), y: 0), animated: true)
    }
    
    //MARK: Scrollview delegates
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x + (mainView.frame.width/2) > endPoint {
            scrollView.contentSize = CGSize.init(width: scrollView.contentOffset.x + (mainView.frame.width), height: mainView.frame.height)
        }
        else {
            if scrollView.contentOffset.x + (mainView.frame.width/2) < startPoint {
                scrollView.contentOffset.x = startPoint - (mainView.frame.width/2)
            }
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        automaticallyAdjust(scrView: scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        automaticallyAdjust(scrView: scrollView)
    }
    
    func automaticallyAdjust(scrView : UIScrollView) {
        let actualPoint = CGPoint(x: (mainView.frame.width/2) + (scrollView.contentOffset.x), y: (scrollView.contentOffset.y) + mainView.frame.height - 20)

        for subView in scrollView.subviews {
            if subView.frame.contains(actualPoint) {
                scrollView.setContentOffset(CGPoint.init(x: subView.center.x - self.view.frame.width/2, y: 0), animated: true)
            }
        }
    }
    
    @objc func dateAction(_ sender:UIButton) {
        scrollView.setContentOffset(CGPoint.init(x: sender.center.x - self.view.frame.width/2, y: 0), animated: true)
    }
}

extension UILabel {
    func textWidth() -> CGFloat {
        return UILabel.textWidth(label: self)
    }
    
    class func textWidth(label: UILabel) -> CGFloat {
        return textWidth(label: label, text: label.text!)
    }
    
    class func textWidth(label: UILabel, text: String) -> CGFloat {
        return textWidth(font: label.font, text: text)
    }
    
    class func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(labelSize.width)
    }
}
