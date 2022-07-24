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
            println("Ball " + mLabel + ": collide right");
            mDidCollideWall = true;
            mPos.x = displayWidth - mRad;
            mVel.x *= -1;
        } else if (mPos.x < mRad) {
            println("Ball " + mLabel + ": collide left");
            mDidCollideWall = true;
            mPos.x = mRad;
            mVel.x *= -1;
        }
        
        if (mPos.y > displayHeight - mRad) {
            println("Ball " + mLabel + ": collide down");
            mDidCollideWall = true;
            mPos.y = displayHeight - mRad;
            mVel.y *= -1;
        } else if (mPos.y < mRad) {
            println("Ball " + mLabel + ": collide up");
            mDidCollideWall = true;
            mPos.y = mRad;
            mVel.y *= -1;   
        }
    }
    
    void collideOtherBall(Ball other) {
        //  keep number of collisions in one frame to one per ball
        if (mDidCollideWall) {
            return;
        }
        if (mDidCollideBall || other.getDidCollideBall()) {
            return;
        }
        PVector diff = PVector.sub(other.getPos(), mPos);
        float mag = diff.mag();
        float minDist = mRad + other.getRadius();
        //  if not touching, nothing to do
        if (mag > minDist) {
            return;
        }
        
        println("Colliding balls " + mLabel + ", " + other.getLabel());
        //  place them so they're not overlapping
        float distCorrection = (minDist - mag) / 2.0;
        PVector d = diff.copy();
        PVector correctionVector = d.normalize().mult(distCorrection);
        other.getPos().add(correctionVector);
        mPos.sub(correctionVector);
        
        //  angle of diff
        float theta = diff.heading();
        //  precalculate trig values
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
        posFinal[1].y = cosine * posTemp[1].y + sine * posTemp[1].x;


        // println("Collion between " + mLabel + " and " + other.getLabel());
        // println("Other pos first: " + other.getPos());
        // posFinal[1].add(mPos);
        // other.setPos(posFinal[1]);

        // other.setPos(other.getPos().add(posFinal[1]));

        // //  update positions of both balls
        other.getPos().x = mPos.x + posFinal[1].x;
        other.getPos().y = mPos.y + posFinal[1].y;

        // println("Other pos after: " + other.getPos());

        mPos.add(posFinal[0]);

        //  update velocities
        mVel.x = cosine * velFinal[0].x - sine * velFinal[0].y;
        mVel.y = cosine * velFinal[0].y + sine * velFinal[0].x;
        other.getVel().x = cosine * velFinal[1].x - sine * velFinal[1].y;
        other.getVel().y = cosine * velFinal[1].y + sine * velFinal[1].x;

        // //  move them away from the walls again, if necessary
        // collideWalls();
        // other.collideWalls();
    }
}
