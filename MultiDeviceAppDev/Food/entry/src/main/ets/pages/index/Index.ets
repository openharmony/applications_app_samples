import { Menus } from './Menus'
import { Content } from './Content'
import { Related } from './Related'
import { Sidebar } from './Sidebar'
import { Contact } from './Contact'

@Entry
@Component
struct Index {
  @State contentH: number = 50
  @State currBp: string = 'sm'

  build() {
    Scroll() {
      Column() {
        // part1:menus
        Menus()
        GridRow() {
          // part2:content area which includes introduction for vegetables
          GridCol({ span: { xs: 12, sm: 12, md: 9, lg: 6 } }) {
            Content()
              .onAreaChange((oldValue: Area, newValue: Area) => {
                this.contentH = newValue.height as number
              })
          }
          // part3:Relevant description
          GridCol({ span: { xs: 12, sm: 12, md: 3, lg: 2 } }) {
            Related({ relatedCurrBp: this.currBp })
              .height((this.currBp !== 'xs' && this.currBp !== 'sm') ? this.contentH : 50)
          }
          // part4:external links
          GridCol({ span: { xs: 12, sm: 12, md: 12, lg: 4 } }) {
            Sidebar({ sidebarCurrBp: this.currBp })
              .height((this.currBp !== 'lg') ? 100 : this.contentH)
          }
          // part5:contact us
          GridCol({ span: { xs: 12, sm: 12, md: 12, lg: 12 } }) {
            Contact().height(80)
          }
        }.onBreakpointChange((breakpoint) => {
          this.currBp = breakpoint
        })
      }.margin(10)
    }
  }
}