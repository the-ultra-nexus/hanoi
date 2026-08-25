import { TowerOfHanoi, Disk } from '../engine/hanoi';
import { PegView } from '../view/PegView';

/**
 * 主页面:@State 托管引擎实例,渲染只做转发(spec「单一模块」决策)。
 * 工单 05:启动时显示盘数选择,选择后进入游戏;游戏中可重开回选择。
 */
@Entry
@Component
struct Index {
  @State private selectingDiskCount: boolean = true;
  @State private diskCount: number = 3;
  @State private game: TowerOfHanoi = new TowerOfHanoi(3);

  /** 选择盘数并开局 */
  private startGame(n: number) {
    this.diskCount = n;
    this.game = new TowerOfHanoi(n);
    this.selectingDiskCount = false;
  }

  /** 重开:回到盘数选择 */
  private restart() {
    this.selectingDiskCount = true;
  }

  build() {
    Column() {
      if (this.selectingDiskCount) {
        this.SelectionScreen()
      } else {
        this.GameScreen()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F1E8')
  }

  /** 盘数选择界面:3–8 六个按钮 */
  @Builder SelectionScreen() {
    Column({ space: 20 }) {
      Text('汉诺塔')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 40 })

      Text('选择圆盘数量')
        .fontSize(16)
        .fontColor('#666666')

      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        ForEach([3, 4, 5, 6, 7, 8], (n: number) => {
          Button(`${n}`)
            .type(ButtonType.Normal)
            .width(64)
            .height(64)
            .borderRadius(32)
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .backgroundColor('#5D4037')
            .fontColor('#FFFFFF')
            .margin(8)
            .onClick(() => this.startGame(n))
        }, (n: number) => `btn-${n}`)
      }
      .width('80%')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }

  /** 游戏界面:棋面 + 重开按钮 */
  @Builder GameScreen() {
    Column({ space: 12 }) {
      // 顶部栏:标题 + 重开按钮
      Row() {
        Text('汉诺塔')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Blank()

        Button('重新开始')
          .type(ButtonType.Normal)
          .fontSize(14)
          .height(36)
          .backgroundColor('#8D6E63')
          .fontColor('#FFFFFF')
          .borderRadius(18)
          .onClick(() => this.restart())
      }
      .width('92%')
      .padding({ top: 12 })

      Text(`盘数: ${this.diskCount}`)
        .fontSize(14)
        .fontColor('#666666')

      // 棋面:三根柱。ForEach 的 key 带各柱圆盘序列,状态变化时精确重绘。
      Row({ space: 10 }) {
        ForEach(this.game.pegs, (peg: Disk[], pegIndex: number) => {
          PegView({ disks: peg })
        }, (peg: Disk[], pegIndex: number) => `${pegIndex}:${peg.map(disk => disk.size).join(',')}`)
      }
      .layoutWeight(1)
      .alignItems(VerticalAlign.Bottom)
    }
    .width('100%')
    .height('100%')
  }
}
