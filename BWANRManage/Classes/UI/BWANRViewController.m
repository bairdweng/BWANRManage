//
//  BWANRViewController.m
//  BWANRManage
//
//  Created by bairdweng on 2021/6/2.
//

#import "BWANRViewController.h"
#import "BWANRListViewController.h"
#import "BWMonUtil.h"
#import "BWANRManage.h"
static NSString *cellId = @"DoraemonANRListViewControllerCellID";
@interface BWANRViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *dataSources;

@end

@implementation BWANRViewController
- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	_tableView.frame = self.view.bounds;
}
- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"卡顿检测";
	[self.view addSubview:self.tableView];
	// Do any additional setup after loading the view from its nib.
}
- (NSMutableArray *)dataSources {
	if (!_dataSources) {
		_dataSources = [[NSMutableArray alloc]initWithObjects:@"卡顿检测开关",@"记录",@"清空所有", nil];
	}
	return _dataSources;
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [UITableView new];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		[_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellId];
	}
	return _tableView;
}


#pragma mark tableViewDelegate dataSources
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	if (indexPath.row == 0) {
		NSString *status = [BWMonUtil isOn] ? @"已开启":@"未开启";
		NSString *text = [NSString stringWithFormat:@"%@ (%@)",_dataSources[indexPath.row],status];
		cell.textLabel.text = text;
	}
	else {
		cell.textLabel.text = _dataSources[indexPath.row];
	}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataSources.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	switch (indexPath.row) {
	case 0: {
		BOOL isOn = ![BWMonUtil isOn];
		[BWMonUtil saveANRTrackSwitch:isOn];
		[self.tableView reloadData];
		if (isOn) {
			[[BWANRManage sharedInstance] start];
		}
		else {
			[[BWANRManage sharedInstance] stop];
		}
	}
	break;
	case 1: {
		[self openRecord];
	}
	break;
	case 2: {
		[self removieAll];
	}
	default:
		break;
	}
}

- (void)removieAll {
	NSFileManager *fm = [NSFileManager defaultManager];
	[fm removeItemAtPath:[BWMonUtil anrDirectory] error:nil];
}

- (void)openRecord {
	BWANRListViewController *vc = [[BWANRListViewController alloc]init];
	[self.navigationController pushViewController:vc animated:YES];
}

@end
