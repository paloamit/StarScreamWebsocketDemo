//
//  UsernameViewController.swift
//  EmojiTransmitter
//
//  Created by Amit Palo on 06/08/22.
//

import UIKit

final class UsernameViewController: UIViewController {

  // MARK: - Properties
  var username = ""

  // MARK: - IBOutlets
  @IBOutlet var nextButtonItem: UIBarButtonItem!

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "usernameSelected",
      let viewController = segue.destination as? ViewController else {
        return
    }

    viewController.username = username
  }
}

// MARK: - IBActions
extension UsernameViewController {

  @IBAction func usernameDidChange(textField: UITextField) {
    guard let text = textField.text else {
      nextButtonItem.isEnabled = false
      username = ""
      return
    }

    nextButtonItem.isEnabled = text.count > 0
    username = text
  }

  @IBAction func websocketDisconnectedUnwind(unwindSegue: UIStoryboardSegue) {
    username = ""
    nextButtonItem.isEnabled = false
  }
}

