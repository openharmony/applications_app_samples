@Component
export struct cursorImage {
  @Prop arrowXPos: number
  ifOpacity: boolean = false
  image: string = 'app.media.left'
  rowOrColumn:boolean = true
  ifForward:boolean = true
  build() {
    Image($r(this.image))
      .width(this.rowOrColumn?'24lpx':'48lpx')
      .height(this.rowOrColumn?'48lpx':'24lpx')
      .zIndex(99)
      .onAppear(() => {
        this.arrowXPos = 10
      })
      .translate({
        x: `${this.rowOrColumn?(this.ifForward?this.arrowXPos:-this.arrowXPos):0}lpx`,
        y: `${this.rowOrColumn?0:(this.ifForward?this.arrowXPos:-this.arrowXPos)}lpx`
      })
      .animation({
        duration: 1000,
        iterations: -1,

        playMode: PlayMode.AlternateReverse,
        curve: Curve.Linear
      })
      .autoResize(true)
      .visibility(this.ifOpacity ?Visibility.Visible : Visibility.Hidden)
  }
}