import UIKit
import AudioToolbox.AudioServices

class RotateViewController: UIViewController {
    
    var mobbers: [String] = [];
    var activeMobberIndex = 0;
    var selectedMinutes = 0;
    
    @IBOutlet weak var mobberLabel: UILabel!
    
    override func viewDidLoad() {
        mobberLabel.text = buildLabelText(name: mobbers[increment(currentIndex: activeMobberIndex)]);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
    func buildLabelText(name: String) -> String {
        return name + "'s turn"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TimerViewController
        destinationVC.timerSeconds = 0
        destinationVC.activeMobberIndex = increment(currentIndex: activeMobberIndex)
        destinationVC.mobbers = mobbers
        destinationVC.selectedMinutes = selectedMinutes
    }
    
    func increment(currentIndex: Int) -> Int {
        let mobberNo = currentIndex + 1
        if(mobberNo == mobbers.count) {
            return 0
        } else if(mobberNo < mobbers.count) {
            return mobberNo
        }
        return 0
    }
    
    @IBAction func rotateButton(_ sender: Any) {
        performSegue(withIdentifier: "rotateStartSegue", sender: nil)
    }
}
