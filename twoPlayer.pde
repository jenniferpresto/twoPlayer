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
import java.util.List;
import java.util.ArrayList;
import processing.event.TouchEvent;

Context context;

static color BACKGROUND_COLOR;

//  controllers
TouchController mTouchController;
GameController mGameController;

List<Integer> mTouchIdsStarting;
List<Integer> mTouchIdsEnding;


Player mPlayer1;
Player mPlayer2;

void setup() {
    println("Setting up; displayDensity: " + displayDensity);
    println("Class: " + this.getClass());
    String[] fonts = PFont.list();
    println("All loaded fonts:");
    for (String f : fonts) {
      println("\t" + f);
    }

    mTouchIdsStarting = new ArrayList();
    mTouchIdsEnding = new ArrayList();

    fullScreen();
    colorMode(HSB, 360, 100, 100);
    BACKGROUND_COLOR = color(49, 76, 58); // tan green
    
    mTouchController = new TouchController();
    mGameController = new GameController(mTouchController);
    textFont(createFont("sansSerif", 24 * displayDensity));
    textAlign(CENTER, CENTER);
    ellipseMode(RADIUS);
    rectMode(CENTER);
    context = getActivity();

}

void draw() {
    textAlign(CENTER, CENTER);
    background(BACKGROUND_COLOR);
    if (mTouchIdsStarting.length > 0) {
        mGameController.reportStartingTouches(mTouchIdsStarting);
        mTouchIdsStarting.clear();
    }
    if (mTouchIdsEnding.length > 0) {
        mGameController.reportEndingTouches(mTouchIdsEnding);
        mTouchIdsEnding.clear();
    }
    mGameController.update();
    mGameController.draw();
}

//  processing event
void getTouches() {
}

void mousePressed() {
}

void mouseReleased() {
}

void onPlayerAdded(Integer playerNum, PointF pos) {
    if (!mGameController.getIsGameOver()) {
        mGameController.addPlayer(playerNum, pos);
    }
}

void onTouchStarted(Integer touchId, PointF pos) {
    mTouchIdsStarting.add(touchId);
    // mGameController.touchAdded(touchId, pos);
}

void onTouchEnded(Integer touchId) {
    mTouchIdsEnding.add(touchId);

}

void onPlayerMoved(Integer playerNum, PointF pos) {
    if (!mGameController.getIsGameOver()) {
        mGameController.updatePlayer(playerNum, pos);
    }
}

void onPlayerRemoved(Integer playerNum) {
    if (!mGameController.getIsGameOver()) {
        mGameController.removePlayer(playerNum);
    }
}

void onClick(PVector pos) {
    println("End click at " + pos);
    if (mGameController.getIsGameOver() &&
        mGameController.clickIsInButton(pos)) {
            println("We're clicking!");
            mGameController.resetGame();
            mTouchController.resetGame();
        }
}

@Override
boolean surfaceTouchEvent(MotionEvent e) {
    mTouchController.processTouches(this, e);
    return super.surfaceTouchEvent(e);
}


//  Processing event
void touchStarted() {
    // print("Started, no parameters");
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
