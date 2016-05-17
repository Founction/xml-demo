//
//  ViewController.m
//  xml 解析
//
//  Created by 李胜营 on 16/5/16.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "ViewController.h"
#import "LYVideo.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import <MediaPlayer/MediaPlayer.h>


@interface ViewController ()<NSXMLParserDelegate>
/* videos */
@property (strong, nonatomic) NSMutableArray * videos;

@end

@implementation ViewController
- (NSMutableArray *)videos
{
    if (_videos == nil)
    {
        _videos = [NSMutableArray  array];
    }
    return _videos;

}
- (void)viewDidLoad {
    [super viewDidLoad];

    //1创建路径
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/video?type=XML"];
    //创建请求对象
    NSURLRequest *request = [NSURLRequest  requestWithURL:url];
    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
     
        //xml解析
        //创建NSXMLParser
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        parser.delegate = self;
        
        [parser parse];
        
        [self.tableView reloadData];
    }];
    
}
#pragma mark <NSXMLParserDelegate>
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    if ([elementName isEqualToString:@"videos"])  return;
    
    
    
    LYVideo *video = [LYVideo mj_objectWithKeyValues:attributeDict];
    
    [self.videos addObject:video];
    
}
#pragma mark tableview 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.videos.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    LYVideo *video = self.videos[indexPath.row];
    cell.textLabel.text = video.name;
    NSString *image = [@"http://120.25.226.186:32812" stringByAppendingPathComponent:video.image];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

//    LYVideo *video = self.videos[indexPath.row];
//    NSString *urlStr = [@"http://120.25.226.186:32812" stringByAppendingPathComponent:video.url];
//    
//    // 创建视频播放器
//    MPMoviePlayerViewController *vc = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:urlStr]];
//    
//    // 显示视频
//    [self presentViewController:vc animated:YES completion:nil];
    
        LYVideo *video = self.videos[indexPath.row];
    
    NSString *urlStr = [@"http://120.25.226.186:32812" stringByAppendingPathComponent:video.url];
    
    MPMoviePlayerViewController *vc = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:urlStr]];
    
    [self presentViewController:vc animated:YES completion:nil];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
