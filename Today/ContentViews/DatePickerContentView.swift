//
//  DatePickerContentView.swift
//  Today
//
//  Created by Dok Yong COsta on 6/28/24.
//
import UIKit

class DatePickerContentView : UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var date = Date.now
        var onChange: (Date) -> Void = { _ in }
        
        func makeContentView() -> UIView & UIContentView {
            DatePickerContentView(self)
        }
    }
    
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    let datePickerView = UIDatePicker()
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubView(datePickerView)
        datePickerView.addTarget(self, action: #selector(didPick(_:)), for: .valueChanged)
        datePickerView.preferredDatePickerStyle = .inline
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        datePickerView.date = configuration.date
        
    }
    
    @objc func didPick(_ sender: UIDatePicker) {
        guard let configuration = configuration as? DatePickerContentView.Configuration else { return }
        configuration.onChange(sender.date)
    }
}

extension UICollectionViewListCell {
    func datePickerConfiguration() -> DatePickerContentView.Configuration {
        DatePickerContentView.Configuration()
    }
}
