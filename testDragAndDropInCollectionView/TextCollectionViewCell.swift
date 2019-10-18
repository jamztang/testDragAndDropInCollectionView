//
//  TextCollectionViewCell.swift
//  testDragAndDropInCollectionView
//
//  Created by James Tang on 18/10/2019.
//  Copyright © 2019 James Tang. All rights reserved.
//

import UIKit

class TextCollectionViewCell: UICollectionViewCell {

    var text: String = "" {
        didSet {
            textLabel.text = text
        }
    }

    @IBOutlet private weak var textLabel: UILabel!


}
