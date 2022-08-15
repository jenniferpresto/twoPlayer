class GameController {

    Player mPlayer1;
    Player mPlayer2;
    color mPlayer1Col;
    color mPlayer2Col;
    BallController mBallController;
    boolean mIsGameOver;


    GameController() {
        mPlayer1Col = color(177, 71, 88); // aqua
        mPlayer2Col = color(311, 61, 88); // lilac

        mPlayer1 = new Player();
        mPlayer2 = new Player();
        mPlayer1.setColor(mPlayer1Col);
        mPlayer2.setColor(mPlayer2Col);

        mBallController = new BallController();
        mBallController.setup();

        mIsGameOver = false;
    }

    void addPlayer(Integer playerNum, PointF pos) {
        if (playerNum.equals(1)) {
            mPlayer1.setIsActive(true);
            mPlayer1.getPos().set(pos.x, pos.y);
        } else if (playerNum.equals(2)) {
            mPlayer2.setIsActive(true);
            mPlayer2.getPos().set(pos.x, pos.y);
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

    void update() {
        checkGameOver();
        if (mIsGameOver) {
        } else {
            mBallController.update();
            checkCollisions();
        }
    }

    void draw() {
        if (mIsGameOver) {

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