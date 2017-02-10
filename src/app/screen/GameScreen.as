/**
 * Created by zear19st on 2017/2/6.
 */
package app.screen
{
    import app.component.BestScoreComponent;
    import app.component.ClockComponent;
    import app.component.YourScoreComponent;
    import app.component.movement.base.MovementComponent;
    import app.component.movement.base.GameManager;
    import app.config.Types;
    import app.screen.base.BaseScreen;

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;
    import flash.utils.clearInterval;
    import flash.utils.getTimer;
    import flash.utils.setInterval;
    import flash.utils.setTimeout;

    import lyndcomp.Lynd;
    import lyndcomp.component.ButtonComponent;

    public class GameScreen extends BaseScreen
    {
        private const WILL_START:String = "GameScreen.WillStart";
        private const START:String = "GameScreen.Start";
        private const End:String = "GameScreen.End";

        private const totalTime:int = 20000;

        private var _closeBtn:ButtonComponent;
        private var _soundOffBtn:ButtonComponent;
        private var _soundOnBtn:ButtonComponent;
        private var _clock:ClockComponent;
        private var _bestScore:BestScoreComponent;
        private var _yourScore:YourScoreComponent;
        private var _bgSound:Sound;
        private var _bgChannel:SoundChannel;
        private var _isTimeupSound:Boolean;

        public function GameScreen(lynd:Lynd, param:Object)
        {
            param.view = new GameView();
            super(lynd, param);
        }

        override protected function create(param:Object):void
        {
            super.create(param);
            _soundOffBtn = new ButtonComponent(_lynd, {view: _view.soundOffBtn, screen: _view});
            _soundOnBtn = new ButtonComponent(_lynd, {view: _view.soundOnBtn, screen: _view});
            _closeBtn = new ButtonComponent(_lynd, {view: _view.closeBtn, screen: _view});
            _clock = new ClockComponent(_lynd, {view: _view.clock, screen: _view});
            _bestScore = new BestScoreComponent(_lynd, {view: _view.bestScore, screen: _view});
            _yourScore = new YourScoreComponent(_lynd, {view: _view.yourScore, screen: _view});
        }

        override protected function added():void
        {
            _soundOffBtn.startup();
            _soundOnBtn.startup();
            _closeBtn.startup();
            _clock.startup();
            _bestScore.startup();
            _yourScore.startup();

            _soundOffBtn.addEventListener(MouseEvent.CLICK, onSoundOffBtn);
            _soundOnBtn.addEventListener(MouseEvent.CLICK, onSoundOnBtn);
            _closeBtn.addEventListener(MouseEvent.CLICK, onCloseBtn);

            _state.addState(WILL_START, willStartInState, willStartOutState);
            _state.addState(START, startInState, startOutState);
            _state.addState(End, endInState, endOutState);

            store.addListen(store.state.app.isSound, onSoundOpen);
            store.trigger(store.state.app.isSound);

            state = WILL_START;
        }

        override protected function removed():void
        {

            _soundOffBtn.removeEventListener(MouseEvent.CLICK, onSoundOffBtn);
            _soundOnBtn.removeEventListener(MouseEvent.CLICK, onSoundOnBtn);
            _closeBtn.removeEventListener(MouseEvent.CLICK, onCloseBtn);


            store.removeListen(store.state.app.isSound, onSoundOpen);

            _soundOffBtn.stopup();
            _soundOnBtn.stopup();
            _closeBtn.stopup();
            _clock.stopup();
            _bestScore.stopup();
            _yourScore.stopup();

            _state.clearState();
            if (_bgChannel != null)
                _bgChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
        }


        private function onSoundOpen(isOpen:Boolean):void
        {
            _soundOffBtn.visible = isOpen;
            _soundOnBtn.visible = !isOpen;

            if (_bgChannel != null)
            {
                var volume:Number = isOpen ? 1 : 0;
                var soundTransform:SoundTransform = _bgChannel.soundTransform;
                soundTransform.volume = volume;
                _bgChannel.soundTransform = soundTransform;
            }
        }

        private function onSoundOffBtn(event:MouseEvent):void
        {
            store.commit(Types.SOUND_OPEN, false);
        }

        private function onSoundOnBtn(event:MouseEvent):void
        {
            store.commit(Types.SOUND_OPEN, true);
        }

        private function onCloseBtn(event:MouseEvent):void
        {
            new ClickSound().play();
            if (_lynd.extra.canBeUsed())
                _lynd.extra.exit();
        }

        private function willStartInState():void
        {
            _isTimeupSound = false;
            bgSoundStart();
            GameManager.getInstance().init();
            store.commit(Types.CHANGE_CLOCK, totalTime);
            store.commit(Types.CLEAR_YOUR_SCORE);
            store.commit(Types.GAME_FLAG, false);
            store.trigger(store.state.app.bestTime);
            setTimeout(function ():void
            {
                state = START;
            }, 1000);
        }

        private function willStartOutState():void
        {

        }

        private function startInState():void
        {
            var startTime:Number = getTimer();
            var nowTime:Number;
            var subTime:Number;
            var resultTime:Number;
            store.addListen(store.state.app.pushCraft, onPushCraft);
            store.commit(Types.GAME_FLAG, true);
            trace("start game");
            trace("---------------------------------");
            GameManager.getInstance().selectQuest();
            var saveId:uint = setInterval(function ():void
            {
                nowTime = getTimer();
                subTime = nowTime - startTime;
                resultTime = totalTime - subTime;
                if (resultTime <= 5000 && !_isTimeupSound)
                {
                    _isTimeupSound = true;
                    new TimeupSound().play();
                }
                if (resultTime > 0)
                    store.commit(Types.CHANGE_CLOCK, resultTime);
                else
                {
                    store.commit(Types.CHANGE_CLOCK, 0);
                    clearInterval(saveId);
                    state = End;
                }
            }, 10);

            var count:int = 5;
            store.commit(Types.START_QUEST, false);
            var check:int = 1 + int(String(5 * Math.random()).split(".")[0]);
            var pushCraftId:uint = setInterval(function ():void
            {
                if (count > 0)
                {
                    if (count == check)
                        store.commit(Types.START_QUEST, true);
                    store.trigger(store.state.app.pushCraft);
                }
                else
                    clearInterval(pushCraftId);
                count--;
            }, 300);
//            for (var i:int = 0 ; i < 5; i++)
//            {
//                store.trigger(store.state.app.pushCraft);
//            }

            var pushMeteorId:uint = setInterval(function ():void
            {
                if (resultTime > 0)
                    pushMeteor();
                else
                    clearInterval(pushMeteorId);
            }, int(totalTime / 4));

        }

        private function onPushCraft(isPush:Boolean):void
        {
            if (!store.state.app.isGame.value)
                return;
            if (GameManager.getInstance().getShowNum() >= 5)
                return;
            var craft:MovementComponent = GameManager.getInstance().getMovement(_lynd, _view.screen);
            craft.startup();

        }

        private function pushMeteor():void
        {
            var meteor:MovementComponent = GameManager.getInstance().getMeteor(_lynd, _view.screen);
            meteor.startup();
        }

        private function startOutState():void
        {
            store.removeListen(store.state.app.pushCraft, onPushCraft);
        }

        private function endInState():void
        {
            store.commit(Types.GAME_FLAG, false);
            trace("---------------------------------");
            setTimeout(function ():void
            {
                store.trigger(store.state.app.clear);
                if (_bgChannel != null)
                {
                    _bgChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
                    _bgChannel.stop();
                    _bgChannel = null;
                }

                if (store.state.app.yourScore.value > store.state.app.bestScore.value)
                {
                    store.commit(Types.CHANGE_BEST_SCORE, store.state.app.yourScore.value);
                    store.commit(Types.CHANGE_SCREEN, WinScreen);
                }
                else
                    store.commit(Types.CHANGE_SCREEN, LoseScreen);
            }, 1000);

        }

        private function endOutState():void
        {

        }

        private function bgSoundStart():void
        {
            _bgSound = new BgSound()
            _bgChannel = _bgSound.play();
            _bgChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
            var soundTransform:SoundTransform = _bgChannel.soundTransform;
            var volume:Number = store.state.app.isSound.value ? 1 : 0;
            soundTransform.volume = volume;
            _bgChannel.soundTransform = soundTransform;
        }

        private function onSoundComplete(event:Event):void
        {
            _bgChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
            _bgChannel = _bgSound.play();
            _bgChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
        }
    }
}
