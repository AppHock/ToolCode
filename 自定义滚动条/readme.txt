- (CRPSlideIndicator *)slideIndicator {
    if (!_slideIndicator) {
        CRPSlideIndicatorConfig *config = [CRPSlideIndicatorConfig creationCenterSlideConfig];
        config.width = CMKidsIsiPad  ? CRPCCPadDynamicValue(9) : 6;
        config.height = CMKidsIsiPad ? (shortSideWidth - CRPPadDynamicValue(292)) : (shortSideWidth - CRPCCDynamicValue(140));
        self.slideIndicator = [[CRPSlideIndicator alloc] initWithConfig:config];
    }
    return _slideIndicator;
}

用法

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.CCView.slideIndicator scrollViewRelativeDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.CCView.slideIndicator stopScroll];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self.CCView.slideIndicator stopScroll];
}



- (void)reloadDataUI {
    [self.CCView.collectionView reloadData];
    self.CCView.slideIndicator.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.CCView.slideIndicator refreshIndicatorHeightWithScrollView:self.CCView.collectionView];
    });
}

