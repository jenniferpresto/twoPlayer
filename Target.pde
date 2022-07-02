class Target {
    color col;
    float rad;
    PVector pos;
    PVector vel;

    Target() {

    }

    void setColor(color c) {
        col = c;
    }

    void setRadius(float r) {
        rad = r * displayDensity;
    }
}