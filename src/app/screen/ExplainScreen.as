/**
 * Created by zear19st on 2017/2/6.
 */
package app.screen
{
    import app.config.Types;
    import app.screen.base.BaseScreen;

    import flash.events.MouseEvent;

    import lyndcomp.Lynd;
    import lyndcomp.component.ButtonComponent;

    public class ExplainScreen extends BaseScreen
    {
        private var _startBtn:ButtonComponent;
        private var _closeBtn:ButtonComponent;

        public function ExplainScreen(lynd:Lynd, param:Object)
        {
            param.view = new ExplainView();
            super(lynd, param);
        }

        override protected function create(param:Object):void
        {
            super.create(param);
            _startBtn = new ButtonComponent(_lynd, {view: _view.startBtn, screen: _view});
            _closeBtn = new ButtonComponent(_lynd, {view: _view.closeBtn, screen: _view});
        }

        override protected function added():void
        {
            _startBtn.startup();
            _closeBtn.startup();

            _startBtn.addEventListener(MouseEvent.CLICK, onStartBtn);
            _closeBtn.addEventListener(MouseEvent.CLICK, onCloseBtn);
        }

        override protected function removed():void
        {
            _startBtn.stopup();
            _closeBtn.stopup();

            _startBtn.removeEventListener(MouseEvent.CLICK, onStartBtn);
            _closeBtn.removeEventListener(MouseEvent.CLICK, onCloseBtn);
        }

        private function onStartBtn(event:MouseEvent):void
        {
            new ClickSound().play();
            store.commit(Types.CHANGE_SCREEN, GameScreen);
        }

        private function onCloseBtn(event:MouseEvent):void
        {
            new ClickSound().play();
            if (_lynd.extra.canBeUsed())
                _lynd.extra.exit();
        }
    }
}
