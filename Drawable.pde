interface Drawable {
	void setup();
	void tick();
	void draw();
	void place(Point p);
	float getWidth();
	float getHeight();
}

class Point {
	public float x, y;
	Point(float x, float y) {
		this.x = x;
		this.y = y;
	}
}

class Layout {

	float cursorX, cursorY;

	float left, top, right, bottom;

	Layout(float left, float top, float right, float bottom) {
		this.cursorX = left;
		this.cursorY = top;
		this.left = left;
		this.top = top;
		this.right = right;
		this.bottom = bottom;
	}

	// really stupid thing that assumes the next drawable will be of the same size
	// and we wrap to the next line if it wont fit
	Point place(Drawable d) {
		Point placement = new Point(cursorX, cursorY);
		d.place(new Point(cursorX, cursorY));
		cursorX += d.getWidth();
		if(cursorX + d.getWidth() > right) {
			cursorX = left;
			cursorY += d.getHeight() + 20;
		}
		return placement;
	}
}
