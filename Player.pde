class Player {
    float mRad = 50 * displayDensity;
    PVector mPos;
    color mCol;
    int mScore;

    Player() {
        mPos = null;
    }

    void setColor(color c) {
        mCol = c;
    }

    void setPos(PVector p) {
        mPos = p;
    }
    
    int getScore() { return mScore; }
    void setScore(int score) { mScore = score; }

    void checkBall(Ball b) {
        float touchDist = mRad + b.getRadius();
        PVector diff = PVector.sub(b.getPos(), mPos);
        float magSq = diff.magSq();
        if (magSq < (touchDist * touchDist)) {
            b.setLabel(b.getLabel() + 1);
        }
    }

    void draw() {
        if (mPos == null) {
            return;
        }

        fill(mCol);
        circle(mPos.x, mPos.y, mRad);
    }
}
