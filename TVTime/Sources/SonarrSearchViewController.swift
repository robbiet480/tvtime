/******************************************************************************
 *
 * SonarrSearchViewController
 *
 ******************************************************************************/

import UIKit
import TVTimeSDK

final class SonarrSearchViewController: SearchViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search for TV Shows"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let series = items[indexPath.row] as? SeriesSearchResult else {
            fatalError()
        }

        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! MediaCell

        cell.config(withItem: series)
        cell.buttonHandler = {

            MyHUD.sharedHUD.show()
            Networking.add(series, success: { (success) in
                MyHUD.sharedHUD.hide()
                self.navigationController?.toast(title: "\(series.title) added successfully!")
                }, failure: { (error) in
                    MyHUD.sharedHUD.hide()
            })
        }

        return cell
    }
}
