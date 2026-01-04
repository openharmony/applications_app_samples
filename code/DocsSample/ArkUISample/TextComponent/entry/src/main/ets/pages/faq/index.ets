// xxx.ets
@Entry
@Component
struct PatternLockExample {
  @State passwords: number[] = [];
  @State message: string = 'please input password!';
  private patternLockController: PatternLockController = new PatternLockController();

  build() {
    Column() {
      Text(this.message).textAlign(TextAlign.Center).margin(20).fontSize(20)
      PatternLock(this.patternLockController)
        .sideLength(200)
        .circleRadius(9)
        .pathStrokeWidth(5)
        .activeColor('#707070')
        .selectedColor('#707070')
        .pathColor('#707070')
        .backgroundColor('#F5F5F5')
        .autoReset(true)
        .onDotConnect((index: number) => {
          console.info('onDotConnect index: ' + index);
        })
    }.width('100%').height('100%')
  }
}