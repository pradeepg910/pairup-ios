
import UIKit

class TimerHomeController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource,
    UITextFieldDelegate {

    @IBOutlet weak var minutesView: UIPickerView!
    @IBOutlet weak var mobbersTableView: UITableView!
    @IBOutlet weak var mobberTextField: UITextField!
    @IBOutlet weak var timerButton: UIButton!
    
    var timerSeconds = 0;
    var timer = Timer();
    var minutes: [String] = [];
    var mobbers: [String] = [];
    var activeMobberIndex = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mobbersTableView.dataSource = self
        mobbersTableView.delegate = self
        mobbersTableView.layoutMargins = UIEdgeInsets.zero
        mobbersTableView.separatorInset = UIEdgeInsets.zero
        
        
        mobberTextField.delegate = self
        mobberTextField.keyboardAppearance = UIKeyboardAppearance.dark;
        
        setupDataForMinutesPicker()
        
        setupTimerButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TimerViewController
        destinationVC.selectedMinutes = Int(minutes[minutesView.selectedRow(inComponent: 0)])!;
        destinationVC.mobbers = mobbers;
        destinationVC.activeMobberIndex = activeMobberIndex
    }
    
    @IBAction func enterPressed(_ sender: Any) {
        addMobber(mobberTextField.text!)
        hideKeyboard()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activeMobberIndex = indexPath.row;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideKeyboard()
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func setupDataForMinutesPicker() {
        minutesView.dataSource = self
        minutesView.delegate = self
        for minute in 1...15 {
            if(minute < 10) {
                minutes.append("0" + String(minute))
            } else {
                minutes.append(String(minute))
            }
        }
        minutesView.selectRow(7, inComponent: 0, animated: true)
    }
    
    func addMobber(_ mobber: String) {
        if(mobber != "" && !mobbers.contains(mobber)) {
            mobbers.append(mobber)
            mobberTextField.text = ""
            mobbersTableView.reloadData()
            setupTimerButton()
        }
        if(mobbers.count > 1) {
            let index = IndexPath(item: 0, section: 0)
            mobbersTableView.selectRow(at: index, animated: true, scrollPosition: UITableViewScrollPosition.middle)

        }
    }
    
    func numberOfComponents(in minutesView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ minutesView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return minutes.count;
    }
    
    func pickerView(_ minutesView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return minutes[row]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (mobbers.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "itemCell")
        cell.backgroundColor = UIColor.gray
        cell.textLabel?.text = mobbers[indexPath.row]
        return(cell)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.delete) {
            mobbers.remove(at: indexPath.row)
            mobbersTableView.reloadData()
            setupTimerButton()
        }
    }
    
    func setupTimerButton() {
        if(mobbers.count == 0) {
            timerButton.isEnabled = false
        } else {
            timerButton.isEnabled = true
        }
    }
}
