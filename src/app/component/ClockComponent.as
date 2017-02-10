/**
 * Created by zear19st on 2017/2/6.
 */
package app.component
{
    import app.config.Types;

    import flash.display.InteractiveObject;

    import flash.text.TextField;

    import flash.text.TextFormat;

    import lyndcomp.Lynd;
    import lyndcomp.component.base.Component;
    import lyndcomp.store.state.StateObject;

    public class ClockComponent extends Component
    {
        public function ClockComponent(lynd:Lynd, param:Object)
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
            store.addListen(store.state.app.clock, onChangeClock);
            store.commit(Types.CLEAR_CLOCK);
        }

        override protected function removed():void
        {
            store.removeListen(store.state.app.clock, onChangeClock);
        }

        private function onChangeClock(clock:Number):void
        {
            var tf:TextFormat = new TextFormat();
            if (clock > 5000)
            {
                tf.color = 0;
            }
            else if (clock <= 5000)
            {
                tf.color = 0xcc0000;
            }

            _view.txt.defaultTextFormat = tf;

            if (clock >= 0)
                _view.txt.text = transferTime(clock);
            else
                _view.txt.text = "";
        }

        private function transferTime(clock:Number):String
        {
            var miniSec:Number = clock % 1000;
            var sec:Number = (clock - miniSec) / 1000;
            miniSec = (miniSec - miniSec % 10) / 10;

            return correctZero(sec.toString()) + ":" + correctZero(miniSec.toString());
        }

        private function correctZero(num:String):String
        {
            if (num.length < 2)
                num = "0" + num;
            return num;
        }

    }
}
