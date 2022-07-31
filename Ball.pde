class Ball {
    color mCol;
    float mRad;
    float mMass;
    PVector mPos;
    PVector mVel;
    int mLabel;

    boolean mDidCollideWall;
    boolean mDidCollideBall;
    
    Ball() {
        mPos = new PVector();
        mVel = new PVector();
    }
    
    void setColor(color c) {
        mCol = c;
    }
    
    float getRadius() { return mRad; }
    float getMass() { return mMass; }
    void setRadius(float r) {
        mRad = r * displayDensity;
        mMass = mRad * 0.1;
    }
    
    PVector getPos() { return mPos; }
    void setPos(PVector p) { mPos.set(p); }
    
    PVector getVel() { return mVel; }
    void setVel(PVector v) { mVel.set(v); }
    
    int getLabel() { return mLabel; }
    void setLabel(int label) { mLabel = label; }

    boolean getDidCollideBall() { return mDidCollideBall; }
    
    void update() {
        setColor(color(100, 100, 100));
        mDidCollideWall = false;
        mDidCollideBall = false;
        mPos.add(mVel);
    }
    
    void draw() {
        fill(mCol);
        ellipse(mPos.x, mPos.y, mRad, mRad);
        fill(0);
        ellipse(mPos.x, mPos.y, 5, 5);
        fill(0, 0, 100);
        text(mLabel, mPos.x, mPos.y);
    }
    
    void collideWalls() {
        if (mPos.x > displayWidth - mRad) {
            mDidCollideWall = true;
            mPos.x = displayWidth - mRad;
            mVel.x *= -1;
        } else if (mPos.x < mRad) {
            mDidCollideWall = true;
            mPos.x = mRad;
            mVel.x *= -1;
        }
        
        if (mPos.y > displayHeight - mRad) {
            mDidCollideWall = true;
            mPos.y = displayHeight - mRad;
            mVel.y *= -1;
        } else if (mPos.y < mRad) {
            mDidCollideWall = true;
            mPos.y = mRad;
            mVel.y *= -1;   
        }
    }
    
    void collideOtherBall(Ball other) {
        float touching = this.getRadius() + other.getRadius();
        float dist = dist(this.getPos().x, this.getPos().y, other.getPos().x, other.getPos().y);
        if (dist >= touching) {
            return;
        }
        setColor(color(360, 100, 100));
        PVector delta = PVector.sub(getPos(), other.getPos());
        float d = delta.mag();
        
        //  minimum translation distance to push balls apart
        PVector mtd = PVector.mult(delta, ((getRadius() + other.getRadius()) - d) / d);

        //  resolve intersection
        //  inverse mass quantities
        float im1 = 1 / getRadius();
        float im2 = 1 / other.getRadius();

        //  push/pull apart based on mass
        float combined = im1 + im2;
        PVector move1 = PVector.mult(mtd, im1 / combined);
        PVector move2 = PVector.mult(mtd, im2 / combined);

        getPos().add(move1);
        other.getPos().add(move2);

        //  impact speed
        PVector v = PVector.sub(getVel(), other.getVel());
        float vn = v.dot(mtd.normalize());

        //  intersecting but already moving away from each other
        if (vn > 0.0f) {
            return;
        }

        //  collision impulse
        float n = (-(2.0) * vn) / combined;
        PVector impulse = PVector.mult(mtd, n);
        getVel().add(PVector.mult(impulse, im1));
        other.getVel().sub(PVector.mult(impulse, im2));

    }
}
