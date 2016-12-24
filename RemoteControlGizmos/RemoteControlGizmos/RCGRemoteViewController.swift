//
//  RCGRemoteViewController.swift
//  RemoteControlGizmos
//
//  Created by Shvier on 24/12/2016.
//  Copyright © 2016 Shvier. All rights reserved.
//

import UIKit
import CoreBluetooth

class RCGRemoteViewController: UIViewController {
    
    override var shouldAutorotate: Bool {
        get {
            return true
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get  {
            return UIInterfaceOrientationMask.landscape
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return false
        }
    }
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBAction func clickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickTurnLeft(_ sender: Any) {
        serial.sendMessageToDevice("l")
    }
    
    @IBAction func clickTurnRight(_ sender: Any) {
        serial.sendMessageToDevice("r")
    }
    
    @IBAction func clickAccelerate(_ sender: Any) {
        serial.sendMessageToDevice("a")
    }
    
    @IBAction func clickSlowDown(_ sender: Any) {
        serial.sendMessageToDevice("s")
    }
    
    func showBackButton() {
        backButton.isHidden = false
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.dismissBackButton), userInfo: nil, repeats: false)
    }
    
    func dismissBackButton() {
        backButton.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serial.delegate = self
        backButton.isHidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showBackButton))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        serial.disconnect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

// MARK - BluetoothSerialDelegate
extension RCGRemoteViewController: BluetoothSerialDelegate {
    
    func serialDidChangeState() {
        if serial.centralManager.state != .poweredOn {
            serial.disconnect()
        }
    }
    
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        
    }
    
    func serialDidReceiveString(_ message: String) {
        print(message.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        self.temperatureLabel.text = message.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) + "°C"
    }
    
}
