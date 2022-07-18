final int NUM_BALLS = 10;

class BallController {
    ArrayList<Ball> mBalls;
    
    BallController() {}
    
    void setup() {
        mBalls = new ArrayList<Ball>();
        for (int i = 0; i < NUM_BALLS; i++) {
            //  random color
            float randHue = random(360);
            color randCol = color(randHue, 100, 100);
            
            //  random radius
            float randRad = random(10, 20);
            
            //  random position
            float randX = random(randRad, displayWidth - randRad);
            float randY = random(randRad, displayHeight - randRad);
            
            //  random velocity
            float xVel = random( -2, 2);
            float yVel = random( -2, 2);
            
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
    }
    
    void draw() {
        for (Ball b : mBalls) {
            b.draw();
        }
    }
}
