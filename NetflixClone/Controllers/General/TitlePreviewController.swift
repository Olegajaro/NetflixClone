//
//  TitlePreviewController.swift
//  NetflixClone
//
//  Created by Олег Федоров on 04.03.2022.
//

import UIKit
import WebKit

class TitlePreviewController: UIViewController {

    // MARK: - UIElements
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemRed
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        
        applyConstraints()
    }
    
    // MARK: - Layout UIElements
    private func applyConstraints() {
        
        let webViewConstraints = [
            webView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 250)
        ]
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(
                equalTo: webView.bottomAnchor, constant: 20
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 20
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -20
            )
        ]
        
        let overviewLabelConstraints = [
            overviewLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor, constant: 16
            ),
            overviewLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 20
            ),
            overviewLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -20
            )
        ]
        
        let downloadButtonConstraints = [
            downloadButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            downloadButton.topAnchor.constraint(
                equalTo: overviewLabel.bottomAnchor, constant: 24
            ),
            downloadButton.widthAnchor.constraint(
                equalToConstant: view.frame.size.width / 4
            ),
            downloadButton.heightAnchor.constraint(equalToConstant: 32)
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    // MARK: - Configure
    func configure(with model: TitlePreviewViewModel) {
        titleLabel.text = model.title
        overviewLabel.text = model.titleOverview
        
        guard
            let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeVideo.id.videoId)")
        else { return }
        
        webView.load(URLRequest(url: url))
    }
}
