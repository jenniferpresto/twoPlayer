class Player {
    float mRad = 50 * displayDensity;
    PVector mPos;
    color mCol;

    Player() {
        mPos = null;
    }

    void setColor(color c) {
        mCol = c;
    }

    void setPos(PVector p) {
        mPos = p;
    }

    void draw() {
        if (mPos == null) {
            return;
        }

        fill(mCol);
        circle(mPos.x, mPos.y, mRad);
    }
}