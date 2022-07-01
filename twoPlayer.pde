/**
Some nice references:
http://bocilmania.com/2018/04/21/how-to-get-reflection-vector/
For more intricate animations:
https://processing.org/examples/circlecollision.html
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

void setup() {
    println("Setting up; displayDensity: " + displayDensity);
    fullScreen();
    colorMode(HSB, 360, 100, 100);
    backgroundCol = color(49, 76, 58); // tan green
    player1Col = color(177, 71, 88); // aqua
    player2Col = color(311, 61, 88); // lilac

    textFont(createFont("sansSerif", 24 * displayDensity));
    textAlign(CENTER, CENTER);
    ellipseMode(RADIUS);
    rectMode(CENTER);
    context = getActivity();
    
    print("Display density is " + displayDensity);

}

void draw() {
    background(backgroundCol);
    for (int i = 0; i < touches.length; i++) {
        float d = (100 + 100 + touches[i].area) * displayDensity;
        fill(0, 255 * touches[i].pressure);
        ellipse(touches[i].x, touches[i].y, d, d);
        fill(player1Col);
        text(touches[i].id, touches[i].x + d/2, touches[i].y - d/2);
    }
}

void mousePressed() {
}

void mouseReleased() {
}

@Override
boolean surfaceTouchEvent(MotionEvent e) {
    int numPointers = e.getPointerCount();
    for (int i = 0; i < numPointers; i++) {
        int id = e.getPointerId(i);
        float x = e.getX(i);
        float y = e.getY(i);
    }
    
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
