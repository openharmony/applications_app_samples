import emitter from '@ohos.events.emitter';  //4.1和5.0引用不一样

@Component
export  struct textBtn  {
  @Link ifFocus:string;
   text:string='移动';
   focusItem:string='move';

  build() {
    Row() {
      Text(this.text)
        .fontColor(this.ifFocus === this.focusItem ? 'rgba(0, 0, 0, 0.86)' : 'rgba(255, 255, 255, 0.86)')
        .backgroundColor(this.ifFocus === this.focusItem ? 'rgba(255,255,255,0.86)' : 'rgba(255,255,255,0.2)')//.width('50%')
        .focusable(true)
        .fontSize('36lpx')
        .width( '248lpx')
        .height( '72lpx')
        .borderRadius( '36lpx')
        .textAlign(TextAlign.Center)
        .defaultFocus(true)
        .id(this.focusItem)
        .onAppear(()=>{
          focusControl.requestFocus(this.focusItem)
        })
        .onClick(() => {
          emitter.emit(this.focusItem)
        })
        .onFocus(() => {
          this.ifFocus = this.focusItem
        })
    }.padding('5lpx')
    .border({
      radius: '40lpx',
      color: this.ifFocus === this.focusItem ? Color.White : '',
      width: this.ifFocus === this.focusItem ? '2lpx' : 0,
    })
  }
}