//
//  HealthDataViewController.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import Combine
import UIKit

final class HealthDataViewController: UIViewController {
    private let viewModel: HealthDataViewModel
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UITableViewDiffableDataSource<Int, HealthDataCellViewModel>!
    
    // MARK: - Components
    
    private let healthDataView = HealthDataView()
    
    // MARK: - Init
    
    init(viewModel: HealthDataViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = healthDataView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupHealthDataTableView()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Setup Methods
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemTeal
    }
    
    private func setupHealthDataTableView() {
        dataSource = .init(
            tableView: healthDataTableView,
            cellProvider: { (tableView, indexPath, cellViewModel) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(
                    for: indexPath,
                    cellType: HealthDataCell.self
                )
                cell.configure(with: cellViewModel)
                return cell
        })
    }
    
    private func setupBindings() {
        // state
        viewModel.state.navigationTitle
            .sink { [weak self] title in
                self?.navigationItem.title = title
            }
            .store(in: &cancellables)
        
        viewModel.state.date
            .receive(on: RunLoop.main)
            .sink { [weak self] date in
                self?.dateLabel.text = date.formatAsFullDate()
            }
            .store(in: &cancellables)
        
        viewModel.state.description
            .receive(on: RunLoop.main)
            .sink { [weak self] description in
                self?.descriptionLabel.text = description
            }
            .store(in: &cancellables)
        
        viewModel.state.cellViewModels
            .receive(on: RunLoop.main)
            .sink { [weak self] cellViewModels in
                guard let self = self else { return }
                emptyLabel.isHidden = !cellViewModels.isEmpty
                applySanpshot(with: cellViewModels)
            }
            .store(in: &cancellables)
    }
    
    private func applySanpshot(with healthDataCellViewModels: [HealthDataCellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, HealthDataCellViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(healthDataCellViewModels, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

private extension HealthDataViewController {
    var dateLabel: UILabel {
        healthDataView.dateLabel
    }
    
    var descriptionLabel: UILabel {
        healthDataView.descriptionLabel
    }
    
    var healthDataTableView: UITableView {
        healthDataView.tableView
    }
    
    var emptyLabel: UILabel {
        healthDataView.emptyLabel
    }
}
