import java.util.Map;
import java.util.HashMap;
import java.util.Iterator;

class GameController {
    final static float PLAYER_HOME_HEIGHT_PCT = 0.15;

    Player mPlayer1;
    Player mPlayer2;
    Player[] mPlayers;
    color mPlayer1Col;
    color mPlayer2Col;
    BallController mBallController;
    boolean mIsGameOver;
    ResetGameButton mResetGameButton;
    final float mBoundaryTop;
    final float mBoundaryBottom;

    GameController() {
        mPlayer1Col = color(177, 71, 88); // aqua
        mPlayer2Col = color(311, 61, 88); // lilac

        mPlayers = new Player[2];

        mPlayer1 = new Player();
        mPlayer1.setPlayerId(1);
        
        mPlayer2 = new Player();
        mPlayer2.setPlayerId(2);
        mPlayers[0] = mPlayer1;
        mPlayers[1] = mPlayer2;
        mPlayer1.setColor(mPlayer1Col);
        mPlayer2.setColor(mPlayer2Col);

        mBallController = new BallController();
        mBallController.setup();

        mResetGameButton = new ResetGameButton();

        mIsGameOver = false;
        mBoundaryTop = height * PLAYER_HOME_HEIGHT_PCT;
        mBoundaryBottom = height - (height * PLAYER_HOME_HEIGHT_PCT);
    }

    boolean getIsGameOver() { return mIsGameOver; }

    void addPlayer(int playerNum, int touchId, float x, float y ) {
        int playerIndex = playerNum - 1;
        if (playerIndex < 0 || playerIndex > mPlayers.length - 1) {
            print("This is weird");
            return;
        }
        Player player = mPlayers[playerIndex];
        player.setIsActive(true);
        player.getPos().set(x, y);
        player.setTouchId(touchId);
    }

    void reportStartingTouches(List<Integer> startingTouches, Map<Integer, PointF> allActiveTouches) {
        for (Integer touchId : startingTouches) {

            if (touchIsInUse(touchId)) {
                println("Touch is in use");
                continue;
            }

            PointF startingTouch = allActiveTouches.get(touchId);
            if (startingTouch == null) {
                println("Error, starting touch not in list of touches");
                continue;
            }
            if (startingTouch.y < mBoundaryTop) {
                print("This is a player 1 touch!");
                if (mPlayer1.getIsActive()) {
                    continue;
                } else {
                    addPlayer(1, touchId, startingTouch.x, startingTouch.y);
                }
            } else if (startingTouch.y > mBoundaryBottom) {
                print("This is a player 2 touch!");
                if (mPlayer2.getIsActive()) {
                    continue;
                } else {
                    addPlayer(2, touchId, startingTouch.x, startingTouch.y);
                }
            } else {
                println("Outside the boundaries");
            }
        }
    }

    boolean touchIsInUse(Integer touchId) {
        for (Player p : mPlayers) {
            if (p.getIsActive()) {
                if (p.getTouchId().equals(touchId)) {
                    return true;
                }
            }
        }
        return false;
    }

    void reportEndingTouches(List<Integer> endingTouches) {
        for (int i = 0; i < endingTouches.size(); i++) {
            for (int j = 0; j < mPlayers.length; j++) {
                if(endingTouches.get(i).equals(mPlayers[j].getTouchId())) {
                    mPlayers[j].setIsActive(false);
                }
            }
        }
    }

    void updatePlayers(Map<Integer, PointF> activeTouches) {
        for (Player p : mPlayers) {
            if (!p.getIsActive()) {
                continue;
            }
            PointF point = activeTouches.get(p.getTouchId());
            if (point == null) {
                println("Error, updating player's touch ID does not exist");
                continue;
            }
            p.setPos(point.x, point.y);
            // for (TouchEvent.Pointer t : touches) {
            //     if(p.getTouchId().equals(t.id)) {
            //         p.setPos(t.x, t.y);
            //     }
            // }
        }
    }
    
    void removePlayer(Integer playerNum) {
        if (playerNum.equals(1)) {
            mPlayer1.setIsActive(false);
        } else if (playerNum.equals(2)) {
            mPlayer2.setIsActive(false);
        }
    }

    void checkCollisions() {
        //  collision check
        ArrayList<Ball> ballsToBeRemoved = new ArrayList<Ball>();
        for (Ball b : mBallController.getBalls()) {
            if (mPlayer1.getIsActive()) {
                if (mPlayer1.doesHitBall(b)) {
                    mPlayer1.setScore(mPlayer1.getScore() + 1);
                    ballsToBeRemoved.add(b);
                }
            }
            if (mPlayer2.getIsActive()) {
                if (mPlayer2.doesHitBall(b)) {
                    mPlayer2.setScore(mPlayer2.getScore() + 1);
                    if (!ballsToBeRemoved.contains(b)) {
                        ballsToBeRemoved.add(b);
                    }
                }
            }
        }

        //  do this separately so both players can get
        //  credit for a ball they hit at the same time
        for(Ball b : ballsToBeRemoved) {
            mBallController.getBalls().remove(b);
        }
    }

    void checkGameOver() {
        if (mBallController.getBalls().size() < 1) {
            mIsGameOver = true;
        }
    }

    boolean clickIsInButton(PVector pos) {
        return mResetGameButton.posIsInside(pos);
    }

    void resetGame() {
        mBallController.setup();
        for (Player p : mPlayers) {
            p.setIsActive(false);
            p.setScore(0);
        }
        mIsGameOver = false;
        println("Game controller has reset game");
    }

    void update(Map<Integer, PointF> activeTouches) {
        updatePlayers(activeTouches);
        checkGameOver();
        if (mIsGameOver) {
        } else {
            mBallController.update();
            checkCollisions();
        }
    }

    void draw() {
        if (mIsGameOver) {
            mResetGameButton.draw();
        } else {
            stroke(164, 88, 19);
            line(0, mBoundaryTop, width, mBoundaryTop);
            line(0, mBoundaryBottom, width, mBoundaryBottom);
            mBallController.draw();
            if (mPlayer1.getIsActive()) {
                mPlayer1.draw();
            }
            if (mPlayer2.getIsActive()) {
                mPlayer2.draw();
            }
        }
        fill(167, 88, 19);
        textAlign(LEFT, TOP);
        text("Player 1: " + mPlayer1.getScore(), 5 * displayDensity, 10 * displayDensity);
        text("Player 2: " + mPlayer2.getScore(), 5 * displayDensity, 40 * displayDensity);
        if (mIsGameOver) {
            text("Game Over", 5 * displayDensity, 70 * displayDensity);
        }
    }
}
