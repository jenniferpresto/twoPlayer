//  Reference
//  https://www.vogella.com/tutorials/AndroidTouch/article.html

import android.graphics.PointF;

class TouchController {
    final processing.test.twoplayer.twoPlayer mApp;
    Map<Integer, PointF> mActivePointers;
    boolean mIsClicking = false;
    Integer mClickId;
    float mTimeClickStarted;
    PVector mClickStartPoint;
    final float MAX_DRAG_DISTANCE = 10 * displayDensity;

    TouchController(processing.test.twoplayer.twoPlayer app) {
        mApp = app;
        mActivePointers = new HashMap();
    }

    Map<Integer, PointF> getActivePointers() { return mActivePointers; }

    void processTouches(MotionEvent e) {
        int maskedAction = e.getActionMasked();
        
        switch(maskedAction) {
            case MotionEvent.ACTION_DOWN:
            case MotionEvent.ACTION_POINTER_DOWN:
                addNewPointer(e);
                break;

            case MotionEvent.ACTION_MOVE:
                //  pointer was moved; will have info for all active pointers
                for (int i = 0; i < e.getPointerCount(); i++) {
                    PointF existingPoint = mActivePointers.get(e.getPointerId(i));
                    if (existingPoint != null) {
                        existingPoint.x = e.getX(i);
                        existingPoint.y = e.getY(i);
                    }
                    //  if this is not an active pointer, it means it's new
                    //  report as a new touch
                    else {
                        println("Adding new pointer because of move and not down action");
                        addNewPointer(e);
                    }
                }
                break;

            case MotionEvent.ACTION_UP:
            case MotionEvent.ACTION_POINTER_UP:
            case MotionEvent.ACTION_CANCEL:
                //  pointer index from event object
                int pointerIndex = e.getActionIndex();
                //  pointer ID
                int pointerId = e.getPointerId(pointerIndex);
                //  masked (not specific to pointer) action

                mActivePointers.remove(pointerId);
                mApp.onTouchEnded(pointerId);

                //  clicking
                if (pointerId == mClickId) {
                    mIsClicking = false;
                    PVector clickEndPoint = new PVector();
                    clickEndPoint.x = e.getX(pointerIndex);
                    clickEndPoint.y = e.getY(pointerIndex);
                    float dist = PVector.dist(clickEndPoint, mClickStartPoint);
                    if (millis() - mTimeClickStarted < 1000 &&
                        dist < MAX_DRAG_DISTANCE) {
                        mApp.onClick(clickEndPoint);
                    }
                }

                break;

            default:
                break;
        }
    }

    void addNewPointer(MotionEvent e) {
        //  pointer index from event object
        int pointerIndex = e.getActionIndex();
        //  pointer ID
        int pointerId = e.getPointerId(pointerIndex);
        PointF point = new PointF();
        point.x = e.getX(pointerIndex);
        point.y = e.getY(pointerIndex);
        mActivePointers.put(pointerId, point);
        mApp.onTouchStarted(pointerId);

        //  clicking
        if (!mIsClicking) {
            mClickId = pointerId;
            mTimeClickStarted = millis();
            mIsClicking = true;
            mClickStartPoint = new PVector(point.x, point.y);
        }
    }
}
