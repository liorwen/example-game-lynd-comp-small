/**
 * Created by zear19st on 2017/2/6.
 */
package app.store
{
    import app.config.Types;

    import lyndcomp.store.StoreModule;
    import lyndcomp.store.state.StoreState;

    public class AppStore extends StoreModule
    {
        public function AppStore()
        {
            super();
            state = {
                screen: null,
                bestScore: 0,
                yourScore: 0,
                clock: 0,
                isGame: false,
                clear: true,
                pushCraft: true,
                isSound: true,
                isStartQuest: false
            };
            mutation[Types.CHANGE_SCREEN] = changeScreen;
            mutation[Types.SOUND_OPEN] = soundOpen;
            mutation[Types.ADD_YOUR_SCORE] = addYourScore;
            mutation[Types.CLEAR_YOUR_SCORE] = clearYourScore;
            mutation[Types.CHANGE_BEST_SCORE] = changeBestScore;
            mutation[Types.CHANGE_CLOCK] = changeClock;
            mutation[Types.CLEAR_CLOCK] = clearClock;
            mutation[Types.GAME_FLAG] = gameFLAG;
            mutation[Types.START_QUEST] = startQuest;
        }

        private function changeScreen(state:StoreState, screen:Class):void
        {
            state.screen = screen;
        }

        private function soundOpen(state:StoreState, isOpen:Boolean):void
        {
            state.isSound = isOpen;
        }

        private function addYourScore(state:StoreState, point:int):void
        {
            var v:int = state.yourScore.value;
            v += point;
            if (v < 0)
                v = 0
            state.yourScore.value = v;
        }

        private function clearYourScore(state:StoreState):void
        {
            state.yourScore = 0;
        }

        private function changeBestScore(state:StoreState, point:int):void
        {
            state.bestScore = point;
        }

        private function changeClock(state:StoreState, clock:Number):void
        {
            state.clock = clock;
        }

        private function clearClock(state:StoreState):void
        {
            state.clock = -1;
        }

        private function gameFLAG(state:StoreState, isGame:Boolean):void
        {
            state.isGame = isGame;
        }

        private function startQuest(state:StoreState, isStart:Boolean):void
        {
            state.isStartQuest = isStart;
        }
    }
}
