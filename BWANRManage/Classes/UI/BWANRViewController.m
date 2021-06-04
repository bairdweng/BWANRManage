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

@property(nonatomic, strong) UIView *headerView;

@property(nonatomic, strong) UILabel *titleLabel;

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
	self.tableView.tableHeaderView = self.headerView;
	// Do any additional setup after loading the view from its nib.
}

#pragma mark Getter
- (NSMutableArray *)dataSources {
	if (!_dataSources) {
		_dataSources = [[NSMutableArray alloc]initWithObjects:@"卡顿检测开关",@"记录",@"清空所有",@"关闭面板",nil];
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

- (UIView *)headerView {
	if (!_headerView) {
		CGFloat headerViewHeight = 60;
		_headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, headerViewHeight)];
		CGFloat labelWidth = 80;
		CGFloat labelX = 15;

		CGFloat sliderX = labelWidth + 10 + labelX;

		// 显示的文字
		double threShold = [BWMonUtil sharedInstance].threshold;
		[_headerView addSubview:self.titleLabel];
		self.titleLabel.frame = CGRectMake(labelX, 10, labelWidth, 20);
		self.titleLabel.font = [UIFont systemFontOfSize:12];
		self.titleLabel.textAlignment = NSTextAlignmentLeft;
		self.titleLabel.text = [NSString stringWithFormat:@"阀值:%.fms",threShold * 1000];

		// 滑动
		UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(sliderX, 10, self.view.bounds.size.width - sliderX, 20)];
		[slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
		slider.value = [BWMonUtil sharedInstance].threshold;
		[_headerView addSubview:slider];

		// 说明
		UILabel *desLabel = [UILabel new];
		desLabel.font = [UIFont systemFontOfSize:10];
		desLabel.textColor = [UIColor grayColor];
		desLabel.textAlignment = NSTextAlignmentLeft;
		desLabel.text = @"设置卡顿时间为多少时，会记录堆栈数据，最低为200ms";
		[_headerView addSubview:desLabel];
		desLabel.frame = CGRectMake(labelX, headerViewHeight - 20, self.view.bounds.size.width - labelX, 20);
	}
	return _headerView;
}


- (void)sliderValueChange:(UISlider *)slider {
	[[BWMonUtil sharedInstance] setThreshold:slider.value];
	double timer = slider.value;
	if (timer < 0.2) {
		timer = 0.2;
	}
	else if (timer > 1) {
		timer = 1;
	}
	else {}
	slider.value = timer;
	self.titleLabel.text = [NSString stringWithFormat:@"阀值:%.fms",timer * 1000];
	[BWMonUtil setThresholdTime:timer];
}

- (UILabel *)titleLabel {
	if (!_titleLabel) {
		_titleLabel = [UILabel new];
		_titleLabel.font = [UIFont systemFontOfSize:14];
		_titleLabel.textColor = [UIColor grayColor];
	}
	return _titleLabel;
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
	break;
	case 3: {
		[[BWANRManage sharedInstance]dissShow];
	}
	break;
	default:
		break;
	}
}

- (void)removieAll {
	self.title = @"记录已删除";
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		self.title = @"卡顿检测";
	});
	NSFileManager *fm = [NSFileManager defaultManager];
	[fm removeItemAtPath:[BWMonUtil anrDirectory] error:nil];
}

- (void)openRecord {
	BWANRListViewController *vc = [[BWANRListViewController alloc]init];
	[self.navigationController pushViewController:vc animated:YES];
}

@end
