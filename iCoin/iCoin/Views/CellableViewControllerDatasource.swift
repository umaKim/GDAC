//
//  CellableViewControllerDatasource.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/23.
//
import Combine
import ModernRIBs
import UIKit

final class CellableViewControllerDatasource: NSObject {
    private var cellableViews: [ViewControllable] = []
    var view: UIView?
    private(set) lazy var contentsOffsetPublisher = contentsOffsetSubject.eraseToAnyPublisher()
    private var contentsOffsetSubject = PassthroughSubject<CGPoint, Never>()
    func appendCellableView(_ viewControllerable: ViewControllable) {
        cellableViews.append(viewControllerable)
    }
}

extension CellableViewControllerDatasource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellableViews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CellableViewCell.identifier,
                for: indexPath
            ) as? CellableViewCell
        else { return UICollectionViewCell() }
        cell.configure(with: cellableViews[indexPath.item].uiviewController.view)
        return cell
    }
}

extension CellableViewControllerDatasource: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let view = view else { return .init() }
        return CGSize(
            width: view.frame.width,
            height: collectionView.frame.height
        )
    }
}

extension CellableViewControllerDatasource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentsOffsetSubject.send(scrollView.contentOffset)
    }
}
