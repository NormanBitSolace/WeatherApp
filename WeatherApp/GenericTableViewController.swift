import UIKit

class GenericTableViewController: UITableViewController {

    var numberOfSections = 1
    var numberOfRowsInSection: ((Int) -> Int)?
    var configureCell: ((UITableViewCell, IndexPath) -> Void)?
    var touchHandler: ((IndexPath) -> Void)?

    final override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }

    final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRowsInSection = numberOfRowsInSection else { fatalError() }
        return numberOfRowsInSection(section)
    }

    final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let configureCell = configureCell else { fatalError() }
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "generic")
        configureCell(cell, indexPath)
        return cell
    }

    final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let touchHandler = touchHandler {
            touchHandler(indexPath)
        }
    }
}

class GenericPopoverTableViewController: GenericTableViewController, UIPopoverPresentationControllerDelegate {

    final public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    final public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

final class MenuPopoverViewController: GenericPopoverTableViewController {

    final var data: [String]! {
        didSet {
            numberOfRowsInSection = { _ in return self.data.count }
            tableView.reloadData()
        }
    }
    final var menuChoice: ((String) -> Void)!

    override init(style: UITableView.Style) {
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    final override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureCell = { cell, indexPath in
            cell.textLabel?.text = self.data[indexPath.row]
        }
        touchHandler = { indexPath in
            self.menuChoice(self.data[indexPath.row])
        }
        tableView.isScrollEnabled = false
        let rowHeight = 44
        tableView.rowHeight = CGFloat(rowHeight)
        preferredContentSize = CGSize(width: 140, height: rowHeight * data.count)
    }
}
