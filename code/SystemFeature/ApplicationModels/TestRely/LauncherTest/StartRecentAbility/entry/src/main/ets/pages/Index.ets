import systemDateTime from '@ohos.systemDateTime';
import { Logger } from '../logger/Logger';

@Entry
@Component
struct Index {
  @State message: string = 'UIAbility1'
  @State date1: string = '--:--:--'
  @State date2: string = '--:--:--'
  @State date3: string = '--:--:--'
  private context

  build() {
    Row() {
      Column() {
        Text(this.date1)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .id("date1")
        Text(this.date2)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button("StartUIAbility")
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.context.startAbility({
              bundleName: "com.acts.startresentability",
              abilityName: "EntryAbility",
            }).then(() => {
              Logger.debug("startAbility successful");
            }).catch((err) => {
              Logger.debug("startAbility failed");
            })
          })
          .id("date2")
        Button("StartUIAbility2")
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.context.startAbility({
              bundleName: "com.acts.startresentability",
              abilityName: "SecondAbility",
            }).then(() => {
              Logger.debug("EntryAbility startAbility successful.");
            }).catch((err) => {
              Logger.debug("EntryAbility startAbility dailed.");
            })
          })
          .id("StartUIAbility2")
        Text(this.date3)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .id("date3")
      }
      .width('100%')
    }
    .height('100%')
  }

  aboutToAppear() {
    this.context = getContext(this) as any
    systemDateTime.getDate().then((date) => {
      let dateStr = JSON.stringify(date);
      this.date3 = dateStr;
      this.date1 = dateStr.substr(1, dateStr.indexOf('T') - 1);
      this.date2 = dateStr.substr(dateStr.indexOf('T') + 1, dateStr.length - (dateStr.indexOf('T') + 1) -2);
    });
  }
}