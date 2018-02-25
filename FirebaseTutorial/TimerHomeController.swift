
import UIKit

class TimerHomeController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,
    UITextFieldDelegate, UICollectionViewDataSource,
    UICollectionViewDelegate{

    @IBOutlet weak var minutesView: UIPickerView!
    @IBOutlet weak var mobberTextField: UITextField!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var mobberCollectionView: UICollectionView!
    
    var timerSeconds = 0;
    var timer = Timer();
    var minutes: [String] = [];
    var mobbers: [String] = ["Padeep Ganesan", "Sarah Pradeep"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mobberTextField.delegate = self
        mobberTextField.keyboardAppearance = UIKeyboardAppearance.dark;
        
        mobberCollectionView.dataSource = self
        mobberCollectionView.delegate = self
        
        
        setupDataForMinutesPicker()
        
        setupTimerButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TimerViewController
        destinationVC.selectedMinutes = Int(minutes[minutesView.selectedRow(inComponent: 0)])!;
        destinationVC.mobbers = mobbers;
    }
    
    @IBAction func enterPressed(_ sender: Any) {
        addMobber(mobberTextField.text!)
        hideKeyboard()
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
            mobberCollectionView.reloadData()
            setupTimerButton()
        }
        print(mobbers);
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mobbers.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MobberCell = collectionView.dequeueReusableCell(withReuseIdentifier: "mobCell", for: indexPath) as! MobberCell;
        cell.mobCell.text = shortName(name: mobbers[indexPath.row])
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        highlightCell(indexPath: indexPath, flag: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        highlightCell(indexPath: indexPath, flag: false)
    }
    
    func highlightCell(indexPath : IndexPath, flag: Bool) {
        
        let cell: MobberCell = mobberCollectionView.cellForItem(at: indexPath) as! MobberCell
        
        if flag {
            cell.mobCell.backgroundColor = UIColor.orange
            cell.mobCell.text = mobbers[indexPath.row]
            cell.mobCell.font = UIFont.systemFont(ofSize: CGFloat(15))
        } else {
            cell.mobCell.text = shortName(name: mobbers[indexPath.row])
            cell.mobCell.backgroundColor = UIColor.gray
            cell.mobCell.adjustsFontSizeToFitWidth = true
            

        }
    }
    
    func shortName(name: String) -> String {
        let names = name.components(separatedBy: " ");
        
        if(names.count >= 2) {
            let firstChar = names[0].substring(to: names[0].index(names[0].startIndex, offsetBy: 1)).uppercased()
            
            let secondChar = names[1].substring(to: names[1].index(names[1].startIndex, offsetBy: 1)).lowercased()
            return firstChar + secondChar
        } else if(names.count == 1) {
            return "Pr";
        } else {
            return "Un";
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
