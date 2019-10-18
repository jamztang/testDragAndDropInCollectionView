//
//  ViewController.swift
//  testDragAndDropInCollectionView
//
//  Created by James Tang on 18/10/2019.
//  Copyright © 2019 James Tang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    private var items: [String] = (0...5).map { "\($0)" }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        collectionView.dragInteractionEnabled = true
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
    }

    func moveItem(from: IndexPath, to: IndexPath) {
        let item = items[from.item]
        collectionView.performBatchUpdates({
            items.remove(at: from.item)
            items.insert(item, at: to.item)
            collectionView.deleteItems(at: [from])
            collectionView.insertItems(at: [to])
        }, completion: nil)
        print("items \(items)")
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TextCollectionViewCell else {
            return UICollectionViewCell()
        }

        let item = items[indexPath.item]
        cell.text = item
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {

        if collectionView.hasActiveDrag {
            Swift.print(".move \(String(describing: destinationIndexPath))")

            if destinationIndexPath != nil {
                return .init(operation: .move, intent: .insertAtDestinationIndexPath)
            } else {
                // important!! this fixes the issue that after internal drag failed, the next drag and drop will perform incorrectly
                return .init(operation: .move, intent: .unspecified)
            }
        }
        Swift.print(".forbidden \(String(describing: destinationIndexPath))")
        return .init(operation: .forbidden)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        Swift.print("DDD didSelectItem \(item)")
    }
}

extension ViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {

        let item = items[indexPath.item]
        let dragItems = item.map { _ -> UIDragItem in
            let item = UIDragItem(itemProvider: NSItemProvider(object: item as NSString))
            item.localObject = item
            return item
        }
        return dragItems
    }
}

extension ViewController: UICollectionViewDropDelegate {

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {

        let sourceIndexPaths = coordinator.items.compactMap { (item) -> IndexPath? in
            return item.sourceIndexPath
        }
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: items.count - 1, section: 0)

        if coordinator.proposal.operation == .move {
            Swift.print("move item for \(destinationIndexPath)")

            moveItem(from: sourceIndexPaths.first!, to: destinationIndexPath)
        } else {
            Swift.print("move item forbidden")
        }
    }

    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        Swift.print("canHandle session")
        return true
    }
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnter session: UIDropSession) {
        Swift.print("dropSessionDidEnter")
    }
    func collectionView(_ collectionView: UICollectionView, dropSessionDidExit session: UIDropSession) {
        Swift.print("dropSessionDidExit")
    }
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        Swift.print("dropSessionDidEnd")
    }

}

private class DraggableItem: NSObject {
    let item: String

    init(_ item: String) {
        self.item = item
    }
}
