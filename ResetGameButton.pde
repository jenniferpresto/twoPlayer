class ResetGameButton {

    float mCenterX;
    float mCenterY;
    float mWidth;
    float mHeight;
    float mRadius;
    String LABEL_TEXT = "Reset game";

    ResetGameButton() {
        mWidth = displayWidth * 0.5;
        mHeight = displayHeight * 0.1;
        mCenterX = (displayWidth / 2.0);
        mCenterY = (displayHeight / 2.0);
        mRadius = 10 * displayDensity;

        println("Width: " + mWidth);
        println("Height: " + mHeight);
        println("Top x: " + mCenterX);
        println("Top y: " + mCenterY);
    }
    
    boolean posIsInside(PVector pos) {
        return pos.x > mCenterX - (mWidth / 2) &&
               pos.x < mCenterX + (mWidth / 2) &&
               pos.y > mCenterY - (mHeight / 2) &&
               pos.y < mCenterY + (mHeight / 2);
    }
    
    boolean didClick(PVector clickPos) {
        println("did click");
        return false;
    }

    void draw() {
        rect(mCenterX, mCenterY, mWidth, mHeight, mRadius);
        fill(BACKGROUND_COLOR);
        text(LABEL_TEXT, mCenterX, mCenterY);
    }
}