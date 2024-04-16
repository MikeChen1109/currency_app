//
//  ViewController.swift
//  CurrencyApp
//
//  Created by 逸唐陳 on 2023/6/4.
//

import UIKit
import SnapKit
import Combine

class CurrencyController: UIViewController {
    private let topInputView: TopInputView = {
        let view = TopInputView()
        return view
    }()
    
    private let gridView: GridView = {
        let view = GridView()
        return view
    }()
    
    private var viewModel: ExchangeRateViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        bind()
    }
    
    private func setupView() {
        view.addSubview(topInputView)
        topInputView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(155)
        }
        view.addSubview(gridView)
        gridView.snp.makeConstraints { make in
            make.top.equalTo(topInputView.snp.bottom)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setupViewModel() {
        let userDefaultsStorageService = UserDefaultsStorageService()
        let networkService = NetworkService()
        let exchangeRateService = ExchangeRateService(networkService: networkService, storageService: userDefaultsStorageService)
//        viewModel = ExchangeRateViewModel(exchangeRateService: TestExchangeRateService())
        viewModel = ExchangeRateViewModel(exchangeRateService: exchangeRateService)
    }
    
    private func bind() {
        let input = ExchangeRateViewModel.Input(
            baseCurrency: topInputView.currencyPublisher,
            amount: topInputView.amountPublisher)
        
        let output = viewModel.transform(input: input)
        output.exchangeRates.sink { [weak self] exchangeRates in
            self?.gridView.exchangeRates = exchangeRates
            self?.topInputView.currencies = exchangeRates.map { $0.currency }
            DispatchQueue.main.async {
                self?.gridView.collectionView.reloadData()
            }
        }.store(in: &cancellables)
    }
}


