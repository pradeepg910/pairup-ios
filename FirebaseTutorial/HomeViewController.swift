import UIKit
import Firebase
import FirebaseAuth
import AVFoundation


class HomeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var minuesView: UIPickerView!
    
    
    var timerSeconds = 0;
    var timer = Timer();
    var isTimerRunning = false;
    var minutes: [String] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataForMinutesPicker()
        timerButtonGesture()
    }
    
    func timerButtonGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.normalTap))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap))
        tapGesture.numberOfTapsRequired = 1
        timerButton.addGestureRecognizer(tapGesture)
        timerButton.addGestureRecognizer(longGesture)
    }
    
    func setupDataForMinutesPicker() {
        minuesView.dataSource = self
        minuesView.delegate = self
        for minute in 1...15 {
            if(minute < 10) {
                minutes.append("0" + String(minute))
            } else {
                minutes.append(String(minute))
            }
        }
        minuesView.selectRow(7, inComponent: 0, animated: true)
    }
    
    func normalTap(){
        if(timerButton.titleLabel?.text == "Start") {
            runTimer()
        } else if(timerButton.titleLabel?.text == "Rotate") {
            timerSeconds = 0;
        }
    }
    
    func longTap(sender : UIGestureRecognizer){
        if sender.state == .ended {
            stopTimer()
        }
        else if sender.state == .began {
            if(timerButton.titleLabel?.text == "Rotate") {
                timerButton.setTitle( "Stop" , for: .normal )
                timerButton.backgroundColor = UIColor.red
            }
        }
    }

//    @IBAction func timerButton(_ sender: Any) {
//        if(timerButton.titleLabel?.text == "Start") {
//            runTimer()
//        } else if(timerButton.titleLabel?.text == "Stop") {
//            stopTimer()
//        }
//    }
    
    func runTimer() {
        timerButton.setTitle( "Rotate" , for: .normal )
        timerButton.backgroundColor = UIColor.orange
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        if(timerSeconds < totalTimerSeconds()) {
            timerSeconds += 1
            timerLabel.text = formatToHHMMSS(time: TimeInterval(timerSeconds))
        } else {
            timerSeconds = 0
            timer.invalidate();
            playSound()

        }
    }
    
    func playSound() {
        let systemSoundID: SystemSoundID = 1016
        AudioServicesPlaySystemSound (systemSoundID)
        AudioServicesPlaySystemSound (systemSoundID)
        AudioServicesPlaySystemSound (systemSoundID)
    }
    func totalTimerSeconds() -> Int {
        let selectedMinutes = minutes[minuesView.selectedRow(inComponent: 0)];
        let totalSeconds: Int = Int(selectedMinutes)! * 60;
        return totalSeconds;
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return minutes.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return minutes[row]
    }
    
    func stopTimer() {
        timerSeconds = 0
        timer.invalidate()
        timerButton.setTitle( "Start" , for: .normal )
        timerButton.backgroundColor = UIColor.green
        timerLabel.text = formatToHHMMSS(time: TimeInterval(timerSeconds))
        
    }
    
    func formatToHHMMSS(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02d:%02d", minutes, seconds)
    }
    
//    @IBAction func logOutAction(sender: AnyObject) {
//        if Auth.auth().currentUser != nil {
//            do {
//                try Auth.auth().signOut()
//                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
//                present(vc, animated: true, completion: nil)
//                
//            } catch let error as NSError {
//                print(error.localizedDescription)
//            }
//        }
//    }
}
