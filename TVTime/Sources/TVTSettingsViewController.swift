/******************************************************************************
 *
 * TVTSettingsViewController
 *
 ******************************************************************************/

import UIKit
import TVTimeSDK

final class TVTSettingsViewController: UITableViewController {
    
    @IBOutlet fileprivate weak var sonarrHostTextField: FloatingPlaceholderTextField!
    @IBOutlet fileprivate weak var sonarrApiTextField: FloatingPlaceholderTextField!
    @IBOutlet fileprivate weak var couchPotatoHostTextField: FloatingPlaceholderTextField!
    @IBOutlet fileprivate weak var couchPotatoApiTextField: FloatingPlaceholderTextField!
    @IBOutlet fileprivate weak var nzbGetHostTextField: FloatingPlaceholderTextField!
    @IBOutlet fileprivate weak var nzbGetUsernameTextField: FloatingPlaceholderTextField!
    @IBOutlet fileprivate weak var nzbGetPasswordTextField: FloatingPlaceholderTextField!
    @IBOutlet fileprivate weak var timeoutTextField: FloatingPlaceholderTextField!
    
    fileprivate var sonarrHost: String?
    fileprivate var sonarrApi: String?
    fileprivate var couchPotatoHost: String?
    fileprivate var couchPotatoApi: String?
    fileprivate var nzbGetHost: String?
    fileprivate var nzbGetUsername: String?
    fileprivate var nzbGetPassword: String?
    fileprivate var timeout: Double?
    
    var dismissClosure:((Void)-> (Void))?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        
        if let defaults = Networking.userDefaults() {
            sonarrHost = defaults.sonarrHost
            sonarrApi = defaults.sonarrApi
            couchPotatoHost = defaults.cpHost
            couchPotatoApi = defaults.cpApi
            nzbGetHost = defaults.nzbGetHost
            nzbGetUsername = defaults.nzbGetUsername
            nzbGetPassword = defaults.nzbGetPassword
            timeout = defaults.timeout
        }
        
        sonarrHostTextField.placeholderText = "Host"
        sonarrHostTextField.text = sonarrHost
        sonarrHostTextField.returnKeyType = .next
        sonarrHostTextField.delegate = self
        
        sonarrApiTextField.placeholderText = "API Key"
        sonarrApiTextField.text = sonarrApi
        sonarrApiTextField.returnKeyType = .next
        sonarrApiTextField.delegate = self
        
        couchPotatoHostTextField.placeholderText = "Host"
        couchPotatoHostTextField.text = couchPotatoHost
        couchPotatoHostTextField.returnKeyType = .next
        couchPotatoHostTextField.delegate = self
        
        couchPotatoApiTextField.placeholderText = "API Key"
        couchPotatoApiTextField.text = couchPotatoApi
        couchPotatoApiTextField.returnKeyType = .next
        couchPotatoApiTextField.delegate = self
        
        nzbGetHostTextField.placeholderText = "Host"
        nzbGetHostTextField.text = nzbGetHost
        nzbGetHostTextField.returnKeyType = .next
        nzbGetHostTextField.delegate = self
        
        nzbGetUsernameTextField.placeholderText = "Username"
        nzbGetUsernameTextField.text = nzbGetUsername
        nzbGetUsernameTextField.returnKeyType = .next
        nzbGetUsernameTextField.delegate = self
        
        nzbGetPasswordTextField.placeholderText = "Password"
        nzbGetPasswordTextField.text = nzbGetPassword
        nzbGetPasswordTextField.returnKeyType = .next
        nzbGetPasswordTextField.delegate = self
        
        timeoutTextField.placeholderText = "Timeout"
        timeoutTextField.returnKeyType = .done
        timeoutTextField.keyboardType = .numberPad
        timeoutTextField.delegate = self
        
        if let timeout = timeout {
            timeoutTextField.text = String(Int(timeout))
        }
    }
    
    @IBAction func doneButtonTapped() {
        view.endEditing(true)
        savePrefs()
        dismiss(animated: true) {
            
            if let dismissClosure = self.dismissClosure {
                dismissClosure()
            }
            
            Networking.startWiFiDetection(reachableBlock: AppDelegate.connectionBlock, notReachableBlock: AppDelegate.noConnectionBlock)
        }
    }
    
    func savePrefs() {
        UserDefaults.standard.set(sonarrHost, forKey: DefaultsKeys.Sonarr.host)
        UserDefaults.standard.set(sonarrApi, forKey: DefaultsKeys.Sonarr.api)
        UserDefaults.standard.set(couchPotatoHost, forKey: DefaultsKeys.CouchPotato.host)
        UserDefaults.standard.set(couchPotatoApi, forKey: DefaultsKeys.CouchPotato.api)
        UserDefaults.standard.set(nzbGetHost, forKey: DefaultsKeys.NZBGet.host)
        UserDefaults.standard.set(nzbGetUsername, forKey: DefaultsKeys.NZBGet.username)
        UserDefaults.standard.set(nzbGetPassword, forKey: DefaultsKeys.NZBGet.password)
        UserDefaults.standard.set(timeout, forKey: DefaultsKeys.Networking.timeout)
        
        UserDefaults.standard.synchronize()
    }
}

extension TVTSettingsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == sonarrHostTextField {
            sonarrApiTextField.becomeFirstResponder()
        } else if textField == sonarrApiTextField {
            couchPotatoHostTextField.becomeFirstResponder()
        } else if textField == couchPotatoHostTextField {
            couchPotatoApiTextField.becomeFirstResponder()
        } else if textField == couchPotatoApiTextField {
            nzbGetHostTextField.becomeFirstResponder()
        } else if textField == nzbGetHostTextField {
            nzbGetUsernameTextField.becomeFirstResponder()
        } else if textField == nzbGetUsernameTextField {
            nzbGetPasswordTextField.becomeFirstResponder()
        } else if textField == nzbGetPasswordTextField {
            timeoutTextField.becomeFirstResponder()
        } else if textField == timeoutTextField {
            timeoutTextField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let text = textField.text, text.characters.count > 0 {
            
            if textField == sonarrHostTextField {
                sonarrHost = text
            } else if textField == sonarrApiTextField {
                sonarrApi = text
            } else if textField == couchPotatoHostTextField {
                couchPotatoHost = text
            } else if textField == couchPotatoApiTextField {
                couchPotatoApi = text
            } else if textField == nzbGetHostTextField {
                nzbGetHost = text
            } else if textField == nzbGetUsernameTextField {
                nzbGetUsername = text
            } else if textField == nzbGetPasswordTextField {
                nzbGetPassword = text
            } else if textField == timeoutTextField {
                timeout = Double(text)!
            }
        }
    }
}
