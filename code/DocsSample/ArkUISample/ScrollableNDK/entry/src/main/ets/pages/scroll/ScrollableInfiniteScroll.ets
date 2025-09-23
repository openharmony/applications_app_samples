import entry from 'libentry.so';
import { NodeContent } from '@kit.ArkUI';

@Component
export struct ScrollableInfiniteScroll {
  private rootSlot: NodeContent = new NodeContent();

  build() {
    NavDestination() {
      Column() {
        ContentSlot(this.rootSlot)
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .title($r('app.string.ScrollableInfiniteScroll_title'))
    .onAppear(() => entry.ScrollableInfiniteScroll(this.rootSlot))
  }
}
