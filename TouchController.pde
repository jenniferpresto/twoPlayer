//  Reference
//  https://www.vogella.com/tutorials/AndroidTouch/article.html

import android.graphics.PointF;

class TouchController {
    Map<Integer, PointF> mActivePointers;
    boolean mIsClicking;
    Integer mClickId;
    float mTimeClickStarted;
    PVector mClickStartPoint;
    float MAX_DRAG_DISTANCE = 10 * displayDensity;

    TouchController() {
        mActivePointers = new HashMap();
    }

    Map<Integer, PointF> getActivePointers() { return mActivePointers; }

    void processTouches(processing.test.twoplayer.twoPlayer app, MotionEvent e) {
        //  pointer index from event object
        int pointerIndex = e.getActionIndex();
        //  pointer ID
        int pointerId = e.getPointerId(pointerIndex);
        //  masked (not specific to pointer) action
        int maskedAction = e.getActionMasked();
        
        switch(maskedAction) {
            case MotionEvent.ACTION_DOWN:
            case MotionEvent.ACTION_POINTER_DOWN:
                //  new pointer
                PointF point = new PointF();
                point.x = e.getX(pointerIndex);
                point.y = e.getY(pointerIndex);
                mActivePointers.put(pointerId, point);
                app.onTouchStarted(pointerId);

                //  clicking
                if (!mIsClicking) {
                    mClickId = pointerId;
                    mTimeClickStarted = millis();
                    mIsClicking = true;
                    mClickStartPoint = new PVector(point.x, point.y);
                }

                break;

            case MotionEvent.ACTION_MOVE:
                //  TODO: nothing currently happens with this
                //  pointer was moved; will have info for all active pointers
                for (int i = 0; i < e.getPointerCount(); i++) {
                    PointF existingPoint = mActivePointers.get(e.getPointerId(i));
                    if (existingPoint != null) {
                        existingPoint.x = e.getX(i);
                        existingPoint.y = e.getY(i);
                    }
                }
                break;

            case MotionEvent.ACTION_UP:
            case MotionEvent.ACTION_POINTER_UP:
            case MotionEvent.ACTION_CANCEL:
                mActivePointers.remove(pointerId);
                app.onTouchEnded(pointerId);

                //  clicking
                if (pointerId == mClickId) {
                    mIsClicking = false;
                    PVector clickEndPoint = new PVector();
                    clickEndPoint.x = e.getX(pointerIndex);
                    clickEndPoint.y = e.getY(pointerIndex);
                    float dist = PVector.dist(clickEndPoint, mClickStartPoint);
                    if (millis() - mTimeClickStarted < 1000 &&
                        dist < MAX_DRAG_DISTANCE) {
                        app.onClick(clickEndPoint);
                    }
                }

                break;

            default:
                break;
        }
    }
}
