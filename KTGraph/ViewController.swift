import UIKit

class ViewController: UIViewController {
    
    var randomArr = [500, 100, 1500, 3000, 3500, 4500, 4000, 6000, 8000, 7000, 10000, 2000, 1200]
    var initialValue = -35
    var lastValue = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dates = [Date]()
        var steArr = [Int]()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        
        for j in initialValue...lastValue {
            let d = Calendar.current.date(byAdding: .day, value: j, to: Date())
            dates.append(d!)
            let element = randomArr.randomElement()!
            steArr.append(element)
        }
        
        self.displayGraph(frame: CGRect.init(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.width), dateArr: dates, stepsArr: steArr, targetSteps: 6000)
    }
}

