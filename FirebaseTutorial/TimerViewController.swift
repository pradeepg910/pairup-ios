import UIKit

class TimerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var mobbersPickerView: UIPickerView!
    
    var timerSeconds = 0;
    var timer = Timer();
    var isTimerRunning = false;
    var minutes: [String] = [];
    var selectedMinutes = 0;
    var mobbers: [String] = [];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mobbersPickerView.dataSource = self;
        mobbersPickerView.delegate = self;
        
        timerButtonGesture()
        runTimer()
    }
    
    func timerButtonGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.normalTap))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap))
        tapGesture.numberOfTapsRequired = 1
        timerButton.addGestureRecognizer(tapGesture)
        timerButton.addGestureRecognizer(longGesture)
    }
    
    
        func normalTap(){
            timerSeconds = 0;
        }
    
        func longTap(sender : UIGestureRecognizer){
            if sender.state == .ended {
                stopTimer()
                performSegue(withIdentifier: "timerDone", sender: nil)

                //go to home
            }
            else if sender.state == .began {
                if(timerButton.titleLabel?.text == "Pause") {
                    timerButton.setTitle( "Stop" , for: .normal )
                    timerButton.backgroundColor = UIColor.red
                }
            }
        }
    
        func runTimer() {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
        }
    
        func updateTimer() {
            if(timerSeconds < totalTimerSeconds()) {
                timerSeconds += 1
                timerLabel.text = formatToHHMMSS(time: TimeInterval(timerSeconds))
            } else {
                // rotate
                timerSeconds = 0
                timer.invalidate();
//                playSound()
    
            }
        }
    
    func numberOfComponents(in minutesView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ minutesView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mobbers.count;
    }
    
    func pickerView(_ minutesView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mobbers[row]
    }
    
    
    //
    //    func playSound() {
    //        let systemSoundID: SystemSoundID = 1016
    //        AudioServicesPlaySystemSound (systemSoundID)
    //        AudioServicesPlaySystemSound (systemSoundID)
    //        AudioServicesPlaySystemSound (systemSoundID)
    //    }
        func totalTimerSeconds() -> Int {
            let totalSeconds: Int = selectedMinutes * 60;
            return totalSeconds;
        }
    
        func stopTimer() {
            timerSeconds = 0
            timer.invalidate()
            
        }
        
        func formatToHHMMSS(time:TimeInterval) -> String {
            let minutes = Int(time) / 60 % 60
            let seconds = Int(time) % 60
            return String(format:"%02d:%02d", minutes, seconds)
        }
    
}
