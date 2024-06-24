//
//  ReminderViewController.swift
//  Today
//
//  Created by Dok Yong COsta on 6/21/24.
//

import UIKit

class ReminderViewController : UICollectionViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section,Row>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section,Row>

    var reminder: Reminder
    private var dataSource: DataSource!
    
    init(reminder: Reminder) {
        self.reminder = reminder
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        listConfiguration.headerMode = .firstItemInSection
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        super.init(collectionViewLayout: listLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Always initialize ReminderViewController using init(reminder:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistration)
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Row) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        if #available(iOS 16, *) {
            navigationItem.style = .navigator
        }
        navigationItem.title = NSLocalizedString("Reminder", comment: "Reminder view controller title")
        navigationItem.rightBarButtonItem = editButtonItem
        updateSnapShotForViewing()
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            updateSnapShotForEditing()
        } else {
            updateSnapShotForViewing()
        }
    }

    func cellRegistration(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row){
        let section = section(for: indexPath)
        switch(section,row){
        case (_,.header(let title)):
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = title
            cell.contentConfiguration = contentConfiguration
        case (.view,_):
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = text(for: row)
            contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
            contentConfiguration.image = row.image
            
            cell.contentConfiguration = contentConfiguration
        default:
            fatalError("Unexpeected combination of section and row.")
        }
        
        cell.tintColor = .todayPrimaryTint
    }
    
    func text (for row: Row) -> String? {
        switch row {
        case .date: return reminder.dueDate.dayText
        case .notes: return reminder.notes
        case .time: return reminder.dueDate.formatted(date: .omitted, time: .shortened)
        case .title: return reminder.title
        default: return nil
        }
    }
    
    private func section(for indexPath: IndexPath) -> Section {
        let sectionNumber = isEditing ? indexPath.section + 1 : indexPath.section
        guard let section = Section(rawValue: sectionNumber) else {
            fatalError("Unable to find matching section")
        }
        return section
    }
    
    private func updateSnapShotForViewing() {
        var snapshot = SnapShot()
        snapshot.appendSections([.view])
        snapshot.appendItems([Row.header(""), Row.title, Row.date, Row.time, Row.notes], toSection: .view)
        dataSource.apply(snapshot)
    }
    
    private func updateSnapShotForEditing() {
        var snapshot = SnapShot()
        snapshot.appendSections([.title,.date,.notes])
        snapshot.appendItems([.header(Section.title.name)],toSection: .title)
        snapshot.appendItems([.header(Section.date.name)],toSection: .date)
        snapshot.appendItems([.header(Section.notes.name)],toSection: .notes)
        dataSource.apply(snapshot)
    }
        
}
