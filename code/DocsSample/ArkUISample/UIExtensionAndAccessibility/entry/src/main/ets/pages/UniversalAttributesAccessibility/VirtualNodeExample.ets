//[Start virtual_node_example_start]
@Entry
@Component
struct VirtualNodeExample {
  @Builder customAccessibilityNode() {
    Text($r('app.string.UniversalAttributesAccessibility_text6'))
      .fontSize(50)
      .fontWeight(FontWeight.Bold)
  }
  build() {
    Column() {
      Text($r('app.string.UniversalAttributesAccessibility_text5'))
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
    }
    .accessibilityGroup(true)
    .accessibilityLevel("yes")
    .accessibilityVirtualNode(this.customAccessibilityNode)
  }
}
//[End virtual_node_example_start]

