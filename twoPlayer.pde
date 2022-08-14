/**
Some nice references:
http://bocilmania.com/2018/04/21/how-to-get-reflection-vector/
For more intricate animations:
https://processing.org/examples/circlecollision.html
Code for Art reference:
https://github.com/jeffcrouse/CodeForArt/blob/master/Chapter004-physics/004-collide/src/testApp.cpp
Multi-touch:
https://www.akeric.com/blog/?p=1435
Multi-touch:
https://stackoverflow.com/questions/17166522/can-processing-handle-multi-touch
*/

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.os.Bundle;
import android.view.MotionEvent;

import processing.sound.*;
import android.media.MediaPlayer;
import android.content.res.Resources;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.app.Activity;
import android.media.MediaPlayer.OnPreparedListener;

import java.util.Map;

Context context;

color backgroundCol;
// color player1Col;
// color player2Col;

//  scoring
// int score = 0;
boolean gameOver = false;

//  controllers
TouchController mTouchController;
// BallController mBallController;
GameController mGameController;


Player mPlayer1;
Player mPlayer2;

void setup() {
    println("Setting up; displayDensity: " + displayDensity);
    println("Class: " + this.getClass());
    fullScreen();
    colorMode(HSB, 360, 100, 100);
    backgroundCol = color(49, 76, 58); // tan green
    
    mTouchController = new TouchController();
    mGameController = new GameController();
    // mBallController = new BallController();
    // mBallController.setup();
    
    //  set up players
    // player1Col = color(177, 71, 88); // aqua
    // player2Col = color(311, 61, 88); // lilac
    // mPlayer1 = new Player();
    // mPlayer2 = new Player();
    // mPlayer1.setColor(player1Col);
    // mPlayer2.setColor(player2Col);
    
    textFont(createFont("sansSerif", 24 * displayDensity));
    textAlign(CENTER, CENTER);
    ellipseMode(RADIUS);
    rectMode(CENTER);
    context = getActivity();
}

void draw() {
    textAlign(CENTER, CENTER);
    background(backgroundCol);
    mGameController.update();
    mGameController.draw();
    
    // mBallController.update();
    // mBallController.draw();
    
    // mPlayer1.setPos(mTouchController.getPlayerPos(1));
    // mPlayer2.setPos(mTouchController.getPlayerPos(2));

    // ArrayList<Ball> ballsToBeRemoved = new ArrayList<Ball>();

    // for (Ball b : mBallController.getBalls()) {
    //     if (mTouchController.getPlayer1Id() != null) {
    //         if (mPlayer1.doesHitBall(b)) {
    //             mPlayer1.setScore(mPlayer1.getScore() + 1);
    //             ballsToBeRemoved.add(b);
    //         }
    //     }
    //     if (mTouchController.getPlayer2Id() != null) {
    //         if (mPlayer2.doesHitBall(b)) {
    //             mPlayer2.setScore(mPlayer2.getScore() + 1);
    //             if (!ballsToBeRemoved.contains(b)) {
    //                 ballsToBeRemoved.add(b);
    //             }
    //         }
    //     }
    // }

    // //  do this separately so both players can get
    // //  credit for a ball they hit at the same time
    // for(Ball b : ballsToBeRemoved) {
    //     mBallController.getBalls().remove(b);
    // }
    
    // mPlayer1.draw();
    // mPlayer2.draw();
    // fill(0, 0, 100);
    // textAlign(LEFT, TOP);
    // text("Player 1: " + mPlayer1.getScore(), 5 * displayDensity, 10 * displayDensity);
    // text("Player 2: " + mPlayer2.getScore(), 5 * displayDensity, 50 * displayDensity);

}

void getTouches() {
}

void mousePressed() {
}

void mouseReleased() {
}

void onPlayerAdded(Integer playerNum, PointF pos) {
    println("onPlayerAdded: Have a new touch for player: " + playerNum + ", pos: " + pos);
    mGameController.addPlayer(playerNum, pos);
}

void onPlayerMoved(Integer playerNum, PointF pos) {
    mGameController.updatePlayer(playerNum, pos);
}

void onPlayerRemoved(Integer playerNum) {
    mGameController.removePlayer(playerNum);
}

@Override
boolean surfaceTouchEvent(MotionEvent e) {
    mTouchController.processTouches(this, e);
    return super.surfaceTouchEvent(e);
}

//  Processing event
void touchStarted() {
    print("STarted, no parameters");
}


@Override
public void onResume() {
    println("onResume");
    super.onResume();
}

@Override
public void onPause() {
    println("onPause");
    super.onPause();
}

@Override
public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
}

@Override
public void onStop() {
    super.onStop();
}

@Override
public void onDestroy() {
    super.onDestroy();
}
