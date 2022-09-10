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
    TouchController mTouchController;


    GameController(TouchController tc) {
        mTouchController = tc;
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

    }

    void reportEndingTouches(List<Integer> endingTouches) {

    }

    void updatePlayers() {
        if (mTouchController == null) return;
        Map<Integer, PointF> activePointers = mTouchController.getActivePointers();

        //  set each player's didUpdate to false
        for (Player p : mPlayers) {
            p.setDidUpdatePlayer(false);
        }
        for (int i = 0; i < touches.length; i++) {
            println("Touch " + i + "-- ");
            println("\tid: " + touches[i].id);
            println("\t   (" + touches[i].x + "," + touches[i].y + ")");
            println("\tarea: " + touches[i].area);
            println("\tpressure: " + touches[i].pressure);
        }

        //  iterate through all active pointers
        // println(frameCount + ": Number of pointers: " + activePointers.size());
        Iterator<Map.Entry<Integer, PointF>> it = activePointers.entrySet().iterator();
        while(it.hasNext()) {
            Map.Entry<Integer, PointF> pointer = it.next();
            boolean foundPointer = false;
            //  check active players to update
            for (Player p : mPlayers) {
                if (!p.getIsActive()) { continue; }
                if(pointer.getKey().equals(p.getTouchId())) {
                    p.setPos(pointer.getValue().x, pointer.getValue().y);
                    p.setDidUpdatePlayer(true);
                    foundPointer = true;
                    break;
                }
            }

            //  if we didn't use that pointer, see if there are inactive players
            if (foundPointer == false) {
                for (Player p : mPlayers) {
                    if (!p.getIsActive()) {
                        println("adding new player: player " + p.getPlayerId());
                        p.setDidUpdatePlayer(true);
                        p.setTouchId(pointer.getKey());
                        p.setPos(pointer.getValue().x, pointer.getValue().y);
                        p.setIsActive(true);
                        break;
                    }
                }
            }
        }

   //     //  if there are players that don't have active pointers any more,
    //     //  mark the player inactive
    //     for (Player p : mPlayers) {
    //         if (p.getIsActive() && !p.getDidUpdatePlayer()) {
    //             println("Removing player: " + p.getPlayerId());
    //             p.setIsActive(false);
    //         }
    //     }
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
        mPlayer1.setIsActive(false);
        mPlayer2.setIsActive(false);
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
