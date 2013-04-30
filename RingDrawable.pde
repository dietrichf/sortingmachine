class RingDrawable implements Drawable {

	float w, h;
	float x, y;
	int[] a;
	int max = Integer.MIN_VALUE;
	float arcStep;
	int c;

	RingDrawable(float w, float h, int[] a, int c) {
		this.w = w;
		this.h = h;
		this.a = new int[a.length];
		for(int i = 0; i < a.length; i++) {
			this.a[i] = a[i];
		}
		arcStep = w / a.length;
		this.c = c;
	}

	void setup() {
		for(int i = 0; i < a.length; i++) {
			max = max(a[i], max);
		}
	}

	void draw() {
		pushMatrix();
		pushStyle();
		translate(x + w/2f, y + h/2f);
		float arcRadians = QUARTER_PI;
		for(int i = 0; i < a.length; i++) {
			stroke(0);
			float r = arcStep * i;
			float start = ((float)a[i]/(float)max) * TWO_PI;
			float end = start + arcRadians;
			noFill();
			strokeWeight(1f);
			stroke(c);
			arc(0, 0, r, r, start, end);
		}
		popStyle();
		popMatrix();
	}

	void tick() {}

	void place(Point p) {
		this.x = p.x;
		this.y = p.y;
	}

	float getWidth() { return w; }
	float getHeight() { return h; }

	void setColor(int clr) {
		this.c = clr;
	}

	RingDrawable clone() {
		RingDrawable d = new RingDrawable(w, h, a, c);
		d.setup();
		return d;
	}
}
