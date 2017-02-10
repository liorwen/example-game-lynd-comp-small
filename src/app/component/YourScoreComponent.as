/**
 * Created by zear19st on 2017/2/7.
 */
package app.component
{
    import app.config.Types;

    import lyndcomp.Lynd;
    import lyndcomp.component.base.Component;

    public class YourScoreComponent extends Component
    {
        public function YourScoreComponent(lynd:Lynd, param:Object)
        {
            super(lynd, param);
        }

        override protected function create(param:Object):void
        {
            _view.buttonMode = false;
            _view.mouseEnabled = false;
        }

        override protected function added():void
        {
            store.addListen(store.state.app.yourScore, onChangeScore);
            store.commit(Types.CLEAR_YOUR_SCORE);
        }

        override protected function removed():void
        {
            store.removeListen(store.state.app.yourScore, onChangeScore);
        }

        private function onChangeScore(score:int):void
        {
            _view.txt.text = score.toString();
        }
    }
}
