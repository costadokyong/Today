//
//  ViewController.swift
//  Today
//
//  Created by Dok Yong COsta on 6/12/24.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
        
    lazy var dataSource = createDataSource()
    var reminders: [Reminder] = Reminder.sampleData

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        updateSnapshot()
        collectionView.dataSource = dataSource
    }
    
    func pushDetailViewForReminder(withId id: Reminder.ID){
        let reminder = reminder(withId: id)
        let reminderViewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
            self?.updateReminder(reminder)
            self?.updateSnapshot(realoading: [reminder.id])
        }
        navigationController?.pushViewController(reminderViewController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let id = reminders[indexPath.item].id
        pushDetailViewForReminder(withId: id)
        return false
    }
    
    
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    func createDataSource() -> DataSource {
        let reminderCell = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        return DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in
            return collectionView.dequeueConfiguredReusableCell(using: reminderCell, for: indexPath, item: itemIdentifier)
        }
    }

}

