//
//  IGFeedPostGeneralTableViewCell.swift
//  Instagram
//
//  Created by user216341 on 4/28/22.
//

import UIKit

class IGFeedPostGeneralTableViewCell: UITableViewCell {

    static let identifier = "IGFeedPostGeneralTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //contentView.backgroundColor = .systemOrange
        contentView.addSubview(commentLabel)

    }
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.text = "Ce postare frumix"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: PostComment){
        commentLabel.text = model.text
        commentLabel.text = "O ce nice"
     

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        commentLabel.frame = CGRect (x: 5, y: 0, width: contentView.width, height: 20)

    }
}
