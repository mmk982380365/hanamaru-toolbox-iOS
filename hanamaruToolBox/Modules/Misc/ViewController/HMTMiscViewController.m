//
//  HMTMiscViewController.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/7.
//

#import "HMTMiscViewController.h"

@interface HMTMiscViewController ()

@property (weak, nonatomic) IBOutlet UILabel *youtubeGreetingBeginTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *youtubeGreetingEndTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bilibiliGreetingBeginTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bilibiliGreetingEndTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *youtubeGreetingBeginDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *youtubeGreetingEndDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *bilibiliGreetingBeginDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *bilibiliGreetingEndDetailLabel;

@end

@implementation HMTMiscViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"misc", nil);
    
    self.youtubeGreetingBeginTitleLabel.text = NSLocalizedString(@"youtubeGreetingBeginTitleLabel", nil);
    self.youtubeGreetingEndTitleLabel.text = NSLocalizedString(@"youtubeGreetingEndTitleLabel", nil);
    self.bilibiliGreetingBeginTitleLabel.text = NSLocalizedString(@"bilibiliGreetingBeginTitleLabel", nil);
    self.bilibiliGreetingEndTitleLabel.text = NSLocalizedString(@"bilibiliGreetingEndTitleLabel", nil);
    
    NSString *youtubeGreetingBeginDetail = @"<ul>"
    "<li>今日も来てくたさてありがとうございます！</li>"
    "<li>「こんばんは」の方、こんばんは！</li>"
    "<li>「おはようございます」の方、おはようございます！</li>"
    "<li>「こんにちは」の方、こんにちは！</li>"
    "<li>「お久しぶり」の方、お久しぶりです！</li>"
    "<li>「初めまして」の方、初めまして！</li>"
    "<li>今日も元気に花丸印！花丸はれるです！よろしくお願いします！</li>"
    "</ul>";
    
    NSAttributedString *youtubeGreetingBeginDetailAttributeText = [[NSAttributedString alloc] initWithData:[youtubeGreetingBeginDetail dataUsingEncoding:NSUTF8StringEncoding] options:@{
        NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
        NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
    } documentAttributes:nil error:nil];
    
    self.youtubeGreetingBeginDetailLabel.attributedText = youtubeGreetingBeginDetailAttributeText;
    
    
    NSString *youtubeGreetingEndDetail = @"<ul>"
    "<li>今日も遊びにい来てくださいましてありがとうございました！</li>"
    "<li>コメント、アーカイブのお客さんの感謝</li>"
    "<li>チャンネル登録</li>"
    "<li>グッドマークボタン</li>"
    "<li>「#あっぱれはれるん」タグ</li>"
    "<li>他のお知らせ（予告と宣伝）</li>"
    "<li>スーパーチャット感謝</li>"
    "</ul>";
    
    NSAttributedString *youtubeGreetingEndDetailAttributeText = [[NSAttributedString alloc] initWithData:[youtubeGreetingEndDetail dataUsingEncoding:NSUTF8StringEncoding] options:@{
        NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
        NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
    } documentAttributes:nil error:nil];
    
    self.youtubeGreetingEndDetailLabel.attributedText = youtubeGreetingEndDetailAttributeText;
    
    NSString *bilibiliGreetingBeginDetail = @"<p>早（zǎo）！晚（wǎn）上（shàng）好（hǎo）！大（dà）家（jiā）好（hǎo）！我（wǒ）是（shì）花（huā）丸（wán）！今日も元気に花丸印！花丸はれるです！よろしくお願いします！</p>";
    
    NSAttributedString *bilibiliGreetingBeginDetailAttributeText = [[NSAttributedString alloc] initWithData:[bilibiliGreetingBeginDetail dataUsingEncoding:NSUTF8StringEncoding] options:@{
        NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
        NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
    } documentAttributes:nil error:nil];
    
    self.bilibiliGreetingBeginDetailLabel.attributedText = bilibiliGreetingBeginDetailAttributeText;
    
    NSString *bilibiliGreetingEndDetail = @"<ul>"
    "<li>今日も遊びにい来てくださいましてありがとうございました！</li>"
    "<li>コメント、アーカイブのお客さんの感謝</li>"
    "<li>求（qiú）关（guán）注（zhù）</li>"
    "<li>スーパーチャット、ギフト感謝</li>"
    "<li>船長（せんちょう）、提督（ていとく）、総督（そうとく）の感謝</li>"
    "<li>花丸家バチのみんあの感謝</li>"
    "<li>同時翻訳MANの感謝</li>"
    "<li>次回の配信と歌投稿予告</li>"
    "</ul>";
    
    NSAttributedString *bilibiliGreetingEndDetailAttributeText = [[NSAttributedString alloc] initWithData:[bilibiliGreetingEndDetail dataUsingEncoding:NSUTF8StringEncoding] options:@{
        NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
        NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
    } documentAttributes:nil error:nil];
    
    self.bilibiliGreetingEndDetailLabel.attributedText = bilibiliGreetingEndDetailAttributeText;
    
