/**
 * 胜利覆盖层组件 —— 半透明遮罩 + 结算面板。
 *
 * 职责:展示胜利信息、步数对比、"再来一局"按钮。
 * 动画由 UI 层驱动(animateTo),本组件只负责展示。
 */
@Component
export struct VictoryOverlay {
  @Prop won: boolean = false;
  @Prop moveCount: number = 0;
  @Prop minMoves: number = 0;
  @Prop cheerScale: number = 1;
  onRestart: () => void = () => {};

  build() {
    Column({ space: 16 }) {
      Text('🎉')
        .fontSize(64)
        .scale({ x: this.cheerScale, y: this.cheerScale })

      Text('胜利!')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor('#5D4037')

      Text(`本局步数 ${this.moveCount} / 最少步数 ${this.minMoves}`)
        .fontSize(18)
        .fontColor('#666666')

      Text(this.moveCount === this.minMoves ? '最优解,完美!' : `距离最优还差 ${this.moveCount - this.minMoves} 步`)
        .fontSize(14)
        .fontColor('#8D6E63')

      Button('再来一局')
        .type(ButtonType.Normal)
        .width(160)
        .height(44)
        .fontSize(16)
        .backgroundColor('#5D4037')
        .fontColor('#FFFFFF')
        .borderRadius(22)
        .onClick(() => this.onRestart())
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
    .backgroundColor('rgba(0,0,0,0.45)')
    .opacity(this.won ? 1 : 0)
    .scale({ x: this.won ? 1 : 0.6, y: this.won ? 1 : 0.6 })
    .animation({ duration: 450, curve: Curve.EaseOut })
    .hitTestBehavior(this.won ? HitTestMode.Default : HitTestMode.None)
  }
}
