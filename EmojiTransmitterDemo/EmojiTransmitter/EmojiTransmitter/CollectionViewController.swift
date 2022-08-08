//
//  CollectionViewController.swift
//  EmojiTransmitter
//
//  Created by Amit Palo on 06/08/22.
//

import UIKit

final class CollectionViewController: UICollectionViewController {

  // MARK: - Properties
  let emoji = ["😀", "😬", "😁", "😂", "😃", "😄", "😅", "😆", "😇", "😉", "😊", "🙂", "🙃", "☺️", "😋", "😌", "😍", "😘", "😗", "😙", "😚", "😜", "😝", "😛", "🤑", "🤓", "😎", "🤗", "😏", "😶", "😐", "😑", "😒", "🙄", "🤔", "😳", "😞", "😟", "😠", "😡", "😔", "😕", "🙁", "☹️", "😣", "😖", "😫", "😩", "😤", "😮", "😱", "😨", "😰", "😯", "😦", "😧", "😢", "😥", "😪", "😓", "😭", "😵", "😲", "🤐", "😷", "🤒", "🤕", "😴", "💩"]

}

// MARK: - Internal
extension CollectionViewController {

  func selectedEmoji() -> String? {
    guard let selectedIndexPaths = collectionView?.indexPathsForSelectedItems,
      let item = selectedIndexPaths.first?.item else {
      return nil
    }

    return emoji[item]
  }
}

// MARK: - UICollectionViewDataSource
extension CollectionViewController {

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return emoji.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emoji", for: indexPath)
    
    let label = cell.viewWithTag(100) as? UILabel
    label?.text = emoji[indexPath.item]
    
    return cell
  }
}

