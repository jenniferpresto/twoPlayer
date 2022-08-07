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
                Integer playerId = addPlayer(pointerId);
                if (playerId != null) {
                    app.onPlayerAdded(playerId, point);
                }
                break;

            case MotionEvent.ACTION_MOVE:
                //  pointer was moved; will have info for all active pointers
                for (int i = 0; i < e.getPointerCount(); i++) {
                    PointF existingPoint = mActivePointers.get(e.getPointerId(i));
                    if (existingPoint != null) {
                        existingPoint.x = e.getX(i);
                        existingPoint.y = e.getY(i);
                        if (e.getPointerId(i) == mPlayer1Id) {
                            app.onPlayerMoved(1, existingPoint);
                        } 
                        else if (e.getPointerId(i) == mPlayer2Id) {
                            app.onPlayerMoved(2, existingPoint);
                        }
                    }
                }
                break;

            case MotionEvent.ACTION_UP:
            case MotionEvent.ACTION_POINTER_UP:
            case MotionEvent.ACTION_CANCEL:
                mActivePointers.remove(pointerId);
                Integer delPlayerId = removePlayer(pointerId);
                if (delPlayerId != null) {
                    app.onPlayerRemoved(delPlayerId);
                }
                break;
        }
    }

    Integer addPlayer(int pointerId) {
        println("Adding player: " + pointerId);
        if (mPlayer1Id == null) {
            mPlayer1Id = pointerId;
            return 1;
        } else if (mPlayer2Id == null) {
            mPlayer2Id = pointerId;
            return 2;
        } else {
            println("Already have two players");
            return null;
        }
    }

    Integer removePlayer(int pointerId) {
        println("Removing player: " + pointerId);
        if (mPlayer1Id != null && mPlayer1Id.equals(pointerId)) {
            mPlayer1Id = null;
            return 1;
        } else if (mPlayer2Id != null && mPlayer2Id.equals(pointerId)) {
            mPlayer2Id = null;
            return 2;
        } else {
            println("Did not remove player");
            return null;
        }
    }
}
