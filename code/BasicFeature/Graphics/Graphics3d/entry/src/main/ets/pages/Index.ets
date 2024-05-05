import router from '@ohos.router';

@Entry
@Component
struct Index {
  onJumpClick(target_url: string, target_id: number): void {
    router.pushUrl({ url: target_url }, router.RouterMode.Single, (err) => {
      if (err) {
        console.error('Invoke pushUrl failed, code is ${err.code}, message is ${err.message}');
        return;
      }
    });
  }

  build() {
    List() {
      ListItem() {
        Button("container")
          .onClick(() => {
            this.onJumpClick('pages/container', 0);
          })
      }
      ListItem() {
        Button("node_base")
          .onClick(() => {
            this.onJumpClick('pages/node_base', 0);
          })
      }
      ListItem() {
        Button("node_camera")
        .onClick(() => {
          this.onJumpClick('pages/node_camera', 0);
        })
      }
      ListItem() {
        Button("node_geometry")
          .onClick(() => {
            this.onJumpClick('pages/node_geometry', 0);
          })
      }
      ListItem() {
        Button("node_light")
          .onClick(() => {
            this.onJumpClick('pages/node_light', 0);
          })
      }

      ListItem() {
        Button("scene_environment")
          .onClick(() => {
            this.onJumpClick('pages/scene_environment', 0);
          })
      }
      ListItem() {
        Button("scene_animation")
          .onClick(() => {
            this.onJumpClick('pages/scene_animation', 0);
          })
      }
      ListItem() {
        Button("scene_shader")
          .onClick(() => {
            this.onJumpClick('pages/scene_shader', 0);
          })
      }
    }.alignListItem(ListItemAlign.Center)
    .width('100%')
    .height('100%')
  }
}
