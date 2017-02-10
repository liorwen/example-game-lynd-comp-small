/**
 * Created by zear19st on 2017/2/6.
 */
package app
{
    import app.config.Question;
    import app.config.Types;
    import app.screen.ExplainScreen;
    import app.screen.GameScreen;
    import app.screen.LoseScreen;
    import app.screen.MainScreen;
    import app.screen.WinScreen;

    import lyndcomp.Lynd;
    import lyndcomp.component.AppComponent;

    public class App extends AppComponent
    {
        private var _mainScreen:MainScreen;
        private var _explainScreen:ExplainScreen;
        private var _gameScreen:GameScreen;
        private var _winScreen:WinScreen;
        private var _loseScreen:LoseScreen;

        public function App(lynd:Lynd)
        {
            super(lynd);
        }

        override protected function create(param:Object):void
        {
            if (_lynd.extra.canBeUsed())
                _lynd.extra.fullScreen(true);
            var check:Boolean = Question.addQuestion(_lynd);
            if (!check)
                return;
            _mainScreen = new MainScreen(_lynd, {screen: _view});
            _explainScreen = new ExplainScreen(_lynd, {screen: _view});
            _gameScreen = new GameScreen(_lynd, {screen: _view});
            _winScreen = new WinScreen(_lynd, {screen: _view});
            _loseScreen = new LoseScreen(_lynd, {screen: _view});
        }

        override protected function added():void
        {
            store.commit(Types.CHANGE_SCREEN, MainScreen);
        }
    }
}
