//
//  UpcomingTableViewCell.swift
//  NetflixClone
//
//  Created by Олег Федоров on 03.03.2022.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    static let identifier = "UpcomingTableViewCell"
    
    private let titlePosterUIImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let playTitleButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(
            systemName: "play.circle",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)
        )
        button.setImage(image, for: .normal)
        button.tintColor = .systemRed
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titlePosterUIImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitleButton)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: TitleViewModel) {
        guard
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterURL)")
        else { return }
        titlePosterUIImageView.sd_setImage(with: url)
        
        titleLabel.text = model.titleName
    }
    
    private func applyConstraints() {
        let titlePosterUIImageViewConstraints = [
            titlePosterUIImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            titlePosterUIImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: 4
            ),
            titlePosterUIImageView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -4
            ),
            titlePosterUIImageView.widthAnchor.constraint(
                equalToConstant: 100
            )
        ]
        
        let titleLabelConstraints = [
            titleLabel.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: titlePosterUIImageView.trailingAnchor, constant: 16
            )
        ]
        
        let playTitleButtonConstraints = [
            playTitleButton.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            playTitleButton.leadingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor, constant: 16
            ),
            playTitleButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -16
            ),
            playTitleButton.widthAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(titlePosterUIImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(playTitleButtonConstraints)
    }
}
