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
        mPos.add(mVel);
    }
    
    void draw() {
        fill(mCol);
        ellipse(mPos.x, mPos.y, mRad, mRad);
        fill(0);
        ellipse(mPos.x, mPos.y, 5, 5);
    }
    
    void collideWalls() {
        if (mPos.x > displayWidth - mRad) {
            mPos.x = displayWidth - mRad;
            mVel.x *= -1;
        } else if (mPos.x < mRad) {
            mPos.x = mRad;
            mVel.x *= -1;
        }
        
        if (mPos.y > displayHeight - mRad) {
            mPos.y = displayHeight - mRad;
            mVel.y *= -1;
        } else if (mPos.y < mRad) {
            mPos.y = mRad;
            mVel.y *= -1;   
        }
    }
}
