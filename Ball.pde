class Ball {
    color mCol;
    float mRad;
    float mMass;
    PVector mPos;
    PVector mVel;
    
    Ball() {
        
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
    
    void collideOtherBall(Ball other) {
        PVector diff = PVector.sub(mPos, other.getPos());
        float mag = diff.mag();
        float minDist = mRad + other.getRadius();
        //  if not touching, nothing to do
        if (mag > minDist) {
            return;
        }
        
        //  place them so they're not overlapping
        float distCorrection = (minDist - mag) / 2.0;
        PVector d = diff.copy();
        PVector correctionVector = d.normalize().mult(distCorrection);
        other.getPos().add(correctionVector);
        mPos.sub(correctionVector);
        
        //  angle of diff
        float theta = diff.heading();
        float sine = sin(theta);
        float cosine = cos(theta);
        
        //  temp arrays to hold positions and velocities
        PVector[] posTemp = {
            new PVector(), new PVector()
        };
        
        PVector[] velTemp = {
            new PVector(), new PVector()
        };
        
        //  ball's position relative to the other
        //  posTemp[0] will initialize to (0, 0), which we keep
        //  calculate posTemp[1] in relation to that
        posTemp[1].x = cosine * diff.x + sine * diff.y;
        posTemp[1].y = cosine * diff.y - sine * diff.x;
        
        //  rotate temporary velocities
        velTemp[0].x = cosine * mVel.x + sine * mVel.y;
        velTemp[0].y = cosine * mVel.y - sine * mVel.x;
        velTemp[1].x = cosine * other.getVel().x + sine * other.getVel().y;
        velTemp[1].y = cosine * other.getVel().y - sine * other.getVel().x;

        //  arrays with final values
        PVector[] posFinal = {
            new PVector(), new PVector()
        };

        PVector[] velFinal = {
            new PVector(), new PVector()
        };

        //  1D conservation of momentum equations to calculate
        //  velocity along the x-axis
        velFinal[0].x = ((mMass - other.getMass()) * velTemp[0].x + 2 * other.getMass() * velTemp[1].x) / (mMass + other.getMass());
        velFinal[0].y = velTemp[0].y;
        velFinal[1].x = ((other.getMass() - mMass) * velTemp[1].x + 2 * mMass * velTemp[0].x) / (mMass + other.getMass());
        velFinal[1].y = velTemp[1].y;

        //  hack to avoid clumping, according to reference
        posTemp[0].x += velFinal[0].x;
        posTemp[1].x += velFinal[1].x;

        //  rotate ball positions and velocities back
        posFinal[0].x = cosine * posTemp[0].x - sine * posTemp[0].y;
        posFinal[0].y = cosine * posTemp[0].y + sine * posTemp[0].x;
        posFinal[1].x = cosine * posTemp[1].x - sine * posTemp[1].y;
        posFinal[1].y = cosine * posTemp[1].y + sine * posTemp[1].y;

        //  update positions of both balls
        other.getPos().x = other.getPos().x + posFinal[1].x;
        other.getPos().y = other.getPos().y + posFinal[1].y;

        mPos.add(posFinal[0]);

        //  update velocities
        mVel.x = cosine * velFinal[0].x - sine * velFinal[0].y;
        mVel.y = cosine * velFinal[0].y + sine * velFinal[0].x;
        other.getVel().x = cosine * velFinal[1].x - sine * velFinal[1].y;
        other.getVel().y = cosine * velFinal[1].y + sine * velFinal[1].x;
    }
}
