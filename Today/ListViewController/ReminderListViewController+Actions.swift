//
//  ReminderListViewController+Actions.swift
//  Today
//
//  Created by Dok Yong COsta on 6/19/24.
//

import UIKit

extension ReminderListViewController {
    @objc func didPressDoneButton(_ sender: ReminderDoneButton) {
        guard let id = sender.id else { return }
        completeReminder(whereID: id)
    
    }
}
