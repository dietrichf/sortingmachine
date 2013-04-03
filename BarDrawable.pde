class BarDrawable implements Drawable {
	
	private Integrator x, y;
	private Integrator bwidth, bheight;
	private Integrator r, g, b, a;
	boolean controlPoint = false;
	boolean comparing = false;
	boolean swapping = false;

	BarDrawable(float bwidth, float bheight, int r, int g, int b, int a) {
		this.bwidth = new Integrator(bwidth);
		this.bheight = new Integrator(bheight);
		this.r = new Integrator((float)r);
		this.g = new Integrator((float)g);
		this.b = new Integrator((float)b);
		this.a = new Integrator((float)a);
	}

	public void place(Point p) {
		this.x = new Integrator(p.x);
		this.y = new Integrator(p.y);
	}

	public float getWidth() {
		return bwidth.target;
	}

	public float getHeight() {
		return bheight.target;
	}

	public void setup() { }

	public void tick() {
		x.tick();
		y.tick();
		bwidth.tick();
		bheight.tick();
		r.tick();
		g.tick();
		b.tick();
		a.tick();
	}

	public void setControlPoint(boolean test) {
		controlPoint = test;
	}

	public void setComparing(boolean test) {
		comparing = test;
	}

	public void setSwapping(boolean test) {
		swapping = test;
	}

	private int barAccentColor() {
		if(comparing && !swapping) {
			return color(255, 0, 0, 200);
		}
		else if(controlPoint) {
			return color(0, 0, 255, 200);
		}
		return -1;
	}

	public void draw() {
		pushStyle();
		noStroke();
		fill((int)r.value, (int)g.value, (int)b.value, (int)a.value);
		pushMatrix();
		translate(x.value, y.value);
		rect(0f, 0f, bwidth.value, bheight.value);
		int barAccent = barAccentColor();
		if(barAccent != -1) {
			fill(barAccent);
			rect(0f, bheight.value-2f, bwidth.value, 2f);
		}
		if(comparing) {
			fill(0, 0, 0, 255);
			beginShape(TRIANGLES);
			vertex(bwidth.value/2f-3f, bheight.value+5f);
			vertex(bwidth.value/2f+3f, bheight.value+5f);
			vertex(bwidth.value/2f   , bheight.value+2f);
			endShape();
		}
		popMatrix();
		popStyle();
	}

	public void exchange(BarDrawable in) {
		float tmpX = this.x.target;
		this.x.target(in.x.target);
		in.x.target(tmpX);
	}
}

