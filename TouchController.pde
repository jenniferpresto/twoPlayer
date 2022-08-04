//  Reference
//  https://www.vogella.com/tutorials/AndroidTouch/article.html

import android.graphics.PointF;

class TouchController {
    Integer mPlayer1Id;
    Integer mPlayer2Id;
    Map<Integer, PointF> mActivePointers;

    TouchController() {
        mPlayer1Id = null;
        mPlayer2Id = null;
        mActivePointers = new HashMap();
    }

    Integer getPlayer1Id() { return mPlayer1Id; }
    Integer getPlayer2Id() { return mPlayer2Id; }

    PVector getPlayerPos(int playerNum) {
        Integer playerId = playerNum == 1 ? mPlayer1Id : mPlayer2Id;
        if (playerId == null) {
            return null;
        }
        if (!mActivePointers.containsKey(playerId)) {
            return null;
        }
        return new PVector(mActivePointers.get(playerId).x, mActivePointers.get(playerId).y);
    }

    void processTouches(MotionEvent e) {
        //  pointer index from event object
        int pointerIndex = e.getActionIndex();
        //  pointer ID
        int pointerId = e.getPointerId(pointerIndex);
        //  mased (not specific to pointer) action
        int maskedAction = e.getActionMasked();
        
        switch(maskedAction) {
            case MotionEvent.ACTION_DOWN:
            case MotionEvent.ACTION_POINTER_DOWN:
                //  new pointer
                PointF point = new PointF();
                point.x = e.getX(pointerIndex);
                point.y = e.getY(pointerIndex);
                mActivePointers.put(pointerId, point);
                addPlayer(pointerId);
                break;

            case MotionEvent.ACTION_MOVE:
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
                removePlayer(pointerId);
                break;
        }
    }

    void addPlayer(int id) {
        println("Adding player: " + id);
        if (mPlayer1Id == null) {
            mPlayer1Id = id;
        } else if (mPlayer2Id == null) {
            mPlayer2Id = id;
        } else {
            println("Already have two players");
        }
    }

    void removePlayer(int id) {
        println("Removing player: " + id);
        if (mPlayer1Id != null && mPlayer1Id.equals(id)) {
            mPlayer1Id = null;
        } else if (mPlayer2Id != null && mPlayer2Id.equals(id)) {
            mPlayer2Id = null;
        } else {
            println("Did not remove plalyer");
        }
    }
}
