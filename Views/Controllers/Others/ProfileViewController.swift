//
//  ProfileViewController.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 10/1/22.
//
import UIKit
import SDWebImage

final class ProfileViewController: UIViewController,
                                   UITableViewDelegate,
                                   UITableViewDataSource {
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.isHidden = true
        view.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return view
    }()
    
    private var models = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        fetchProfile()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchProfile(){
        APICaller.shared.getCurrentUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let model):
                    self?.updateUI(with: model)
                case .failure(let error):
                    print("Profile error \(error.localizedDescription)")
                    self?.failedToGetProfile()
                }
            }
        }
    }
    
    private func updateUI(with model: UserProfile){
        tableView.isHidden = false
        models.append("Full name: \(model.display_name)")
        models.append("User ID:  \(model.id)")
        models.append("Plan:  \(model.product)")
        createTableHeader(with: model.images.first?.url)
        tableView.reloadData()
    }
    
    private func createTableHeader(with string: String?){
        guard let urlString = string, let url = URL(string: urlString) else { return }
        
        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: view.width,
                                              height: view.width/1.5))
        
        let imageSize: CGFloat = headerView.height/2
        let imageView = UIImageView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: imageSize,
                                                  height: imageSize))
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFill
        imageView.sd_setImage(with: url, completed: nil)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageSize/2
        
        tableView.tableHeaderView = headerView
    }
    
    private func failedToGetProfile(){
        let label = UILabel()
        label.text = "Failed to load Profile"
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}
