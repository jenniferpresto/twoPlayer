class Player {
    boolean mIsActive;
    boolean mDidUpdatePlayer;
    float mRad = 50 * displayDensity;
    PVector mPos;
    color mCol;
    int mScore;
    Integer mTouchId;
    Integer mPlayerId;
    


    Player() {
        mIsActive = false;
        mDidUpdatePlayer = false;
        mPos = new PVector();
        mScore = 0;
        mTouchId = null;
    }

    void setColor(color c) {
        mCol = c;
    }

    void setIsActive(boolean a) { mIsActive = a; }
    boolean getIsActive() { return mIsActive; }

    void setDidUpdatePlayer(boolean u) { mDidUpdatePlayer = u; }
    boolean getDidUpdatePlayer() { return mDidUpdatePlayer; }

    void setTouchId(Integer id) { mTouchId = id; }
    Integer getTouchId() { return mTouchId; }

    void setPlayerId(Integer id) { mPlayerId = id; }
    Integer getPlayerId() { return mPlayerId; }

    PVector getPos() { return mPos; }
    void setPos(float x, float y) {
        mPos.set(x, y);
    }
    
    int getScore() { return mScore; }
    void setScore(int score) { mScore = score; }

    boolean doesHitBall(Ball b) {
        float touchDist = mRad + b.getRadius();
        PVector diff = PVector.sub(b.getPos(), mPos);
        float magSq = diff.magSq();
        if (magSq < (touchDist * touchDist)) {
            b.setLabel(b.getLabel() + 1);
            return true;
        }
        return false;
    }

    void draw() {
        if (mPos == null || mIsActive == false) {
            return;
        }

        fill(mCol);
        circle(mPos.x, mPos.y, mRad);
        fill(0, 0, 100);
        text(mScore, mPos.x, mPos.y);
    }
}
