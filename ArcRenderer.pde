class ArcRenderer implements Drawable {

	private final SortingMachine m;
	private List<Drawable> drawables;

	ArcRenderer(SortingMachine m) {
		this.m = m;
	}

	void setup() {
		m.setup();
		size(1024, 768);

		SortJob job = m.getSortJobs().get(0);
		println(job.toString());

		drawables = Lists.newArrayList();
		List<Instruction> program = job.getInstructions();
		int[] data = job.getData().getValues();

		// count the number of swaps so we know how many glyphs to draw and hence how to size them
		int n = 0;
		for(int i = 0; i < program.size(); i++) {
			if(i == 0 || i == program.size()-1 || program.get(i).swap()) {
				n++;
			}
		}

		int ny = floor(sqrt(4f*n/3f));
		int nx = floor(4f*ny/3f);

		println(nx + " x " + ny);

		float gsize = .96*width/(float)nx;
		println("size -> " + gsize);
		
		Layout layout =
			new Layout(0, 0, width, height);

		List<RingDrawable> arcGlyphs = Lists.newArrayList();
		for(Instruction instruction : program) {
			if(arcGlyphs.isEmpty()) {
				arcGlyphs.add(newArcSet(data, gsize, 100));
			}
			instruction.exec(data);
			if(instruction.swap()) {
				arcGlyphs.add(newArcSet(data, gsize, 100));
			}
		}

		float index = 0f;
		float inc = (float)n / (float)(nx*ny);

		// lay out all the glyphs by sampling across them to ensure they fill all available space
		// this means some will be duplicated but hopefully it's not too obvious
		for(int y = 0; y < ny; y++) {
			for(int x = 0; x < nx; x++) {
				int i = round(index);
				if(i < arcGlyphs.size()) {
					RingDrawable d = arcGlyphs.get(i).clone();
					d.place(new Point(10+x*gsize, 10+y*gsize));
					/*d.setColor(color(30, 10+10*x, 50+18*y, 150));*/
					drawables.add(d);
				}
				index += inc;
			}
		}
	}

	RingDrawable newArcSet(int[] data, float size, int c) {
		RingDrawable d = new RingDrawable(size, size, data, c);
		d.setup();
		return d;
	}

	void tick() { }

	void draw() {
		noLoop();
		beginRecord(PDF, "arcs.pdf");
		background(255, 255, 243);
		for(Drawable d : drawables) {
			d.draw();
		}
		endRecord();
	}

	float getWidth() { return width; }
	float getHeight() { return height; }
	void place(Point p) { }
}
