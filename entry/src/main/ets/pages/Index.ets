import { storageStatistics } from '@kit.CoreFileKit';

@Entry
@Component
struct StorageExample {
  @State totalText: string = '—';
  @State freeText: string = '—';
  @State bundleText: string = '—';
  @State cacheText: string = '—';
  @State dataText: string = '—';

  aboutToAppear(): void {
    this.totalText = this.formatSize(storageStatistics.getTotalSizeSync());
    this.freeText = this.formatSize(storageStatistics.getFreeSizeSync());

    // Important: Keep async operations separate instead of turning aboutToAppear into an async function
    this.getOwnBundleStats();
  }

  private async getOwnBundleStats(): Promise<void> {
    let bundleStats = await storageStatistics.getCurrentBundleStats();
    this.bundleText = this.formatSize(bundleStats.appSize);
    this.cacheText = this.formatSize(bundleStats.cacheSize);
    this.dataText = this.formatSize(bundleStats.dataSize);
	}

  private formatSize(bytes: number): string {
    if (bytes <= 0) {
      return '0 B';
    }
    const kb = 1024;
    const mb = kb * 1024;
    const gb = mb * 1024;
    if (bytes >= gb) {
      return `${(bytes / gb).toFixed(2)} GB`;
    }
    if (bytes >= mb) {
      return `${(bytes / mb).toFixed(2)} MB`;
    }
    if (bytes >= kb) {
      return `${(bytes / kb).toFixed(1)} KB`;
    }
    return `${bytes} B`;
  }

  build() {
    Column({ space: 8 }) {
      Text(`Built-in storage total: ${this.totalText}`)
      Text(`Built-in storage free: ${this.freeText}`)
      Text(`App installation size: ${this.bundleText}`)
      Text(`App cache size: ${this.cacheText}`)
      Text(`App data size: ${this.dataText}`)
    }
    .margin({top: 12, bottom: 12})
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}