//
//  RCGDeviceTableViewCell.swift
//  RemoteControlGizmos
//
//  Created by Shvier on 24/12/2016.
//  Copyright © 2016 Shvier. All rights reserved.
//

import UIKit
import CoreBluetooth

let kDeviceTableViewCellReuseIdentifier: String = "RCGDeviceTableViewCell"

class RCGDeviceTableViewCell: UITableViewCell {

    @IBOutlet weak var deviceUUIDLabel: UILabel!
    
    class func cell(tableView: UITableView, indexPath: IndexPath) -> RCGDeviceTableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: kDeviceTableViewCellReuseIdentifier, for: indexPath) as! RCGDeviceTableViewCell
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: kDeviceTableViewCellReuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func bindDevice(deviceInfo: (peripheral: CBPeripheral, RSSI: Float)) {
        guard let deviceName = deviceInfo.peripheral.name else {
            return
        }
        self.deviceUUIDLabel.text = deviceName
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
