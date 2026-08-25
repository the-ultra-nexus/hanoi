import { TowerOfHanoi, Disk } from '../engine/hanoi';
import { PegView } from '../view/PegView';

/**
 * 主页面:@State 托管引擎实例,渲染与点击只做转发(spec「单一模块」决策)。
 *
 * 学习点 ②(工单 04):@State 只观测赋值,不深观测引擎内部数组的变异,
 * 所以每次移动后把引擎导出的局面快照重新赋给 pegsView,UI 随之刷新。
 */
@Entry
@Component
struct Index {
  @State private game: TowerOfHanoi = new TowerOfHanoi(3);
  // 渲染快照:引擎局面的拷贝,每次状态变化后整体重新赋值
  @State private pegsView: Disk[][] = [[], [], []];
  // 当前选中的源柱;-1 表示未选中
  @State private selectedPeg: number = -1;
  // 非法移动的可见反馈,短暂显示后清除
  @State private feedback: string = '';
  // 临时盘数调节:仅为逐档核对渲染;开局选择流程由工单 05 替换。
  @State private diskCount: number = 3;

  aboutToAppear(): void {
    this.startNewGame(3);
  }

  private startNewGame(n: number): void {
    this.diskCount = n;
    this.game = new TowerOfHanoi(n);
    this.pegsView = this.game.pegs;
    this.selectedPeg = -1;
    this.feedback = '';
  }

  /** 两步点击:未选中→选中;点同柱→取消;点他柱→尝试移动 */
  private onPegTap(pegIndex: number): void {
    if (this.selectedPeg === -1) {
      this.selectedPeg = pegIndex;
      return;
    }
    if (this.selectedPeg === pegIndex) {
      this.selectedPeg = -1;
      return;
    }
    let moved = this.game.tryMove(this.selectedPeg, pegIndex);
    if (moved) {
      // 合法:局面更新,选择转移到新柱,可连续移动
      this.pegsView = this.game.pegs;
      this.selectedPeg = pegIndex;
      this.feedback = '';
    } else {
      // 非法:局面与选择都不变,给出可见反馈
      this.feedback = '不合法的移动:只能移顶盘,且大盘不能压小盘';
      setTimeout(() => {
        this.feedback = '';
      }, 1500);
    }
  }

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
              this.startNewGame(n); // 拖动即开新局(临时行为)
            }
          })
      }
      .width('92%')

      // 棋面:三根柱。柱子显式展开,选中态随 selectedPeg 刷新。
      Row({ space: 10 }) {
        PegView({ disks: this.pegsView[0], selected: this.selectedPeg === 0 })
          .onClick(() => this.onPegTap(0))
        PegView({ disks: this.pegsView[1], selected: this.selectedPeg === 1 })
          .onClick(() => this.onPegTap(1))
        PegView({ disks: this.pegsView[2], selected: this.selectedPeg === 2 })
          .onClick(() => this.onPegTap(2))
      }
      .layoutWeight(1)
      .alignItems(VerticalAlign.Bottom)

      // 反馈行:固定高度避免布局跳动
      Text(this.feedback)
        .fontSize(14)
        .fontColor('#C62828')
        .height(24)
        .margin({ bottom: 12 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F1E8')
  }
}
