import UIKit
import RxSwift

class HomeArticleHeaderCell: BindableTableViewCell<Article> {
    @IBOutlet weak var imageViewThumb: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imageViewAuthorAvatar: UIImageView!
    @IBOutlet weak var lblAuthorName: UILabel!
    @IBOutlet weak var imageViewBgTitle: UIImageView!
    var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewAuthorAvatar.cornerRadius = imageViewAuthorAvatar.width / 2.0
        imageViewThumb.pin_updateWithProgress = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func bind(data: Article) {
        imageViewBgTitle.isHidden = false
        imageViewThumb.pin_setImage(data.thumbnailImageUrl)
        lblTitle.text = data.title
        let contributer = data.contributor
        lblAuthorName.showContributorDescription(name: contributer?.name, jobTitle: contributer?.jobTitle, affiliation: contributer?.affiliation)
        imageViewAuthorAvatar.pin_setImage(contributer?.imageUrl)
    }
}
