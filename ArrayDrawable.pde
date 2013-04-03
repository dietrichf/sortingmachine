class ArrayDrawable implements Drawable {

	private int[] a;

	Integrator x, y;
	Integrator dwidth, dheight;
	Integrator topMargin, rightMargin, bottomMargin, leftMargin;

	int max = Integer.MIN_VALUE;

	private BarDrawable[] bars;

	ArrayDrawable(int[] a, float dwidth, float dheight, float topMargin, float rightMargin, float bottomMargin, float leftMargin) {
		this.a = a;
		this.dwidth = new Integrator(dwidth);
		this.dheight = new Integrator(dheight);
		this.topMargin = new Integrator(topMargin);
		this.rightMargin = new Integrator(rightMargin);
		this.bottomMargin = new Integrator(bottomMargin);
		this.leftMargin = new Integrator(leftMargin);
	}

	public void place(Point p) {
		this.x = new Integrator(p.x);
		this.y = new Integrator(p.y);
	}

	public float getWidth() {
		return dwidth.target;
	}

	public float getHeight() {
		return dheight.target;
	}

	public void execute(Instruction instruction) {
		if(instruction.swap()) {
			int lo = instruction.lo();
			int hi = instruction.hi();
			// swap value positions
			int tmp = a[lo];
			a[lo] = a[hi];
			a[hi] = tmp;
			// swap bar positions
			BarDrawable b = bars[lo];
			bars[lo] = bars[hi];
			bars[hi] = b;
			bars[lo].exchange(bars[hi]);
		}

		// distribute state to all bars
		for(int i = 0; i < bars.length; i++) {
			bars[i].setControlPoint(instruction.isControlPoint(i));
			bars[i].setComparing(i == instruction.hi() || i == instruction.lo());
			bars[i].setSwapping(instruction.swap());
		}
	}

	public void setup() {
		for(int value : a) {
			if(value > max) {
				max = value;
			}
		}
		bars = new BarDrawable[a.length];
		float visibleWidth = dwidth.value - leftMargin.value - rightMargin.value;
		float visibleHeight = dheight.value - topMargin.value - bottomMargin.value;
		float barWidth = visibleWidth/(float)bars.length;
		for(int i = 0; i < bars.length; i++) {
			float fractionalHeight = (float)a[i]/(float)max;
			// give the bar an x, y relative to the position of this drawable
			bars[i] =
				new BarDrawable(
					barWidth,
					fractionalHeight * visibleHeight,
					0, 0, 0, 30);
			bars[i].place(
				new Point(
					leftMargin.value + (float)i*barWidth,
					dheight.value - bottomMargin.value - (visibleHeight * fractionalHeight)
				));
		}
	}

	public void setColor(int r, int g, int b, int a) {
		for(BarDrawable bar : bars) {
			bar.r.set((float)r);
			bar.g.set((float)g);
			bar.b.set((float)b);
			bar.a.set((float)a);
		}
	}

	public void targetColor(int r, int g, int b, int a) {
		for(BarDrawable bar : bars) {
			bar.r.target((float)r);
			bar.g.target((float)g);
			bar.b.target((float)b);
			bar.a.target((float)a);
		}
	}

	public void reposition(float _x, float _y, float w, float h, float tm, float rm, float bm, float lm) {
		x.target(_x);
		y.target(_y);
		topMargin.target(tm);
		rightMargin.target(rm);
		bottomMargin.target(bm);
		leftMargin.target(bm);
		dwidth.target(w);
		dheight.target(h);
		float visibleWidth = dwidth.target - leftMargin.target - rightMargin.target;
		float visibleHeight = dheight.target - topMargin.target - bottomMargin.target;
		float barWidth = visibleWidth/(float)bars.length;
		for(int i = 0; i < a.length; i++) {
			float fractionalHeight = (float)a[i]/(float)max;
			BarDrawable bar = bars[i];
			bar.bwidth.target(barWidth);
			bar.bheight.target(visibleHeight * fractionalHeight);
			bar.x.target(leftMargin.target + i*barWidth);
			bar.y.target(dheight.target - bottomMargin.target - (visibleHeight * fractionalHeight));
		}
	}

	public void tick() {
		x.tick();
		y.tick();
		dwidth.tick();
		dheight.tick();
		topMargin.tick();
		rightMargin.tick();
		bottomMargin.tick();
		leftMargin.tick();
		for(BarDrawable d : bars) {
			d.tick();
		}
	}

	public void draw() {
		pushMatrix();
		translate(x.value, y.value);
		for(BarDrawable d : bars) {
			d.draw();
		}
		popMatrix();
	}

	public ArrayDrawable clone() {
		ArrayDrawable out =
			new ArrayDrawable(
				copy(a),
				dwidth.target, dheight.target,
				topMargin.target, rightMargin.target, bottomMargin.target, leftMargin.target
			);
		out.place(new Point(x.target, y.target));
		return out;
	}
}

