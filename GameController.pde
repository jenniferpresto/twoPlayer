import java.util.Map;
import java.util.HashMap;
import java.util.Iterator;

class GameController {

    Player mPlayer1;
    Player mPlayer2;
    Player[] mPlayers;
    color mPlayer1Col;
    color mPlayer2Col;
    BallController mBallController;
    boolean mIsGameOver;
    ResetGameButton mResetGameButton;

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
    }

    boolean getIsGameOver() { return mIsGameOver; }

    void addPlayer(Integer playerNum, PointF pos) {
        if (playerNum.equals(1)) {
            mPlayer1.setIsActive(true);
            mPlayer1.getPos().set(pos.x, pos.y);
        } else if (playerNum.equals(2)) {
            mPlayer2.setIsActive(true);
            mPlayer2.getPos().set(pos.x, pos.y);
        }
    }

    void reportStartingTouches(List<Integer> startingTouches) {
        for (Player player : mPlayers) {
            if (player.getIsActive()) {
                continue;
            }
            for (Integer touchId : startingTouches) {
                //  make sure touch isn't used by another player
                boolean isInUse = false;
                for (Player otherPlayer : mPlayers) {
                    if (player == otherPlayer) {
                        continue;
                    }
                    if (otherPlayer.getIsActive() &&
                        otherPlayer.getTouchId() != null &&
                        otherPlayer.getTouchId().equals(touchId)) {
                        isInUse = true;
                        continue;
                    }
                }
                if (!isInUse) {
                    player.setTouchId(touchId);
                    player.setIsActive(true);
                }
            }
        }
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

    void updatePlayers() {
        for (Player p : mPlayers) {
            if (!p.getIsActive()) {
                continue;
            }
            for (TouchEvent.Pointer t : touches) {
                if(p.getTouchId().equals(t.id)) {
                    p.setPos(t.x, t.y);
                }
            }
        }
    }
    

    void updatePlayer(Integer playerNum, PointF pos) {
        if (playerNum.equals(1)) {
            if (!mPlayer1.getIsActive()) {
                println("Error: unexpected update on inactive player 1");
                return;
            }
            mPlayer1.setPos(pos.x, pos.y);
        } else if (playerNum.equals(2)) {
            if (!mPlayer2.getIsActive()) {
                println("Error: unexpected update on inactive player 2");
                return;
            }
            mPlayer2.setPos(pos.x, pos.y);
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

    void update() {
        updatePlayers();
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
            mBallController.draw();
            if (mPlayer1.getIsActive()) {
                mPlayer1.draw();
            }
            if (mPlayer2.getIsActive()) {
                mPlayer2.draw();
            }
        }
        fill(0, 0, 100);
        textAlign(LEFT, TOP);
        text("Player 1: " + mPlayer1.getScore(), 5 * displayDensity, 10 * displayDensity);
        text("Player 2: " + mPlayer2.getScore(), 5 * displayDensity, 40 * displayDensity);
        if (mIsGameOver) {
            text("Game Over", 5 * displayDensity, 70 * displayDensity);
        }
    }
}
