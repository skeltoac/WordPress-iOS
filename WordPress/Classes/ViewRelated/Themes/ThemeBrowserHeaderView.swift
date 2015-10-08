import UIKit

public class ThemeBrowserHeaderView: UICollectionReusableView {
        
    // MARK: - Constants

    public static let reuseIdentifier = "ThemeBrowserHeaderView"

    // MARK: - Outlets

    @IBOutlet weak var currentThemeLabel: UILabel!
    @IBOutlet weak var currentThemeName: UILabel!
    
    // MARK: - Properties

    private var theme: Theme? {
        didSet {
            currentThemeName.text = theme?.name
        }
    }
        
    // MARK: - Additional initialization
    
    public func configureWithTheme(theme: Theme?) {
        self.theme = theme
    }
    
    // MARK: - GUI

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        currentThemeLabel.textColor = WPStyleGuide.greyDarken20()
        currentThemeLabel.font = WPStyleGuide.tableviewSectionHeaderFont()
        currentThemeName.textColor = WPStyleGuide.darkGrey()
        currentThemeName.font = WPStyleGuide.regularTextFontSemiBold()
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        theme = nil
    }

}
