/******************************************************************************
 *
 * TVTTableViewController
 *
 ******************************************************************************/

import UIKit

class TVTTableViewController: UITableViewController, ENSideMenuDelegate {

    var menuButton: UIBarButtonItem!
    var items = [Any]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(toggleSideMenu(_:)))
        
        navigationItem.leftBarButtonItem = menuButton
        clearsSelectionOnViewWillAppear = true
        
        sideMenuController()?.sideMenu?.delegate = self
        
        let nib = UINib(nibName: String(describing: MediaCell.self), bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: String(describing: MediaCell.self))
        tableView.rowHeight = 60
    }
    
    func hide() {
        self.navigationController?.toast(title: "Timed out connecting to server")
    }
    
    @IBAction func toggleSideMenu(_ sender: AnyObject) {
        toggleSideMenuView()
    }
    
    //MARK: UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MediaCell.self), for: indexPath) as? MediaCell else {
            fatalError()
        }
                
        return cell
    }
}
