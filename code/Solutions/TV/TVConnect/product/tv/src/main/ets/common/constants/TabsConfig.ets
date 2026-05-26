import { TabItem } from '../bean/TabItem';

export default class TabConfig {
  public static tabItems: TabItem[] = [
    new TabItem(0, $r('app.string.tab_scan'), $r('app.media.ic_item_scan_activated'), $r('app.media.ic_item_scan')),
    new TabItem(1, $r('app.string.tab_personal'), $r('app.media.ic_item_personal_activated'),
      $r('app.media.ic_item_personal')),
  ];
};