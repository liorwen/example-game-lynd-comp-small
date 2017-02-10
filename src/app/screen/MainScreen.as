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

    public class MainScreen extends BaseScreen
    {
        private var _explainBtn:ButtonComponent;
        private var _startBtn:ButtonComponent;
        private var _closeBtn:ButtonComponent;

        public function MainScreen(lynd:Lynd, param:Object)
        {
            param.view = new MainView();
            super(lynd, param);
        }

        override protected function create(param:Object):void
        {
            super.create(param);
            _explainBtn = new ButtonComponent(_lynd, {view: _view.explainBtn, screen: _view});
            _startBtn = new ButtonComponent(_lynd, {view: _view.startBtn, screen: _view});
            _closeBtn = new ButtonComponent(_lynd, {view: _view.closeBtn, screen: _view});
        }

        override protected function added():void
        {
            _explainBtn.startup();
            _startBtn.startup();
            _closeBtn.startup();

            _explainBtn.addEventListener(MouseEvent.CLICK, onExplainBtn);
            _startBtn.addEventListener(MouseEvent.CLICK, onStartBtn);
            _closeBtn.addEventListener(MouseEvent.CLICK, onCloseBtn);
        }

        override protected function removed():void
        {
            _explainBtn.stopup();
            _startBtn.stopup();
            _closeBtn.stopup();

            _explainBtn.removeEventListener(MouseEvent.CLICK, onExplainBtn);
            _startBtn.removeEventListener(MouseEvent.CLICK, onStartBtn);
            _closeBtn.removeEventListener(MouseEvent.CLICK, onCloseBtn);
        }

        private function onExplainBtn(event:MouseEvent):void
        {
            new ClickSound().play();
            store.commit(Types.CHANGE_SCREEN, ExplainScreen);
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
