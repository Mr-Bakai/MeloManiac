//
//  SettingsViewController.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 17/1/22.
//
import UIKit

final class SettingsViewController: UIViewController,
                                    UITableViewDataSource,
                                    UITableViewDelegate {
    
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.register(UITableViewCell.self,
                      forCellReuseIdentifier: "cell")
        return view
    }()
    
    private var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        title = "Settings"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func configureModels(){
        sections.append(Section(title: "Settings", options: [Option(title: "View Your Profile", hanler: { [weak self] in
            DispatchQueue.main.async {
                self?.viewProfile()
            }
        })]))
        
        sections.append(Section(title: "Account", options: [Option(title: "Sign Out", hanler: { [weak self] in
            DispatchQueue.main.async {
                self?.signOutTapped()
            }
        })]))
    }
    
    private func signOutTapped(){
        
    }
    
    private func viewProfile(){
        let vc = ProfileViewController()
        vc.title = "ProfileViewController"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].options[indexPath.row]
        model.hanler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = sections[section]
        return model.title
    }
}
