final int NUM_BALLS = 10;

class BallController {
    ArrayList<Ball> mBalls;
    
    BallController() {}
    
    void setup() {
        mBalls = new ArrayList<Ball>();
        for (int i = 0; i < NUM_BALLS; i++) {
            //  random color
            color randCol = color(random(360), 100, 100);
            
            //  random radius
            float randRad = random(30, 40);
            
            //  random position
            float randX = random(randRad, displayWidth - randRad);
            float randY = random(randRad, displayHeight - randRad);
            
            //  random velocity
            float xVel = random( -3, 3);
            float yVel = random( -3, 3);
            
            Ball ball = new Ball();
            ball.setColor(randCol);
            ball.setRadius(randRad);
            ball.setPos(new PVector(randX, randY));
            ball.setVel(new PVector(xVel, yVel));
            mBalls.add(ball);
        }
    }
    
    void update() {
        for (Ball b : mBalls) {
            b.update();
            b.collideWalls();
        }
        mBalls.get(0).collideOtherBall(mBalls.get(1));
    }
    
    void draw() {
        for (Ball b : mBalls) {
            b.draw();
        }
    }
}
