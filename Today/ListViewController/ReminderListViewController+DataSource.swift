//
//  ReminderListViewController+DataSource.swift
//  Today
//
//  Created by Dok Yong COsta on 6/19/24.
//

import UIKit

extension ReminderListViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int,Reminder.ID>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Int,Reminder.ID>
    
    var reminderCompleteValue: String {NSLocalizedString("Completed", comment: "Reminder Completed value")}
    var reminderNotCompletedValue: String {NSLocalizedString("Not Completed", comment: "Reminder not completed value")}
    
    func updateSnapshot(realoading ids: [Reminder.ID] = []) {
        var snapshot = SnapShot()
        snapshot.appendSections([0])
        snapshot.appendItems(reminders.map{$0.id})
        
        if !ids.isEmpty {
            snapshot.reloadItems(ids)
        }
        
        dataSource.apply(snapshot)
        
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Reminder.ID) {
        let reminder = reminder(withId: id)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminder.title
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: .title2)
        contentConfiguration.secondaryText = reminder.dueDate.dayAndTimeText
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)
        cell.contentConfiguration = contentConfiguration
        
        var doneBtnConfig = donButtonCofiguration(for: reminder)
        doneBtnConfig.tintColor = .todayPrimaryTint
        
        cell.accessibilityCustomActions = [doneButtonAccessibilityAction(for: reminder)]
        cell.accessibilityValue = reminder.isComplete ? reminderCompleteValue : reminderNotCompletedValue
        
        cell.accessories = [
            .customView(configuration: doneBtnConfig),
            .disclosureIndicator(displayed: .always)
        ]
        
        let backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        cell.backgroundConfiguration = backgroundConfiguration
        
    }
    
    func reminder(withId id: Reminder.ID) -> Reminder {
        let index = reminders.indexOfReminder(withId: id)
        return reminders[index]
    }
    
    func updateReminder(_ reminder: Reminder) {
        let index = reminders.indexOfReminder(withId: reminder.id)
        reminders[index] = reminder
    }
    
    private func doneButtonAccessibilityAction(for reminder: Reminder) -> UIAccessibilityCustomAction {
        let name = NSLocalizedString("Toggle completion", comment: "Reminder done button accessibility label")
        let action = UIAccessibilityCustomAction(name: name) { [weak self] action in
            self?.completeReminder(whereID: reminder.id)
            return true
        }
        return action
    }
    
    func donButtonCofiguration(for reminder : Reminder) -> UICellAccessory.CustomViewConfiguration {
        let symbolName = reminder.isComplete ? "checkmark.seal.fill" : "checkmark.seal"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = ReminderDoneButton()
        
        button.id = reminder.id
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(didPressDoneButton(_:)), for: .touchUpInside)
        return UICellAccessory.CustomViewConfiguration(
            customView: button, placement: .leading(displayed: .always)
        )
    }
    
    func completeReminder(whereID id: Reminder.ID){
        var reminder = reminder(withId: id)
        reminder.isComplete.toggle()
        updateReminder(reminder)
        updateSnapshot(realoading: [id])
        
    }
}

