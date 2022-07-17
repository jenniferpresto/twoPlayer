final int NUM_BALLS = 10;

class BallController {
    ArrayList<Ball> mBalls;

    BallController() {}

    void setup() {
        mBalls = new ArrayList<Ball>();
        for (int i = 0; i < NUM_BALLS; i++) {
            Ball ball = new Ball();
            ball.setRadius(20);
            ball.setPos(new PVector(random(displayWidth), random(displayHeight)));
            mBalls.add(ball);
        }
    }

    void draw() {
        for (Ball b : mBalls) {
            b.draw();
        }
    }

}