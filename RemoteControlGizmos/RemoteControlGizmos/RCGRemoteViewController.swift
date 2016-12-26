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
    
    var timer: Timer!
    
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
    
    func repeatTurnLeft() {
        serial.sendMessageToDevice("l")
    }
    
    func repeatTurnRight() {
        serial.sendMessageToDevice("r")
    }
    
    func repeatAccelerate() {
        serial.sendMessageToDevice("a")
    }
    
    func repeatSlowDown() {
        serial.sendMessageToDevice("b")
    }
    
    func stop() {
        serial.sendMessageToDevice("s")
    }

    @IBAction func clickTurnLeftDown(_ sender: UIButton) {
        serial.sendMessageToDevice("l")
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.repeatTurnLeft), userInfo: nil, repeats: true)
    }

    @IBAction func clickTurnLeftUpInside(_ sender: UIButton) {
        timer.invalidate()
        stop()
    }
    
    @IBAction func clickTurnLeftUpOutside(_ sender: UIButton) {
        timer.invalidate()
        stop()
    }
    
    @IBAction func clickTurnRightDown(_ sender: UIButton) {
        serial.sendMessageToDevice("r")
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.repeatTurnRight), userInfo: nil, repeats: true)
    }
    
    @IBAction func clickTurnRightUpInside(_ sender: UIButton) {
        timer.invalidate()
        stop()
    }
    
    @IBAction func clickTurnRightUpOutside(_ sender: UIButton) {
        timer.invalidate()
        stop()
    }
    
    @IBAction func clickAccelerateDown(_ sender: UIButton) {
        serial.sendMessageToDevice("a")
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.repeatAccelerate), userInfo: nil, repeats: true)
    }
    
    @IBAction func clickAccelerateUpInside(_ sender: UIButton) {
        timer.invalidate()
        stop()
    }
    
    @IBAction func clickAccelerateUpOutside(_ sender: UIButton) {
        timer.invalidate()
        stop()
    }
    
    @IBAction func clickSlowDownDown(_ sender: UIButton) {
        serial.sendMessageToDevice("b")
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.repeatSlowDown), userInfo: nil, repeats: true)
    }
    
    @IBAction func clickSlowDownUpInside(_ sender: UIButton) {
        timer.invalidate()
        stop()
    }
    
    @IBAction func clickSlowDownUpOutside(_ sender: UIButton) {
        timer.invalidate()
        stop()
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