//    NSString *content = @"<div id=\"misc-panel-greeting\" class=\"misc-frame\">"
//    "        <h3 id=\"misc-youtube-greeting\">Youtube配信あいさつ</h3>"
//    "        <ul>"
//    "            <li>今日も来てくたさてありがとうございます！</li>"
//    "            <li>「こんばんは」の方、こんばんは！</li>"
//    "            <li>「おはようございます」の方、おはようございます！</li>"
//    "            <li>「こんにちは」の方、こんにちは！</li>"
//    "            <li>「お久しぶり」の方、お久しぶりです！</li>"
//    "            <li>「初めまして」の方、初めまして！</li>"
//    "            <li>今日も元気に花丸印！花丸はれるです！よろしくお願いします！</li>"
//    "        </ul>"
//    "        <h3 id=\"misc-youtube-ending\">Youtube配信終了あいさつ</h3>"
//    "        <ul>"
//    "            <li>今日も遊びにい来てくださいましてありがとうございました！</li>"
//    "            <li>コメント、アーカイブのお客さんの感謝</li>"
//    "            <li>チャンネル登録</li>"
//    "            <li>グッドマークボタン</li>"
//    "            <li>「#あっぱれはれるん」タグ</li>"
//    "            <li>他のお知らせ（予告と宣伝）</li>"
//    "            <li>スーパーチャット感謝</li>"
//    "        </ul>"
//    "        <h3 id=\"misc-bilibili-greeting\">BiliBili配信あいさつ</h3>"
//    "        <p><ruby>早<rt>zǎo</rt></ruby>！<ruby>晚<rt>wǎn</rt>上<rt>shàng</rt>好<rt>hǎo</rt></ruby>！<ruby>大<rt>dà</rt>家<rt>jiā</rt>好<rt>hǎo</rt></ruby>！<ruby>我<rt>wǒ</rt>是<rt>shì</rt>花<rt>huā</rt>丸<rt>wán</rt></ruby>！今日も元気に花丸印！花丸はれるです！よろしくお願いします！</p>"
//    "        <h3 id=\"misc-bilibili-ending\">BiliBili配信終了あいさつ</h3>"
//    "        <ul>"
//    "            <li>今日も遊びにい来てくださいましてありがとうございました！</li>"
//    "            <li>コメント、アーカイブのお客さんの感謝</li>"
//    "            <li><ruby>求<rt>qiú</rt>关<rt>guán</rt>注<rt>zhù</rt></ruby></li>"
//    "            <li>スーパーチャット、ギフト感謝</li>"
//    "            <li>船長（せんちょう）、提督（ていとく）、総督（そうとく）の感謝</li>"
//    "            <li>花丸家バチのみんあの感謝</li>"
//    "            <li>同時翻訳MANの感謝</li>"
//    "            <li>次回の配信と歌投稿予告</li>"
//    "        </ul>"
//    "    </div>";
//    NSAttributedString *attributeText = [[NSAttributedString alloc] initWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:@{
//        NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//        NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
//    } documentAttributes:nil error:nil];
//
//    self.textView.attributedText = attributeText;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
