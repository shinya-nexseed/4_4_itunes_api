//
//  ViewController.m
//  4_4_itunes_api
//
//  Created by Shinya Hirai on 2015/07/30.
//  Copyright (c) 2015年 Shinya Hirai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSArray *_musicList;
    NSMutableArray *_musicPlay;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    NSString *urlString = @"https://itunes.apple.com/search?term=Taylor+Swift&country=jp&lang=ja_jp&limit=10";
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *error = nil;
    
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    NSLog(@"%@",jsonObject);
    
    _musicList = jsonObject[@"results"];
    
    self.audioPlayer = nil;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _musicList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = _musicList[indexPath.row][@"trackName"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSError *error = nil;
    
    // 音源を取得
    NSURL *url = [NSURL URLWithString:_musicList[indexPath.row][@"previewUrl"]];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    
    // セット
    if (_audioPlayer == nil) {
        // 初期化
        _audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
        
        // エラーの場合
        if (error != nil) {
            NSLog(@"Error = %@",[error localizedDescription]);
        } else {
            // selfをデリゲートに指定
            self.audioPlayer.delegate = self;
            [_musicPlay addObject:self.audioPlayer];
        }
    }
    
    // 再生、停止処理
    if (_audioPlayer.playing) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    } else {
        [_audioPlayer play];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
