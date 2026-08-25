import { TowerOfHanoi, Disk } from '../engine/hanoi';
import { PegView } from '../view/PegView';

/**
 * 主页面:@State 托管引擎实例,渲染只做转发(spec「单一模块」决策)。
 * 工单 03 静态渲染;点击交互由工单 04 接入。
 */
@Entry
@Component
struct Index {
  @State private game: TowerOfHanoi = new TowerOfHanoi(3);
  // 临时盘数调节:仅为工单 03 在真机上逐档核对 3–8 渲染;开局选择流程由工单 05 替换。
  @State private diskCount: number = 3;

  build() {
    Column({ space: 12 }) {
      Text('汉诺塔')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 16 })

      Row() {
        Text(`盘数 ${this.diskCount}`)
          .fontSize(14)
        Slider({ value: this.diskCount, min: 3, max: 8, step: 1 })
          .layoutWeight(1)
          .onChange((value: number) => {
            let n = Math.round(value);
            if (n !== this.diskCount) {
              this.diskCount = n;
              this.game = new TowerOfHanoi(n); // 拖动即开新局(临时行为)
            }
          })
      }
      .width('92%')

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
    .backgroundColor('#F5F1E8')
  }
}
