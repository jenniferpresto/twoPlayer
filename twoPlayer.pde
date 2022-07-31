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
color player1Col;
color player2Col;

//  scoring
int score = 0;
boolean gameOver = false;

//  controllers
TouchController mTouchController;
BallController mBallController;

Player mPlayer1;
Player mPlayer2;

void setup() {
    println("Setting up; displayDensity: " + displayDensity);
    fullScreen();
    colorMode(HSB, 360, 100, 100);
    backgroundCol = color(49, 76, 58); // tan green
    
    mTouchController = new TouchController();
    mBallController = new BallController();
    mBallController.setup();
    
    //  set up players
    player1Col = color(177, 71, 88); // aqua
    player2Col = color(311, 61, 88); // lilac
    mPlayer1 = new Player();
    mPlayer2 = new Player();
    mPlayer1.setColor(player1Col);
    mPlayer2.setColor(player2Col);
    
    
    textFont(createFont("sansSerif", 24 * displayDensity));
    textAlign(CENTER, CENTER);
    ellipseMode(RADIUS);
    rectMode(CENTER);
    context = getActivity();
    
    print("Display density is " + displayDensity);
    
    
}

void draw() {
    background(backgroundCol);
    
    mBallController.update();
    mBallController.draw();
    
    mPlayer1.setPos(mTouchController.getPlayerPos(1));
    mPlayer2.setPos(mTouchController.getPlayerPos(2));
    
    mPlayer1.draw();
    mPlayer2.draw();
}

void getTouches() {
}

void mousePressed() {
}

void mouseReleased() {
}

@Override
boolean surfaceTouchEvent(MotionEvent e) {
    mTouchController.processTouches(e);
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
