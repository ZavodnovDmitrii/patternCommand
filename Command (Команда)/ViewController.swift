
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var text: UITextField!
    let commandExecuter = CommandExecuter()
    var undoCom: UndoCommand?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        text.delegate = self
    }
    
    @IBAction func backButton(_ sender: Any) {
        text.text = commandExecuter.undoLast()
    }
}

//MARK: - Delegate
extension ViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text {
            undoCom = UndoCommand(argument: text)
            commandExecuter.addCommand(addCommand: undoCom!)
            commandExecuter.addition(string)
        }
        return true
    }
}

//MARK: - Protocol
protocol BaseCommandProtocol {
    func undo() -> String
    func addition(_ str: String)
}

//MARK: - UndoCommand
class UndoCommand: BaseCommandProtocol {
    private var originalString: String
    private var currentString: String
    
    init(argument: String) {
        self.currentString = argument
        self.originalString = argument
    }
    
    func undo() -> String {
        if currentString.count != 0 {
        currentString.removeLast()
        } else { return ""}
        printCurrentString()
        return currentString
    }
    
    func addition(_ str: String) {
        currentString.append(str)
        printCurrentString()
    }
    
    func printCurrentString() {
        print(currentString)
    }
}

//MARK: - CommandExecuter
class CommandExecuter {
    private var arrayOfCommand = [BaseCommandProtocol]()
    
    func addCommand(addCommand: BaseCommandProtocol) {
        arrayOfCommand.append(addCommand)
    }
    
    func addition(_ str: String) {
        for command in arrayOfCommand {
            command.addition(str)
        }
    }
    
    func undoLast() -> String {
        var title = String()
        for command in arrayOfCommand {
            title = command.undo()
        }
        return title
    }
}

