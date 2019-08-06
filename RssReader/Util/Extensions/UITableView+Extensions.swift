//
//  UITableView+Extensions.swift
//  RssReader
//
//  Created by 1 on 06/08/2019.
//  Copyright © 2019 makeev. All rights reserved.
//

import UIKit

extension UITableView {
    
    enum UpdateAction {
        case none
        case reload
    }
    
    func processCacheTrackerChange<T>(_ change: CoreDataChangeTransactionBatch<T>, updateCellBlock: ((IndexPath, T)->(UpdateAction))? = nil, moveCellBlock: ((IndexPath, T)->())? = nil, rowAnimation: UITableView.RowAnimation = .fade) {
        self.beginUpdates()
        
        let insertedIndexPaths = change.insertedTransactions.compactMap({$0.newIndexPath})
        if !insertedIndexPaths.isEmpty {
            insertRows(at: insertedIndexPaths, with: rowAnimation)
        }
        
        let deletedPaths = change.deletedTransactions.compactMap({$0.oldIndexPath})
        if !deletedPaths.isEmpty {
            deleteRows(at: deletedPaths, with: rowAnimation)
        }
        
        change.movedTransactions.forEach { (transaction) in
            if let oldIndexPath = transaction.oldIndexPath,
                let newIndexPath = transaction.newIndexPath,
                newIndexPath.row != oldIndexPath.row
            {
                //Note: in case of moving object can be changed and not contained in updatedTransations
                //Note: so we handle such cases in moveCellBlock
                moveCellBlock?(oldIndexPath, transaction.object)
                moveRow(at: oldIndexPath, to: newIndexPath)
            }
        }
        
        //Note: It is wrong to update cells using newIndex, because of newIndex holds value of oldIndex with applied update, so if we updateCell using newIndex cell will display wrong data
        let indexPathsToReload: [IndexPath]
        if let updateCellBlock = updateCellBlock {
            indexPathsToReload = change.updatedTransactions.compactMap { (transaction) -> IndexPath? in
                guard let oldIndexPath = transaction.oldIndexPath else { return nil}
                switch updateCellBlock(oldIndexPath, transaction.object) {
                case .none:
                    return nil
                case .reload:
                    return oldIndexPath
                }
            }
        } else {
            indexPathsToReload = change.updatedTransactions.compactMap({$0.oldIndexPath})
        }
        if !indexPathsToReload.isEmpty {
            reloadRows(at: indexPathsToReload, with: rowAnimation)
        }
        
        self.endUpdates()
    }
}
