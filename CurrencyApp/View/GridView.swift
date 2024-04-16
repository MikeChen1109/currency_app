//
//  GridView.swift
//  CurrencyApp
//
//  Created by 逸唐陳 on 2023/6/5.
//

import UIKit

class GridView: UIView {
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.registerCell(CurrencyCell.self)
        collectionView.backgroundColor = .white
        collectionView.accessibilityIdentifier = "currencyCollectionView"
        return collectionView
    }()
    
    var exchangeRates = [RateModel]()
    private let itemSpacing: CGFloat = 10.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.bottom.equalTo(self)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

extension GridView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CurrencyCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.rate = exchangeRates[indexPath.row]
        cell.accessibilityIdentifier = "Cell_\(indexPath.row)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exchangeRates.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension GridView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = itemSpacing * 2
        let itemWidth = (collectionView.bounds.width - spacing) / 3.0
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
}


class CurrencyCell: UICollectionViewCell {
    private let title: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.accessibilityIdentifier = "currencyTitle"
        return label
    }()
    
    private let conversion: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        //ellipsis
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        return stackView
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    var rate: RateModel! {
        didSet {
            title.text = rate.currency
            conversion.text = String(rate.rate)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        verticalStackView.addArrangedSubview(title)
        verticalStackView.addArrangedSubview(conversion)
        stackView.addArrangedSubview(verticalStackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
