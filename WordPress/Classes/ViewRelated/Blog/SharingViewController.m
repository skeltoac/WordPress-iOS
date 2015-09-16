#import "SharingViewController.h"
#import "Blog.h"
#import "WPTableViewCell.h"
#import "WPTableViewSectionHeaderFooterView.h"
#import "Publicizer.h"
#import "Sharer.h"

NS_ENUM(NSInteger, SharingSection) {
    SharingPublicize = 0,
    SharingButtons,
    SharingSectionCount,
};

static NSString *const PublicizeCellIdentifier = @"PublicizeCell";
static NSString *const ButtonsCellIdentifier = @"ButtonsCell";

@interface SharingViewController ()

@property (nonatomic, strong, readonly) Blog *blog;
@property (nonatomic, strong) NSArray *publicizeServices;
@property (nonatomic, strong) NSArray *buttonServices;

@end

@implementation SharingViewController

- (instancetype)initWithBlog:(Blog *)blog
{
    NSParameterAssert([blog isKindOfClass:[Blog class]]);
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _blog = blog;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = NSLocalizedString(@"Sharing", @"Title for blog detail sharing screen.");

    [WPStyleGuide configureColorsForView:self.view andTableView:self.tableView];
    [self.tableView registerClass:[WPTableViewCell class] forCellReuseIdentifier:PublicizeCellIdentifier];
    [self.tableView registerClass:[WPTableViewCell class] forCellReuseIdentifier:ButtonsCellIdentifier];

    self.publicizeServices = [self.blog.publicizers sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:TRUE]]];
    self.buttonServices = [self.blog.sharers sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:TRUE]]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SharingSectionCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case SharingPublicize:
            return NSLocalizedString(@"Publicize", @"Section title for Publicize services in Sharing screen");
        case SharingButtons:
            return NSLocalizedString(@"Sharing Buttons", @"Section title for Sharer (button) services in Sharing screen");
        default:
            return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = [self tableView:self.tableView titleForHeaderInSection:section];
    if (title.length > 0) {
        WPTableViewSectionHeaderFooterView *header = [[WPTableViewSectionHeaderFooterView alloc] initWithReuseIdentifier:nil style:WPTableViewSectionStyleHeader];
        header.title = title;
        return header;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case SharingPublicize:
            return self.publicizeServices.count;
        case SharingButtons:
            return self.buttonServices.count;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PublicizeCellIdentifier forIndexPath:indexPath];
    [WPStyleGuide configureTableViewCell:cell];

    switch (indexPath.section) {
        case SharingPublicize: {
            Publicizer *publicizer = self.publicizeServices[indexPath.row];
            cell.textLabel.text = publicizer.label;
            } break;
        case SharingButtons: {
            Sharer *sharer = self.buttonServices[indexPath.row];
            cell.textLabel.text = sharer.name;
        } break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
