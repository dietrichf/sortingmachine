class BarDrawable implements Drawable {
	
	private Integrator x, y;
	private Integrator bwidth, bheight;
	private Integrator r, g, b, a;

	BarDrawable(float x, float y, float bwidth, float bheight, int r, int g, int b, int a) {
		this.x = new Integrator(x);
		this.y = new Integrator(y);
		this.bwidth = new Integrator(bwidth);
		this.bheight = new Integrator(bheight);
		this.r = new Integrator((float)r);
		this.g = new Integrator((float)g);
		this.b = new Integrator((float)b);
		this.a = new Integrator((float)a);
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

	public void draw() {
		pushStyle();
		noStroke();
		fill((int)r.value, (int)g.value, (int)b.value, (int)a.value);
		rect(x.value, y.value, bwidth.value, bheight.value);
		popStyle();
	}

	public void exchange(BarDrawable in) {
		float tmpX = this.x.target;
		this.x.target(in.x.target);
		in.x.target(tmpX);
	}
}

