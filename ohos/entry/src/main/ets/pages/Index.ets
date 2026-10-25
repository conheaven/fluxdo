import webview from '@ohos.web.webview';

interface TabItem {
  title: string;
  symbol: Resource;
  url: string;
}

@Entry
@Component
struct Index {
  @State selectedTab: number = 0;
  @State visitedTabs: string = '0';
  @State loading: boolean = true;
  @State errorText: string = '';
  private readonly controllers: webview.WebviewController[] = [
    new webview.WebviewController(),
    new webview.WebviewController(),
    new webview.WebviewController(),
    new webview.WebviewController()
  ];
  private readonly tabs: TabItem[] = [
    { title: '首页', symbol: $r('sys.symbol.house'), url: 'https://linux.do/' },
    { title: '最新', symbol: $r('sys.symbol.clock'), url: 'https://linux.do/latest' },
    { title: '通知', symbol: $r('sys.symbol.bell'), url: 'https://linux.do/my/notifications' },
    { title: '我的', symbol: $r('sys.symbol.person'), url: 'https://linux.do/my/activity' }
  ];

  private selectTab(index: number): void {
    if (index === this.selectedTab) {
      return;
    }
    this.selectedTab = index;
    this.loading = !this.visitedTabs.includes(index.toString());
    this.errorText = '';
    if (!this.visitedTabs.includes(index.toString())) {
      this.visitedTabs += index.toString();
    } else if (index >= 2) {
      // Recheck the signed-in routes after the user logs in on another tab.
      this.controllers[index].loadUrl(this.tabs[index].url);
    }
  }

  private reload(): void {
    this.loading = true;
    this.errorText = '';
    this.controllers[this.selectedTab].refresh();
  }

  private goBack(): void {
    const controller: webview.WebviewController = this.controllers[this.selectedTab];
    if (controller.accessBackward()) {
      controller.backward();
    }
  }

  onBackPress(): boolean {
    const controller: webview.WebviewController = this.controllers[this.selectedTab];
    if (controller.accessBackward()) {
      controller.backward();
      return true;
    }
    if (this.selectedTab !== 0) {
      this.selectTab(0);
      return true;
    }
    return false;
  }

  build(): void {
    Column() {
      Row({ space: 8 }) {
        Button('‹')
          .fontSize(27)
          .fontColor('#24282D')
          .backgroundColor(Color.Transparent)
          .width(36)
          .height(40)
          .onClick(() => this.goBack())
        Text('cfluxdo')
          .fontSize(19)
          .fontWeight(FontWeight.Bold)
          .fontColor('#24282D')
          .layoutWeight(1)
        Text(this.tabs[this.selectedTab].title)
          .fontSize(13)
          .fontColor('#5E6770')
        Button('刷新')
          .fontSize(13)
          .fontColor('#24282D')
          .backgroundColor(Color.Transparent)
          .width(68)
          .height(40)
          .onClick(() => this.reload())
      }
      .width('100%')
      .height(48)
      .padding({ left: 8, right: 8 })
      .backgroundColor('#FFFFFF')

      Stack() {
        ForEach(this.tabs, (item: TabItem, index: number) => {
          if (this.visitedTabs.includes(index.toString())) {
            Web({ src: item.url, controller: this.controllers[index] })
              .width('100%')
              .height('100%')
              .visibility(this.selectedTab === index ? Visibility.Visible : Visibility.Hidden)
              .javaScriptAccess(true)
              .domStorageAccess(true)
              .databaseAccess(true)
              .onPageBegin(() => {
                if (this.selectedTab === index) {
                  this.loading = true;
                  this.errorText = '';
                }
              })
              .onPageEnd(() => {
                if (this.selectedTab === index) {
                  this.loading = false;
                }
              })
              .onErrorReceive((event) => {
                if (this.selectedTab === index && event?.request?.isMainFrame()) {
                  this.loading = false;
                  this.errorText = event?.error?.getErrorInfo() ?? '网络暂时不可用';
                }
              })
          }
        }, (item: TabItem) => item.url)
        if (this.loading) {
          LoadingProgress()
            .width(32)
            .height(32)
            .color('#F2A900')
        }
        if (this.errorText.length > 0) {
          Column({ space: 12 }) {
            Text('页面加载失败')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
            Text(this.errorText)
              .fontSize(13)
              .fontColor('#5E6770')
              .textAlign(TextAlign.Center)
            Button('重新加载')
              .fontColor('#1C1C1E')
              .backgroundColor('#FFB003')
              .onClick(() => this.reload())
          }
          .padding(24)
          .backgroundColor('#FFFFFF')
          .borderRadius(8)
        }
      }
      .layoutWeight(1)
      .width('100%')
      .backgroundColor('#F4F5F6')

      Row() {
        ForEach(this.tabs, (item: TabItem, index: number) => {
          Column({ space: 2 }) {
            SymbolGlyph(item.symbol)
              .fontSize(22)
              .fontColor([this.selectedTab === index ? '#1C1C1E' : '#747B83'])
            Text(item.title)
              .fontSize(11)
              .fontColor(this.selectedTab === index ? '#1C1C1E' : '#747B83')
          }
          .layoutWeight(1)
          .height(54)
          .justifyContent(FlexAlign.Center)
          .onClick(() => this.selectTab(index))
        }, (item: TabItem) => item.url)
      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .border({ width: { top: 1 }, color: '#E3E5E8' })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
