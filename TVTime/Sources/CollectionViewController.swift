/******************************************************************************
 *
 * CollectionViewController
 *
 ******************************************************************************/

import UIKit

class CollectionViewController: UICollectionViewController, ENSideMenuDelegate {

    @IBOutlet weak var toggleButton: UIBarButtonItem!

    var menuButton: UIBarButtonItem!
    var items = [Any]()
    let refreshControl = UIRefreshControl()
    var isTableViewMode = true
    var shouldPan = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(self.toggleSideMenu(_:)))
        
        navigationItem.leftBarButtonItem = menuButton
        clearsSelectionOnViewWillAppear = true
        
        sideMenuController()?.sideMenu?.delegate = self
        
        collectionView?.insertSubview(refreshControl, at: 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView?.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        collectionView?.reloadData()    }
    
    @IBAction func didTapChangeLayout() {
        
        isTableViewMode = !isTableViewMode
        
        var image: UIImage!
        
        if isTableViewMode {
            image = UIImage(named: "Grid 2")
        } else {
            image = UIImage(named: "List 2")
        }
        
        toggleButton.image = image
        
        collectionView?.reloadData()
    }
        
    func hide() {
        if let nav = navigationController as? TVTNavigationViewController {
            nav.toast(title: "Timed out connecting to server")
        }
    }
    
    @IBAction func toggleSideMenu(_ sender: AnyObject) {
        toggleSideMenuView()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MediaCollectionViewCell.self), for: indexPath) as? MediaCollectionViewCell else {
            fatalError()
        }
    
        cell.shouldPan = shouldPan
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        hideSideMenuView()
    }
    
    //MARK: UIScrollViewDelegate
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        shouldPan = false
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        shouldPan = true
        
        if let indexPaths = collectionView?.indexPathsForVisibleItems {
            collectionView?.reloadItems(at: indexPaths)
        }
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isTableViewMode {
            return CGSize(width: collectionView.bounds.size.width, height: 80)
        }
        
        return CGSize(width: 115, height: 115)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        
        if isTableViewMode {
            return 0.0
        }
        
        return 10.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        
        if isTableViewMode {
            return 0.0
        }
        
        return 10.0
    }
}
