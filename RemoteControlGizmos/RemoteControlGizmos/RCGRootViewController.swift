//
//  RCGRootViewController.swift
//  RemoteControlGizmos
//
//  Created by Shvier on 24/12/2016.
//  Copyright © 2016 Shvier. All rights reserved.
//

import UIKit
import CoreBluetooth

class RCGRootViewController: UIViewController {
    
    lazy var rightBarItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshBluetooth))
    }()
    
    lazy var peripherals: [(peripheral: CBPeripheral, RSSI: Float)] = {
        return Array<(peripheral: CBPeripheral, RSSI: Float)>()
    }()
    
    var tableView: UITableView!
    
    // MARK - Init Life Cycle
    func initNavigation() {
        let rightBarItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshBluetooth))
        rightBarItem.isEnabled = false
        self.navigationItem.rightBarButtonItem = rightBarItem
        self.rightBarItem = rightBarItem
    }
    
    func initSerial() {
        serial = BluetoothSerial(delegate: self)
    }
    
    func initTableView() {
        tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "RCGDeviceTableViewCell", bundle: nil), forCellReuseIdentifier: kDeviceTableViewCellReuseIdentifier)
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
    }
    
    func scanTimeOut() {
        serial.stopScan()
        self.navigationItem.title = "扫描完成"
        self.rightBarItem.isEnabled = true
    }
    
    func refreshBluetooth() {
        self.navigationItem.title = "正在扫描"
        serial.startScan()
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.scanTimeOut), userInfo: nil, repeats: false)
        self.rightBarItem.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initNavigation()
        self.initSerial()
        self.initTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

// MARK - BluetoothSerialDelegate
extension RCGRootViewController: BluetoothSerialDelegate {
    func serialDidChangeState() {
        if serial.centralManager.state != .poweredOn {
            self.navigationItem.title = "未连接"
            let alertVC: UIAlertController = UIAlertController(title: "蓝牙未打开", message: "请在设置中打开蓝牙设备以进行连接", preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction(title: "好的", style: .default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
        } else {
            self.navigationItem.title = "正在扫描"
            serial.startScan()
            Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.scanTimeOut), userInfo: nil, repeats: false)
        }
    }
    
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        
    }
    
    func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?) {
        if self.peripherals.contains(where: { (peripheral: CBPeripheral, RSSI: Float) -> Bool in
            return true
        }) {
            return
        }
        self.peripherals.append((peripheral, RSSI as! Float))
        self.tableView.reloadData()
    }
    
    func serialDidConnect(_ peripheral: CBPeripheral) {
        self.performSegue(withIdentifier: "rootToRemote", sender: nil)
//        let remoteVC: RCGRemoteViewController = RCGRemoteViewController(nibName: "RCGRemoteViewController", bundle: nil)
//        remoteVC.modalTransitionStyle = .flipHorizontal
//        self.present(remoteVC, animated: true, completion: nil)
    }
}

// MARK - TableViewDelegate
extension RCGRootViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.navigationItem.title = "正在连接"
        serial.connectToPeripheral(self.peripherals[indexPath.row].peripheral)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RCGDeviceTableViewCell = RCGDeviceTableViewCell.cell(tableView: tableView, indexPath: indexPath)
        cell.bindDevice(deviceInfo: self.peripherals[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.peripherals.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
