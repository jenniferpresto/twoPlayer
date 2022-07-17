class Ball {
    color mCol;
    float mRad;
    PVector mPos;
    PVector mVel;

    Ball() {

    }

    void setColor(color c) {
        mCol = c;
    }

    float getRadius() { return mRad; }
    void setRadius(float r) { mRad = r * displayDensity; }

    PVector getPos() { return mPos; }
    void setPos(PVector p) { mPos = p; }

    PVector getVel() { return mVel; }
    void setVel(PVector v) { mVel = v; }

    void update() {

    }

    void draw() {
        fill(mCol);
        circle(mPos.x, mPos.y, mRad);
    }
}